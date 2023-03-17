# Adding a New Team

Follow these steps to add a new team to the firewall-rules repository and configure their firewall rules.

## Create a Team Directory

* Navigate to the `firewall-rules` directory in your repository.
* Create a new directory named after the team (e.g., `team1`).
* Inside the newly created directory, create two files: `rules.yaml` and `CODEOWNERS`.
* Create an entry in `team-config.yaml` for each team that matches the team name directory. Add priority values in the format [lowest, highest]. See [priority values](../README.md#priority-values) for more information.

## Configure Team Firewall Rules

* Open the `rules.yaml` file in the new team directory.
* Define the team's firewall rules using the YAML format. Refer to the example in the `firewall-rules/example/rules.yaml` file and the README for the required structure and properties.
* Save the changes to the rules.yaml file.

## Set Up CODEOWNERS

* Open the `CODEOWNERS` file in the new team directory.
* Add the GitHub usernames or email addresses of the team members who are allowed to approve changes to the team's firewall rules. Each approver should be listed on a new line.
* Save the changes to the `CODEOWNERS` file.

## Test the New Team Configuration

* Commit and push the changes to the repository.
* Run a Cloud Build deployment to configure Firewall Rules using the following command from the root directory:
```sh
gcloud builds submit --config cloudbuild.yaml .
```
* Verify that the Cloud Build job deploys the new team's firewall rules by checking the Cloud Build logs and the Google Cloud Console.
After completing these steps, the new team's firewall rules will be managed by the firewall-rules repository, and they will be able to create and update their rules using the GitOps workflow.

## Configure GitHub Integration
To configure GitHub integration and set up builds to trigger on new Pull Requests, use these [instructions](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github).