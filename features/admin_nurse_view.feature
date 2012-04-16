Feature: View, create, edit, and destroy nurses.

As an admin,
I want to be able to create, edit, and delete nurses.
So that I can have an up-to-date list of them.

Background:
  Given the following nurses exist:
  | name               | shift | unit       | email               |
  | Jane Doe           | PMs   | Surgery    | janedoe@email.com   |
  | John Doe           | PMs   | Surgery    | johndoe@email.com   |
  | J.D. Another Unit  | PMs   | Cardiology | otherjane@email.com |
  | J.D. Another Shift | Days  | Surgery    | otherjohn@email.com |

  And I am logged in as an Admin
  And I am on the Nurse Manager page

Scenario: Viewing list of nurses
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  Then I should see "Jane Doe"
  And I should see "John Doe"
  But I should not see "J.D. Another Unit"
  And I should not see "J.D. Another Shift."

Scenario: Adding a new nurse
  When I follow "add nurse"
  And I fill in "Name" with "Jose Deer"
  And I fill in "Unit" with "Surgery"
  And I fill in "Shift" with "PMs"
  And I fill in "Years Worked" with "5"
  And I fill in "Number of Weeks Off" with "3"
  And I fill in "Email" with "jdeer@email.com"
  And I press "Submit"
  Then I should see "Jose Deer"

Scenario: Adding a new nurse with existing email
  When I follow "add nurse"
  And I fill in "Name" with "Jose Deer"
  And I fill in "Unit" with "Surgery"
  And I fill in "Shift" with "PMs"
  And I fill in "Years Worked" with "5"
  And I fill in "Number of Weeks Off" with "3"
  And I fill in "Email" with "janedoe@email.com"
  And I press "Submit"
  Then I should see "Email already exists."

Scenario: Updating a nurse name
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I fill in "Name" with "Jane New Doe"
  And I press "Submit"
  Then I should see "Jane New Doe"
  And I should not see "Jane Doe"

Scenario: Updating a nurse email to an existing email
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I fill in "Email" with "johndoe@email.com"
  And I press "Submit"
  Then I should see "Email already exists."

Scenario: Deleting a nurse
  When I select "PMs" from "Shift"
  And I select "Surgery" from Unit"
  And I press "Show"
  And I follow "Jane Doe"
  And I press "Delete"
  Then I should see "John Doe"
  But I should not see "Jane Doe"
