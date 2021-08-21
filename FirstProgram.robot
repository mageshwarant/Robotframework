*** Settings ***
Library     SeleniumLibrary
Resource    VariableFiles.robot
Resource    KeywordFiles.robot
*** Test Cases ***
TC1
    Open Browser    ${URL}   ${Browser}
    Maximize Browser Window
    Login with userid and password
    Element Should Be Visible  xpath://h3[text()='Accounting']
TC2
    Click Element   //span[text()='Support']