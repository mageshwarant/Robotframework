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
I Navigate To "${url}"
        Open Browser    ${url}    ${YAHOO_BROWSER}
        Wait Until Element Is Visible    ${YAHOO_S EARCH_BOX}    ${YAHOO_WAIT_TIMEOUT}
I Enter "${text}" Into The Search Box
        Set Test Variable    ${CURRENT_TICKER}    ${text}
        Click Element    ${YAHOO_SEARCH_BOX}
        Press Keys    ${YAHOO_SEARCH_BOX}    CTRL+A
        Press Keys    ${YAHOO_SEARCH_BOX}    ${text}
I Select The Option Matching "${company_name}"
        Wait Until Element Is Visible    xpath://li[contains(., "${company_name}")]    ${YAHOO_WAIT_TIMEOUT}
        Click Element    xpath:(//li[contains(., "${company_name}")])[1]
        Wait Until Keyword Succeeds    ${YAHOO_RETRY_TIMEOUT}    ${YAHOO_RETRY_INTERVAL}    Current Location Should Match Quote Page
I Should See The Profile Page Loaded For "${company_name}"
        Current Location Should Match Quote Page
        Wait Until Element Is Visible    xpath://h1[contains(., "${company_name}")]    ${YAHOO_WAIT_TIMEOUT}
        Create Directory    ${SCREENSHOT_DIR}
        Run Keyword And Ignore Error    Capture Page Screenshot    ${SCREENSHOT_DIR}/${CURRENT_TICKER.lower()}_page.png
Current Location Should Match Quote Page
        ${location}=    Get Location
        Should Match Regexp    ${location}    .*/quote/.*
