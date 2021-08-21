*** Keywords ***
RobotSetup
        Open Browser And Maximize
        Login with userid and password
RobotTeardown
        Close Browser Window
Login with userid and password
        Click Element   xpath://a[text() ='Login']
        Input Text   id:login_email     ${useremail}
        Input Text   id:login_password     ${Password}
        Click Element   xpath://button[contains(text(),'Login')]
        Set Selenium Implicit Wait      10
Open Browser And Maximize
        Open Browser    ${URL}   ${Browser}
        Maximize Browser Window
        Set Selenium Implicit Wait      2
Close Browser Window
        Close Browser
