# Initial Setup
For an interactive tutorial walkthrough, use the following link:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fzefdelgadillo%2Fgcp-firewall-delegation&cloudshell_git_branch=main&&cloudshell_tutorial=docs%2Fsetup.md)

## Select Project
To get started, select the project that contains your Shared VPC.

<walkthrough-project-setup></walkthrough-project-setup>

## Enable APIs
Once you're in the correct project, enable the APIs we need for the automation tool. <walkthrough-enable-apis apis="storage.googleapis.com,cloudbuild.googleapis.com">enable the APIs</walkthrough-enable-apis>

## Create Storage Bucket
Create a <walkthrough-menu-navigation sectionId="STORAGE_SECTION">Google Cloud Storage bucket</walkthrough-menu-navigation> to maintain your Terraform state files. Each team will have its own statefile in this bucket.

Note down the name of your Storage bucket, since we'll use it in the next step.
