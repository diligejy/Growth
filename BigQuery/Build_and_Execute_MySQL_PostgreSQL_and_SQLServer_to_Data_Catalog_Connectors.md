## 1. Task 1. Enable the Data Catalog API

1. Open the `Navigation menu` and select `APIs and Services > Library`.

2. In the search bar, enter in "Data Catalog" and select the `Google Cloud Data Catalog API`.

Then click `Enable`.

## Task 2. SQLServer to Data Catalog

Start by setting up your environment.

1. Run the following command to set your Project ID, replacing <YOUR_PROJECT_ID> with the Project ID found in the connection details panel:

    ```Shell
    gcloud config set project <YOUR_PROJECT_ID>
    ```
2. Next set it as an environment variable:

    ```Shell
    export PROJECT_ID=$(gcloud config get-value project)
    ```

### Create the SQLServer database

1. In your Cloud Shell session, run the following command to download the scripts to create and populate your SQLServer instance:

    ```Shell
    gsutil cp gs://spls/gsp814/cloudsql-sqlserver-tooling.zip .
    unzip cloudsql-sqlserver-tooling.zip
    ```