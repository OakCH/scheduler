Feature: View units, create and edit units, destroy units

As an admin,
I want to be able to create, edit and delete units
So that I can have an up-to-date list of them.

Background:

  Given the following units exist:
  | name |
  | Surgery |
  | Pediactrics |

  And I am logged in as an Admin
  And I am on the Units page

Scenario: Viewing list of units
  Then I should see "Surgery"
  And I should see "Pediatrics"

Scenario: Adding a unit
  When I follow "add units"
  And I fill in "Unit Name" with "Cardiology"
  And I press "Submit"
  Then I should see "Cardiology"
  And I should see "Surgery"

Scenario: Adding an existing unit
  When I follow "add units"
  And I fill in "Unit Name" with "Surgery"
  And I press "Submit"
  Then I should see "Unit name taken"

Scenario: Updating a unit
  When I follow "Surgery"
  And I fill in "Unit Name" with "Cardiology"
  And I press "Submit"
  Then I should see "Cardiology"
  And I should not see "Surgery"

Scenario: Changing a name to an existing unit
  When I follow "Surgery"
  And I fill in "Unit Name" with "Pediatrics"
  And I press "Submit"
  Then I should see "Unit name taken"

Scenario: Deleting a unit
  When I follow "Surgery"
  And I press "Delete Unit"
  Then I should see "Pediactrics"
  And I should not see "Surgery"