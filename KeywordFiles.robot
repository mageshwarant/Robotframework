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
        Wait Until Keyword Succeeds    ${YAHOO_WAIT_TIMEOUT}    ${YAHOO_RETRY_INTERVAL}    Wait Until Page Contains Element    ${YAHOO_SEARCH_BOX}    ${YAHOO_RETRY_INTERVAL}
        Wait Until Element Is Visible    ${YAHOO_SEARCH_BOX}    ${YAHOO_WAIT_TIMEOUT}
I Enter "${text}" Into The Search Box
        Set Test Variable    ${CURRENT_TICKER}    ${text}
        Click Element    ${YAHOO_SEARCH_BOX}
        Press Keys    ${YAHOO_SEARCH_BOX}    CTRL+A
        Press Keys    ${YAHOO_SEARCH_BOX}    ${text}
I Select The Option Matching "${company_name}"
        Wait Until Element Is Visible    xpath://li[contains(., "${company_name}")]    ${YAHOO_WAIT_TIMEOUT}
        Click Element    xpath:(//li[contains(., "${company_name}")])[1]
        Go To    https://finance.yahoo.com/quote/${CURRENT_TICKER}/
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
        
