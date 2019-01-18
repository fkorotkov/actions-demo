workflow "Cirrus CI Demo" {
  on = "check_suite"
  resolves = "Cirrus CI Passes"
}

action "Cirrus CI Passes" {
  uses = "docker://cirrusactions/check-suite:latest"
  env = {
    APP_NAME = "Cirrus CI"
  }
}

workflow "Send Email" {
  on = "check_suite"
  resolves = "Cirrus CI Email"
}

action "Cirrus CI Email" {
  uses = "docker://cirrusactions/email:latest"
  env = {
    APP_NAME = "Cirrus CI"
  }
  secrets = ["GITHUB_TOKEN", "MAIL_FROM", "MAIL_HOST", "MAIL_USERNAME", "MAIL_PASSWORD"]
}
