workflow "Cirrus CI Demo" {
  on = "check_suite"
  resolves = "Cirrus CI Passes"
}

action "Cirrus CI Passes" {
  uses = "docker://cirrusci/actions-trigger:latest"
}

workflow "Automatic PR Rebase" {
  on = "pull_request"
  resolves = "PR Rebase"
}

action "PR Rebase" {
  uses = "docker://cirrusci/actions-rebase:latest"
}
