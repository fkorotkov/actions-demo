FROM alpine:latest

LABEL version="1.0.1"
LABEL repository="http://github.com/cirrus-actions/rebase"
LABEL homepage="http://github.com/cirrus-actions/rebase"
LABEL maintainer="Cirrus Labs"
LABEL "com.github.actions.name"="Rebase"
LABEL "com.github.actions.description"="Automatically rebases PR on /rebase comment"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="purple"

RUN apk --no-cache add jq bash curl git

ADD entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
