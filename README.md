# Spanner Introspection Stats CLI

This tool provides a simple command-line interface to fetch performance and introspection statistics from Google Cloud Spanner's `SPANNER_SYS` tables. It uses a shell script and SQL templates to query introspection data for a specific interval resolutions.

Read more here: [https://cloud.google.com/spanner/docs/introspection](https://cloud.google.com/spanner/docs/introspection)

## Prerequisites
Before using this script, ensure you have the following installed and configured:

1.  **Google Cloud SDK (`gcloud`)**: The script relies on `gcloud` to interact with Spanner. Make sure it's installed and authenticated.
2.  **gcloud Alpha Components**: The Spanner CLI is an alpha feature. Install it by running:
    ```sh
    gcloud components install alpha
    ```
3.  **Permissions**: You must have the necessary IAM permissions (e.g., `spanner.databaseReader`, `spanner.sessions.create`) to access the target Spanner instance and its system tables.

## Files
*   `fetchstats.sh`: The main executable script that runs the queries.
*   `10min.sql` / `1hour.sql`: SQL template files containing queries against `SPANNER_SYS` tables. These files use a placeholder (`@HOUR_INTERVAL`) that the script replaces with a specific timestamp.

## How It Works

The `fetchstats.sh` script performs two main actions:

1.  It uses the `sed` command to read an SQL template file (like `10min.sql`).
2.  It replaces the placeholder string `@HOUR_INTERVAL` in the SQL file with the timestamp you provide as an argument.
3.  It pipes (`|`) the modified SQL directly to the `gcloud alpha spanner cli` command, which executes the queries against your specified database.

This process avoids the need to create and manage temporary SQL files.

## Usage

Run the `fetchstats.sh` script with four arguments: the Spanner instance name, the database name, the timestamp for the query interval, and the path to the SQL template file.

### Syntax

```sh
./fetchstats.sh [INSTANCE_NAME] [DATABASE_NAME] [TIMESTAMP] [SQL_FILE]
```

`TIMESTAMP`: Must be in `YYYY-MM-DDTHH:MM:SSZ` format

### Example

To run the queries from `10min.sql` against the `mydemodb` database for the 8:00 AM UTC interval on September 9, 2025:

```sh
./fetchstats.sh myspannerinstance mydemodb '2025-09-09T08:00:00Z' 10min.sql
```

To save the output to a file:

```sh
./fetchstats.sh myspannerinstance mydemodb '2025-09-09T08:00:00Z' 10min.sql > 20250909_0800_stats.txt
```