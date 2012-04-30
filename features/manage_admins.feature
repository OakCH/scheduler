Feature: View, edit, and create administrators.

As an admin,
I want to be able to view, invite, and delete admins,
So that I can make sure access privileges are granted to the appropriate people.

Background:
  Given the following admins exist:
  | name   | email            |
  | admin1 | first@admin.com  |
  | admin2 | second@admin.com |

  And I am logged in as the Admin "admin1"
  And I am on the Manage Admins page

Scenario: Viewing list of admins
  Then I should see "admin1"
  And I should see "admin2"

Scenario: Editing admin name
  And I follow "admin1"
  And I fill in "Name" with "admin200"
  When I press "Update Info"
  Then I should be on the Manage Admins page
  And I should see "admin200"
  And I should not see "admin1"

Scenario: Editing admin email with invalid email
  And I follow "admin1"
  And I fill in "Email" with "admin1"
  When I press "Update Info"
  Then I should be on the Edit Admin page for "admin1"
  And I should see "User email is invalid"

Scenario: Deleting an admin
  When I press delete for "admin2"
  Then I should be on the Manage Admins page
  And I should see "admin2 has been deleted."
  And I should not see "second@admin.com"

Scenario: Inviting a new admin
  And I follow "Add a New Administrator"
  And I fill in "Name" with "new_admin"
  And I fill in "Email" with "new_admin_email@mail.com"
  When I press "Create an admin account"
  Then "new_admin_email@mail.com" should receive an email
  And they open the email
  Then they should see "Instructions to set up your Vacation Scheduler account" in the email subject
  And I should see "A current nurse administrator has set up an administrator account for you" in the email body

Scenario: New admin can use email link to complete account creation
  And I log out
  And the admin "new_admin" with email "new_admin_email@mail.com" has been invited
  And "new_admin_email@mail.com" should receive an email
  And I open the email
  And I follow "Accept invitation" in the email
  And I fill in "Password" with "new_password"
  And I fill in "Password confirmation" with "new_password"
  And I press "Save and Login"
  And I log out
  Then I should be able to log in as the Admin "new_admin_email@mail.com" with password "new_password"
