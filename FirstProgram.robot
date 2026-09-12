*** Settings ***
Resource    VariableFiles.robot
Resource    KeywordFiles.robot
Library     OperatingSystem
Library     String
Suite Teardown    Close All Browsers

*** Test Cases ***
Search Companies And Verify Profile Pages
    ${csv}=    Get File    ${COMPANY_DATA_FILE}
    @{lines}=    Split To Lines    ${csv}
    FOR    ${line}    IN    @{lines}[1:]
        @{row}=    Split String    ${line}    ,
        ${ticker}=    Strip String    ${row}[0]
        ${company_name}=    Strip String    ${row}[1]
        Open Browser    ${YAHOO_URL}quote/${ticker}/    ${YAHOO_BROWSER}
        Wait Until Keyword Succeeds    ${YAHOO_RETRY_TIMEOUT}    ${YAHOO_RETRY_INTERVAL}    Current Location Should Match Quote Page
        I Should See The Profile Page Loaded For "${company_name}" ,"${ticker}"
        Close All Browsers
    END
