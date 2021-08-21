*** Settings ***
Library     SeleniumLibrary
Resource    VariableFiles.robot
Resource    KeywordFiles.robot
Suite Setup     RobotSetup
Suite Teardown  RobotTeardown
*** Test Cases ***
TC1
    Element Should Be Visible  xpath://h3[text()='Accounting']
TC2
    Click Element   //span[text()='Support']
    Element Should Be Visible  xpath://h3[text()='Support']
