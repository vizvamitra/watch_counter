Feature: getting active watches count for particular customer

  As an API user
  I want to be able to get active watches count for particular customer

  Background:
    Given I have 3 video watches for customer 1

  Scenario: I'm getting watches count successfuly

    When I make a request to '/customers/1' via 'get'
    Then the response status should be 200
    And I should see JSON:
    """
      {
        "watches": 3
      }
    """

  Scenario: I'm trying to get watches count for unknown customer

  When I make a request to '/customers/unknown' via 'get'
    Then the response status should be 200
    And I should see JSON:
    """
      {
        "watches": 0
      }
    """