Feature: Manage dashboards
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new dashboard
    Given I am on the new dashboard page
    When I fill in "Name" with "name 1"
    And I fill in "State" with "state 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "state 1"

  Scenario: Delete dashboard
    Given the following dashboards:
      |name|state|
      |name 1|state 1|
      |name 2|state 2|
      |name 3|state 3|
      |name 4|state 4|
    When I delete the 3rd dashboard
    Then I should see the following dashboards:
      |Name|State|
      |name 1|state 1|
      |name 2|state 2|
      |name 4|state 4|
