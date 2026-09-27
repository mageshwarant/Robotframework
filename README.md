# Robot Framework Tests

This project contains Robot Framework tests for both browser-based Yahoo Finance validation and API testing against JSONPlaceholder.

## What the tests do

### `FirstProgram.robot` - Yahoo Finance Browser Tests

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

### `apitest.robot` - API Tests

API tests that replicate the Python `apitest.py` Playwright script using Robot Framework's RequestsLibrary:

1. **Get Post By ID** - Fetches a post by ID from JSONPlaceholder API (`https://jsonplaceholder.typicode.com/posts/2`)
2. **Delete Post By ID** - Deletes a post by ID
3. **Get Post After Delete** - Verifies post can still be fetched after delete operation

The tests use `RequestsLibrary` with session management to test GET and DELETE operations against the JSONPlaceholder API.

## Project files

| File | Purpose |
| --- | --- |
| `FirstProgram.robot` | Yahoo Finance browser test suite and CSV loop. |
| `apitest.robot` | API tests for JSONPlaceholder using RequestsLibrary. |
| `KeywordFiles.robot` | Reusable SeleniumLibrary keywords and page validations. |
| `VariableFiles.robot` | URLs, browser settings, locators, timeouts, and file paths. |
| `companies.csv` | Company ticker and name test data. |
| `Jenkinsfile` | Jenkins pipeline for installing Python dependencies and running Robot tests through Maven. |
| `pom.xml` | Maven profiles for running the Yahoo Finance and API Robot suites. |
| `log.html` | Detailed report from the latest local run. |
| `report.html` | Summary report from the latest local run. |
| `output.xml` | Robot Framework machine-readable output. |

## Prerequisites

- Python 3.10 or newer
- Google Chrome
- A working ChromeDriver setup supported by Selenium
- Java 8 or newer (required by Maven)
- Internet access to `finance.yahoo.com` and `jsonplaceholder.typicode.com`

Create the project virtual environment and install the packages with:

```powershell
python -m venv venv
.\\venv\\Scripts\\python -m pip install -r requirements.txt
```

## Run the tests locally

Open PowerShell in the project directory and run:

### Yahoo Finance Tests
```powershell
python -m robot .\FirstProgram.robot
```

### API Tests
```powershell
python -m robot .\apitest.robot
```

### Run Both Tests Sequentially
```powershell
python -m robot .\FirstProgram.robot
python -m robot .\apitest.robot
```

Robot Framework writes the test results to the project directory by default. Open `report.html` for the summary or `log.html` for detailed execution information.

## Run the tests through Maven

Use the included Maven wrapper. It downloads Maven automatically on its first run, so a system-wide `mvn` installation is not required.

```powershell
.\\mvnw.cmd -Pyahoo verify
.\\mvnw.cmd -Papi verify
```

To write results to separate directories:

```powershell
python -m robot --outputdir results\FirstProgram .\FirstProgram.robot
python -m robot --outputdir results\apitest .\apitest.robot
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

The `Jenkinsfile` installs the Python test dependencies on the Jenkins node, runs both suites through the included Maven wrapper, and archives the generated results. The Jenkins agent needs Python, Java, Google Chrome, and a compatible ChromeDriver setup.

**Execution Order:**
1. `FirstProgram.robot` - Yahoo Finance browser tests
2. `apitest.robot` - JSONPlaceholder API tests

**Pipeline Stages:**
- **Setup Python Environment**: Creates virtual environment and installs `robotframework`, `robotframework-seleniumlibrary`, `robotframework-requests`, and optional requirements
- **Run Yahoo Finance Tests / Run API Tests**: Runs the Maven `yahoo` and `api` profiles sequentially, with separate output directories:
  - `results/FirstProgram` - Yahoo Finance test results
  - `results/apitest` - API test results

Run an individual suite locally after creating the Python virtual environment and installing the dependencies:

```powershell
.\\mvnw.cmd -Pyahoo verify
.\\mvnw.cmd -Papi verify
```

The pipeline runs Robot Framework on the Jenkins node, so Docker is not required. Configure Chrome for headless execution when the Jenkins service has no interactive desktop.

**Dependencies Installed:**
```powershell
pip install robotframework robotframework-seleniumlibrary robotframework-requests
```

## Notes

- Yahoo Finance is an external website, so page availability and layout changes can affect the test.
- Browser tests require an active graphical browser session unless Chrome is configured for headless execution.
- API tests use JSONPlaceholder which is a mock API for testing purposes. Responses are static and may not reflect real-world API behavior.
- The Jenkins pipeline runs tests sequentially. A Yahoo Finance failure is recorded, but the API stage still runs; the overall build remains failed.
- Do not commit credentials or other secrets to this repository.
