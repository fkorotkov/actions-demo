#!/bin/bash

set -e

# skip if no /rebase
echo "Checking if contains '/rebase' command..."
(jq -r ".comment.body" "$GITHUB_EVENT_PATH" | grep -E "/rebase") || exit 78

# skip if not a PR
echo "Checking if a PR command..."
(jq -r ".issue.pull_request.url" "$GITHUB_EVENT_PATH") || exit 78

PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")
echo "Collecting information about PR #$PR_NUMBER of $REPO_FULLNAME..."

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" \
          "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER")

BASE_REPO=$(echo "$pr_resp" | jq -r .base.repo.full_name)
BASE_BRANCH=$(echo "$pr_resp" | jq -r .base.ref)

if [[ "$(echo "$pr_resp" | jq -r .rebaseable)" != "true" ]]; then
	echo "GitHub doesn't think that the PR is rebaseable!"
	exit 1
fi

if [[ -z "$BASE_BRANCH" ]]; then
	echo "Cannot get base branch information for PR #$PR_NUMBER!"
  echo "API response: $pr_resp"
	exit 1
fi

HEAD_REPO=$(echo "$pr_resp" | jq -r .head.repo.full_name)
HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

echo "Base branch for PR #$PR_NUMBER is $BASE_BRANCH"

if [[ "$BASE_REPO" != "$HEAD_REPO" ]]; then
	echo "PRs from forks are not supported at the moment."
	exit 1
fi

git remote add upstream https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git

set -o xtrace

# make sure base is up-to-date
git fetch upstream $BASE_BRANCH
git checkout -b action-rebase/$BASE_BRANCH upstream/$BASE_BRANCH

# make sure the PR branch is up-to-date
git fetch upstream $HEAD_BRANCH
git checkout -b $HEAD_BRANCH upstream/$HEAD_BRANCH

# do the rebase
git rebase action-rebase/$BASE_BRANCH

# push back
git push --force
