workflow "Automatic Rebase" {
  on = "issue_comment"
  resolves = "Rebase"
}

action "Rebase" {
  uses = "./rebase/"
  secrets = ["GITHUB_TOKEN"]
}
