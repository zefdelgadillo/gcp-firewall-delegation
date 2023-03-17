# Google Cloud Firewall Rule Management
This example repository provides an approach for managing Google Cloud firewall rules in a Shared VPC across multiple teams using a GitOps approach. The infrastructure is deployed using Terraform, and the deployment prcoess is automated with Cloud Build.

## Setup
1. Complete the initial setup steps using this [tutorial](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fzefdelgadillo%2Fgcp-firewall-delegation&cloudshell_git_branch=main&cloudshell_tutorial=docs%2Fsetup.md&cloudshell_workspace=./). You'll only need to do this once.
2. Configure your teams by completing the following steps:
* * Create a directory for each team in `firewall-rules/` using the example template. Include a rules.yaml file and CODEOWNERS file.
* * Create an entry in team-config.yaml for each team that matches the team name directory. Add priority values in the format [lowest, highest]. See [priority values](#priority-values) for more information.

## Contributing
To contribute to this, create a pull request with your Firewall Rule. The pull request will trigger the automated validation of firewall rules using `gcloud terraform vet` (TODO). If any validation checks fail, the pull request will be blocked from merging.

Once the validation checks pass and the pull request is approved by one of the allowed approvers listed in the CODEOWNERS file, it can be merged. Merging the pull request will trigger the deployment of the updated firewall rules using Google Cloud Build and Terraform.

## Priority Values
To avoid conflicts and ensure that each team's rules are evaluated in the desired order, each team is allocated a priority range. 

For example, let's say you have three teams and you want to allocate equal priority blocks for each, you would configure your team-config.yaml file in this form:

```yaml
Team1: [1000, 2000]
Team2: [2000, 3000]
Team3: [3000, 4000]
```
These priority ranges ensure that each team can only use a specific range of priorities to prevent conflicts and maintain organized rule evaluation order.
