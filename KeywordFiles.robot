*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem

*** Keywords ***
RobotSetup
        Open Browser And Maximize
        Login with userid and password
RobotTeardown
        Close Browser Window
Close Browser Window
        Close Browser
Open Yahoo Browser
        [Arguments]    ${url}
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Call Method    ${options}    add_argument    --window-size\=1920,1080
        IF    '${YAHOO_HEADLESS}' == 'true'
            Call Method    ${options}    add_argument    --headless\=new
            Call Method    ${options}    add_argument    --no-sandbox
            Call Method    ${options}    add_argument    --disable-dev-shm-usage
        END
        Open Browser    ${url}    ${YAHOO_BROWSER}    options=${options}
Search For Ticker And Open First Suggestion
        [Arguments]    ${ticker}
        Wait Until Element Is Visible    ${YAHOO_SEARCH_BOX}    ${YAHOO_WAIT_TIMEOUT}
        Input Text    ${YAHOO_SEARCH_BOX}    ${ticker}
        Wait Until Element Is Visible    ${YAHOO_FIRST_SEARCH_RESULT}    ${YAHOO_WAIT_TIMEOUT}
        Mouse Over    ${YAHOO_FIRST_SEARCH_RESULT}
        Click Element    ${YAHOO_FIRST_SEARCH_RESULT}
        Wait Until Keyword Succeeds    ${YAHOO_RETRY_TIMEOUT}    ${YAHOO_RETRY_INTERVAL}    Current Location Should Match Quote Page
I Should See The Profile Page Loaded For "${company_name}" ,"${ticker}"
        Current Location Should Match Quote Page
        Wait Until Page Contains    ${company_name}    ${YAHOO_WAIT_TIMEOUT}
        Wait Until Page Contains Element    xpath://h1[contains(@class,'heading')]    ${YAHOO_RETRY_INTERVAL}
        ${heading}=    Get Text    xpath://h1[contains(@class,'heading')]
        Log To Console    Heading text: ${heading}
        Should Contain    ${heading}    ${ticker}
        Should Contain    ${heading}    ${company_name}
Current Location Should Match Quote Page
        ${location}=    Get Location
        Should Match Regexp    ${location}    .*/quote/.*
        
