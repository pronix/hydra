Feature: Manage tasks
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new tasks
    Given I am on the new tasks page
    When I fill in "Name" with "name 1"
    And I fill in "Category" with "category 1"
    And I fill in "Description" with "description 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "category 1"
    And I should see "description 1"

  Scenario: Delete tasks
    Given the following tasks:
      |name|category|description|
      |name 1|category 1|description 1|
      |name 2|category 2|description 2|
      |name 3|category 3|description 3|
      |name 4|category 4|description 4|
    When I delete the 3rd tasks
    Then I should see the following tasks:
      |Name|Category|Description|
      |name 1|category 1|description 1|
      |name 2|category 2|description 2|
      |name 4|category 4|description 4|
