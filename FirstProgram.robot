*** Settings ***
Library     SeleniumLibrary
Resource    VariableFiles.robot
Resource    KeywordFiles.robot
Suite Setup     RobotSetup
Suite Teardown  RobotTeardown
*** Test Cases ***
TC1
    [Tags]      smoke       regression
    Element Should Be Visible  xpath://h3[text()='Accounting']
TC2
    [Tags]      regression
    Click Element   //span[text()='Support']
    Element Should Be Visible  xpath://h3[text()='Support']
TC3
    [Tags]      regression
    IF      'True'
    Log to Console  "True"
    ELSE
    Log to Console  "False"
    END