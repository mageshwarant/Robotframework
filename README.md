# Robot Framework Yahoo Finance Tests

This project contains a Robot Framework browser test that checks company profile pages on Yahoo Finance.

## What the test does

`FirstProgram.robot`:

1. Reads company tickers and names from `companies.csv`.
2. Opens the Yahoo Finance quote page for each ticker.
3. Waits until the browser is on a quote page.
4. Verifies that the profile heading contains both the ticker and company name.
5. Closes the browser before moving to the next company.

The current test data covers:

- Apple Inc. (`AAPL`)
- Microsoft Corporation (`MSFT`)
- Accenture plc (`ACN`)

The test uses direct quote URLs instead of relying on the Yahoo Finance search box, which makes navigation more stable.

## Project files

| File | Purpose |
| --- | --- |
| `FirstProgram.robot` | Main test suite and CSV loop. |
| `KeywordFiles.robot` | Reusable SeleniumLibrary keywords and page validations. |
| `VariableFiles.robot` | URLs, browser settings, locators, timeouts, and file paths. |
| `companies.csv` | Company ticker and name test data. |
| `Jenkinsfile` | Jenkins pipeline for installing Python dependencies and running Robot tests. |
| `log.html` | Detailed report from the latest local run. |
| `report.html` | Summary report from the latest local run. |
| `output.xml` | Robot Framework machine-readable output. |

## Prerequisites

- Python 3.10 or newer
- Google Chrome
- A working ChromeDriver setup supported by Selenium
- Internet access to `finance.yahoo.com`

Install the Python packages with:

```powershell
python -m pip install robotframework robotframework-seleniumlibrary selenium
```

## Run the test locally

Open PowerShell in the project directory and run:

```powershell
python -m robot .\FirstProgram.robot
```

Robot Framework writes the test results to the project directory by default. Open `report.html` for the summary or `log.html` for detailed execution information.

To write results to a separate directory:

```powershell
python -m robot --outputdir results .\FirstProgram.robot
```

## Adding another company

Add a row to `companies.csv` using this format:

```csv
ticker,company_name
TSLA,Tesla Inc.
```

The header row must remain in place, and the ticker must be valid on Yahoo Finance.

## Configuration

The main settings are in `VariableFiles.robot`:

- `YAHOO_BROWSER`: browser used by SeleniumLibrary.
- `YAHOO_WAIT_TIMEOUT`: maximum wait time for page elements.
- `YAHOO_RETRY_TIMEOUT`: maximum time for navigation retries.
- `YAHOO_RETRY_INTERVAL`: delay between navigation checks.
- `COMPANY_DATA_FILE`: CSV file containing the test data.

## Jenkins pipeline

The `Jenkinsfile` builds the Docker test-runner image, runs the suite in a headless Chrome container, and archives the generated results. The Jenkins node must have Docker installed and the Jenkins service account must be allowed to run `docker` commands.

To run the same isolated test runner locally:

```powershell
docker build -t robotframework-tests:local .
docker run --rm -e YAHOO_HEADLESS=true -v "${PWD}\\results:/app/results" robotframework-tests:local
```

The container exits when the Robot suite finishes. This is normal: it is a CI test-runner image, not a long-running application service. Jenkins archives `results/report.html`, `results/log.html`, and `results/output.xml` after the container ends.

Set `YAHOO_HEADLESS=false` for a local, visible Chrome session. Jenkins uses `YAHOO_HEADLESS=true` because a Windows Jenkins service normally has no interactive desktop.

## Notes

- Yahoo Finance is an external website, so page availability and layout changes can affect the test.
- Browser tests require an active graphical browser session unless Chrome is configured for headless execution.
- Do not commit credentials or other secrets to this repository.
