# Initial Setup

## Select Project
To get started, select the project that contains your Shared VPC.

<walkthrough-project-setup></walkthrough-project-setup>

## Enable APIs
Set your current project by running the following command. You may need to login first, using `gcloud auth login`.
```sh
gcloud config set project <walkthrough-project-name/>
```

Once you're in the correct project, enable the APIs we need for the automation tool. <walkthrough-enable-apis apis="compute.googleapis.com,storage.googleapis.com,cloudbuild.googleapis.com,secretmanager.googleapis.com">enable the APIs</walkthrough-enable-apis>

## Create Storage Bucket
Create a Google Cloud Storage bucket to maintain your Terraform state files. Each team will have its own statefile in this bucket.

You can use the command above to create a bucket, replacing `<BUCKET_NAME>` with a name for your bucket.

```sh
export bucket_name=BUCKET_NAME
```
```sh
gcloud storage buckets create gs://$bucket_name
```

## Configure Terraform backend
Open <walkthrough-editor-open-file startLine="2" endLine="4" startCharacterOffset="14" endCharacterOffset="14" filePath="./terraform/module/backend.tf">terraform/module/backend.tf</walkthrough-editor-open-file> and update the bucket name variable to include the name of your bucket. Exclude the `gs://` prefix.

Commit your changes in your clone of the repository.

## Set Shared VPC Network
We'll use Secret Manager to store the name of the Shared VPC and state file bucket. To create a secret, run the following:
```sh
gcloud secrets create shared-vpc-name
```
Set your Shared VPC network name using the following command, replacing `SHARED_VPC_NAME` with the name of your Shared VPC:
```sh
export shared_vpc=SHARED_VPC_NAME
```
Create secret versions that will be used for the build pipeline that manages Terraform rules:
```sh
echo -n $shared_vpc | gcloud secrets versions add shared-vpc-name --data-file=-
```

## Set permissions to Cloud Build Service Account
Cloud Build will use its Service Account to run Terraform, build Firewall Rule resources, and manage storage bucket state. 

Set permissions to your storage bucket and to your project by running the following command. If you run into an authorization issue, run `gcloud auth login`.
```sh
export project_number=$(gcloud projects describe <walkthrough-project-name/> --format="value(projectNumber)")
gcloud storage buckets add-iam-policy-binding gs://$bucket_name --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/storage.objectAdmin
gcloud storage buckets add-iam-policy-binding gs://$bucket_name --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/storage.admin
gcloud projects add-iam-policy-binding <walkthrough-project-id-no-domain/> --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/compute.securityAdmin
gcloud secrets add-iam-policy-binding shared-vpc-name --member=serviceAccount:$project_number@cloudbuild.gserviceaccount.com --role=roles/secretmanager.secretAccessor
```
## Test Cloud Build
Review the example Firewall Rule configuration file, `firewall-rules/example/rules.yaml`. We'll run a Cloud Build that job will deploy this Firewall Rule as a test.
```sh
gcloud builds submit --config=cloudbuild.yaml .
```
This may take a few minutes to run for the first time. When complete, you should see `STATUS: SUCCESS`.

## Review Firewall Rule
Check to see if your Firewall Rule was created using `gcloud compute firewall-rules list`. If so, your pipeline completed successfully! 

You can now remove the example rule from the configuration file, and begin to configure your team directories.

## Setup Complete!
You can now begin to configure your team directories using the instructions in README.md
