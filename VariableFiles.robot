*** Variables ***
${Browser}  Chrome
${YAHOO_URL}    https://finance.yahoo.com/
${YAHOO_BROWSER}    Chrome
${YAHOO_HEADLESS}    %{YAHOO_HEADLESS=false}
${YAHOO_SEARCH_BOX}    id=ybar-sbq
${YAHOO_FIRST_SEARCH_RESULT}    xpath:(//*[@data-test='srch-sym'])[1]
${COMPANY_DATA_FILE}    companies.csv
${SCREENSHOT_DIR}    screenshots
${YAHOO_WAIT_TIMEOUT}    30s
${YAHOO_RETRY_TIMEOUT}    30s
${YAHOO_RETRY_INTERVAL}    3s
