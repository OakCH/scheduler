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

Scenario: After finalizing, should that the list has been finalized.
  Then I should see "This nurse list has been finalized."

Scenario: Nurses in given unit and shift should receive email sent from admin
  When I am logged in as the Nurse "Jane Doe"
  Then "jane@doe.come" should receive an email
  And I open the email
  Then I should see "Instructions to set up your Vacation Scheduler account" in the email subject
  And I should see "You can confirm your account email through the link below:" in the email body
