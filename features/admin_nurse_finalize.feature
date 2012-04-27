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
  When I am logged in as the Nurse "Jane Doe"
  Then "jane@doe.com" should receive an email
  And I open the email
  Then I should see "Instructions to set up your Vacation Scheduler account" in the email subject
  And I should see "Your nurse administrator has set up an account for you" in the email body
