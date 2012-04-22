Feature: View units, create and edit units, destroy units

As an admin,
I want to be able to create, edit and delete units
So that I can have an up-to-date list of them.

Background:

  Given the following units exist:
  | name       |
  | Surgery    |
  | Pediatrics |

  And I am logged in as an Admin
  And I am on the Units page

Scenario: Viewing list of units
  Then I should see "Surgery"
  And I should see "Pediatrics"

Scenario: Adding a unit
  When I follow "Add unit"
  And I fill in "Unit Name" with "Cardiology"
  And I press "Submit"
  Then I should see "Cardiology"
  And I should see "Surgery"

Scenario: Adding an existing unit
  When I follow "Add unit"
  And I fill in "Unit Name" with "Surgery"
  And I press "Submit"
  Then I should see "Name has already been taken"

Scenario: Updating a unit
  When I follow "Surgery"
  And I fill in "Unit Name" with "Cardiology"
  And I press "Update Info"
  Then I should see "Cardiology"
  And I should not see "Surgery"

Scenario: Changing a name to an existing unit
  When I follow "Surgery"
  And I fill in "Unit Name" with "Pediatrics"
  And I press "Update Info"
  Then I should see "The update failed"

Scenario: Deleting a unit
  When I press "Surgery_delete"
  Then I should see "Pediatrics"
  And I should not see "Surgery"
