Feature: sample karate test script
  for help, see: https://github.com/intuit/karate/wiki/IDE-Support

  Background:
    * url 'https://qa-api.atmax.co/api/'

  Scenario: Roles API Automation
    Given path 'auth/login'
    And header Content-Type = 'application/json'
    And request {"email":"atmax@atmax.co","password":"Atmax@123","url":"https://atmax-qa.atmax.co/incentmax"}
    When method post
    Then status 200
    # And match response == 'success'
    And print 'Response is', response.token
    * def bToken = response.token

    #Test For Roles-->Fields API
    Given path 'v1/role/auto_role/fields'
    And header Authorization = 'Bearer ' + bToken
    When method get
    Then status 200
    And print 'Response is', response.data.fields.map(x => x)
    * def fieldValue = response.data.fields[7]
    # When def myArray = []
    # Then eval for(var i=0; i<response[0].data.fields.length;i++) myArray.add(response[0].data.fields[i])
  
    #Test For Create Roles
    Given path 'v1/role/auto_role/field/'+fieldValue
    And header Authorization = 'Bearer ' + bToken
    When method post
    When status 201
    Then print 'role created and response is', response.message

    #Test for role list
    Given path 'v1/role'
    And header Authorization = 'Bearer ' + bToken
    When method get
    Then status 200
    And print 'Response is', response.data.roles.map(x => x)
    * def roleId = response.data.roles[37].id

    #Edit Role API--> Can't be edited
    Given path 'v1/role/auto_role/field/sdfsdrt/id/'+roleId
    And header Authorization = 'Bearer ' + bToken
    When method put
    Then status 400
    And print 'Response is', response.message
