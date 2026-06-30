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
        I Navigate To "${YAHOO_URL}"
        I Enter "${ticker}" Into The Search Box
        I Select The Option Matching "${company_name}"
        I Should See The Profile Page Loaded For "${company_name}"
        Close All Browsers
    END
