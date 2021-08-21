*** Keywords ***
Login with userid and password
        Click Element   xpath://a[text() ='Login']
        Input Text   id:login_email     saravanan.ambi@lmnas.com
        Input Text   id:login_password     saran@123
        Click Element   xpath://button[contains(text(),'Login')]
        Set Selenium Implicit Wait      5