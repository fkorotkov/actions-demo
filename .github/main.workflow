workflow "Cirrus CI Demo" {
  on = "check_suite"
  resolves = "Cirrus CI Passes"
}

workflow "Send Email" {
  on = "check_suite"
  resolves = "Cirrus CI Email"
}

workflow "Rebase Comment" {
  on = "issue_comment"
  resolves = "Rebase"
}

action "Cirrus CI Passes" {
  uses = "docker://cirrusactions/check-suite:latest"
  env = {
    APP_NAME = "Cirrus CI"
  }
}

action "Cirrus CI Email" {
  uses = "./email/"
  env = {
    APP_NAME = "Cirrus CI"
  }
  secrets = ["GITHUB_TOKEN", "MAIL_FROM", "MAIL_HOST", "MAIL_USERNAME", "MAIL_PASSWORD"]
}

action "Rebase" {
  uses = "./rebase/"
  secrets = ["GITHUB_TOKEN"]
}
