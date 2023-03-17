# Initial Setup

## Select Project
To get started, select the project that contains your Shared VPC.

<walkthrough-project-setup></walkthrough-project-setup>

## Enable APIs
Set your current project by running the following command. You may need to login first, using `gcloud auth login`.
```sh
gcloud config set project <walkthrough-project-name/>
```

Once you're in the correct project, enable the APIs we need for the automation tool. <walkthrough-enable-apis apis="storage.googleapis.com,cloudbuild.googleapis.com">enable the APIs</walkthrough-enable-apis>

## Create Storage Bucket
Create a Google Cloud Storage bucket to maintain your Terraform state files. Each team will have its own statefile in this bucket.

You can use the command above to create a bucket, replacing `<BUCKET_NAME>` with a name for your bucket.

```sh
export bucket_name=BUCKET_NAME
```
```sh
gcloud storage buckets create gs://$bucket_name
```
## Set permissions to Cloud Build Service Account
Cloud Build will use its Service Account to run Terraform, build Firewall Rule resources, and manage storage bucket state. 

Set permissions to your storage bucket and to your project by running the following command:
```sh
export project_number=$(gcloud projects describe <walkthrough-project-name/> --format="value(projectNumber)")
gcloud storage buckets add-iam-policy-binding  gs://$bucket_name --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/storage.objectAdmin
gcloud projects add-iam-policy-binding <walkthrough-project-id-no-domain/> --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/compute.securityAdmin
```
