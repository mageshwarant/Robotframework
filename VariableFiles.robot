*** Variables ***
${Browser}  Chrome
${YAHOO_URL}    https://finance.yahoo.com/
${YAHOO_BROWSER}    Chrome
${YAHOO_HEADLESS}    %{YAHOO_HEADLESS=false}
${YAHOO_SEARCH_BOX}    xpath:(//input[contains(@placeholder, "Search")])[last()]
${COMPANY_DATA_FILE}    companies.csv
${SCREENSHOT_DIR}    screenshots
${YAHOO_WAIT_TIMEOUT}    30s
${YAHOO_RETRY_TIMEOUT}    30s
${YAHOO_RETRY_INTERVAL}    3s
