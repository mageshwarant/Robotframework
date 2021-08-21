*** Keywords ***
Login with userid and password
        Click Element   xpath://a[text() ='Login']
        Input Text   id:login_email     XXXXXXX
        Input Text   id:login_password     XXXXX
        Click Element   xpath://button[contains(text(),'Login')]
        Set Selenium Implicit Wait      5