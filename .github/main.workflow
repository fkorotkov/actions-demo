workflow "Automatic Rebase" {
  on = "issue_comment"
  resolves = "Rebase"
}

action "Rebase" {
  uses = "docker://cirrusactions/rebase:latest"
  secrets = ["GITHUB_TOKEN"]
}

workflow "Discord" {
  on = "check_suite"
  resolves = "Discord Webhook"
}

action "Discord Webhook" {
  uses = "./discord-hooks/"
  secrets = ["WEBHOOK_URL"]
}