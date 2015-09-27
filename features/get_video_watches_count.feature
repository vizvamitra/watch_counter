Feature: getting active watches count for particular video

  As an API user
  I want to be able to get active watches count for particular video

  Background:
    Given video 1 is currently being watched by 3 customers

  Scenario: I'm getting watches count successfuly

    When I make a request to '/videos/1' via 'get'
    Then the response status should be 200
    And I should see JSON:
    """
      {
        "watches": 3
      }
    """

  Scenario: I'm trying to get watches count for unknown video

  When I make a request to '/videos/unknown' via 'get'
    Then the response status should be 200
    And I should see JSON:
    """
      {
        "watches": 0
      }
    """