Feature: Finalize nurse list for unit and shift.

As an admin,
I want to be able to finalize the list of nurses for a unit and shift
So that I can begin the scheduling process.

As a nurse,
I want to be able to receive an email when the scheduling process begins
So that I can begin planning out my vacations for the year.

Background:

  Given the following nurses exist:
  | name     | shift | unit      | email        |
  | Jane Doe | PMs   | Surgery   | jane@doe.com |
  | John Doe | PMs   | Surgery   | joe@doe.com  |
  | Santa C  | Days  | Pediatric | santa@np.com |

  And the following admins exist:
  | name       | email          |
  | Jane Admin | jane@admin.com |

  When I am logged in as the Admin "Jane Admin"
  And I am on the Manage Nurses page
  And I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I press "Finalize Nurses"

Scenario: After finalizing, show that the list has been finalized.
  Then I should see "This nurse list has been finalized and account creation emails have been sent for nurses in Unit Surgery, PMs."

Scenario: Nurses in given unit and shift should receive email sent from admin
  Then "jane@doe.com" should receive an email
  And I open the email
  Then I should see "Instructions to set up your Vacation Scheduler account" in the email subject
  And I should see "Your nurse administrator has set up an account for you" in the email body

Scenario: Nurse can finish creating account based on email
  And I log out
  And "jane@doe.com" should receive an email
  And I open the email
  And I follow "Accept invitation" in the email
  And I fill in "Email" with "changed_mail@doe.com"
  And I fill in "Password" with "new_password"
  And I fill in "Password confirmation" with "new_password"
  And I press "Save and Login"
  And I log out
  Then I should be able to log in as the Nurse "changed_mail@doe.com" with password "new_password"
