Feature: View, create, edit, and destroy nurses.

As an admin,
I want to be able to create, edit, and delete nurses.
So that I can have an up-to-date list of them.

Background:
  Given the following nurses exist:
  | name               | shift | unit       | email               | nurse_order_position |
  | Jane Doe           | PMs   | Surgery    | janedoe@email.com   |                    1 |
  | John Doe           | PMs   | Surgery    | johndoe@email.com   |                    2 |
  | J.D. Another Unit  | PMs   | Cardiology | otherjane@email.com |                    1 |
  | J.D. Another Shift | Days  | Surgery    | otherjohn@email.com |                    1 |

  And I am logged in as an Admin
  And I am on the Manage Nurses page

Scenario: Viewing list of nurses
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  Then I should see "Jane Doe"
  And I should see "John Doe"
  But I should not see "J.D. Another Unit"
  And I should not see "J.D. Another Shift."

Scenario: Adding a new nurse
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  When I follow "Add A Single Nurse"
  And I fill in "Name" with "Jose Deer"
  And I select "Surgery" from "Unit"
  And I select "PMs" from "Shift"
  And I fill in "Years Worked" with "5"
  And I fill in "Number of Weeks Off" with "3"
  And I fill in "Email" with "jdeer@email.com"
  And I press "Add New Nurse"
  Then I should see "Jose Deer"

Scenario: Adding a new nurse with existing email
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  When I follow "Add A Single Nurse"
  And I fill in "Name" with "Jose Deer"
  And I select "Surgery" from "Unit"
  And I select "PMs" from "Shift"
  And I fill in "Years Worked" with "5"
  And I fill in "Number of Weeks Off" with "3"
  And I fill in "Email" with "janedoe@email.com"
  And I press "Add New Nurse"
  Then I should see "User email has already been taken"

Scenario: Updating a nurse name and position
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I fill in "Name" with "Jane New Doe"
  And I fill in "Rank" with "2"
  And I press "Update Info"
  Then I should see "Jane New Doe"
  And I should not see "Jane Doe"
  And I should see "John Doe" before "Jane New Doe"

Scenario: Updating a nurse email to an existing email
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I fill in "Email" with "johndoe@email.com"
  And I press "Update Info"
  Then I should see "User email has already been taken"

Scenario: Deleting a nurse
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I press "Delete"
  Then I should see "johndoe@email.com"
  But I should not see "janedoe@email.com"

Scenario: Clicking on a nurse calendar
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe_calendar"
  Then I should be on the Nurse Calendar page for "Jane Doe"

Scenario: Deleting a nurse from the index page
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I press "Jane Doe_delete"
  Then I should see "johndoe@email.com"
  But I should not see "janedoe@email.com"
