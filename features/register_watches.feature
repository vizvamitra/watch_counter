Feature: watch registration

  As an API user
  I want to be able to inform the service about video watches
  In order to store information about them

  Scenario: I successfuly inform the service about video watch

    When I take the following data:
      | customer_id | 2 |
      | video_id    | 5 |
    And send them to '/watches' via 'POST'
    Then the response status should be 204

  Scenario Outline: I send not all necessary params

    When I take the following data:
      | <PARAM_NAME> | 5 |
    And send them to '/watches' via 'POST'
    Then the response status should be 422

    Examples:
      |  PARAM_NAME |
      | customer_id |
      |    video_id |
      | wrong_param |