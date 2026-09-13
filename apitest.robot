*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com
${POST_ID}     2

*** Test Cases ***
Get Post By ID
    [Documentation]    Fetch a post by ID - replicates run(post_id)
    Create Session    alias=jsonplaceholder    url=${BASE_URL}
    ${response}=    GET On Session    alias=jsonplaceholder    url=/posts/${POST_ID}
    Log    Success! Status Code: ${response.status_code}
    Log    Response Data: ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal As Integers    ${response.json()}[id]    ${POST_ID}

Delete Post By ID
    [Documentation]    Delete a post by ID - replicates delete(post_id)
    ${response}=    DELETE On Session    alias=jsonplaceholder    url=/posts/${POST_ID}
    Log    Success! Status Code: ${response.status_code}
    Log    Post ${POST_ID} deleted successfully
    Should Be Equal As Integers    ${response.status_code}    200

Get Post After Delete
    [Documentation]    Fetch post again after delete - replicates run(post_id) after delete
    ${response}=    GET On Session    alias=jsonplaceholder    url=/posts/${POST_ID}
    Log    Success! Status Code: ${response.status_code}
    Log    Response Data: ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
