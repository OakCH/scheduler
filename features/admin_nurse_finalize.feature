Feature: Finalize nurse list for unit and shift.

As an admin
I want to be able to finalize the list of nurses for a unit and shift
So that I can begin the scheduling process

As a nurse
I want to be able to receive an email when the scheduling process begins
So that I can begin planning out my vacations for the year

Background:

  Given the following nurses exist:
  | name     | shift | unit      | email        |
  | Jane Doe | PMs   | Surgery   | jane@doe.com |
  | John Doe | PMs   | Surgery   | joe@doe.com  |
  | Santa C  | Days  | Pediatric | santa@np.com |

  And the following admins exist:
  | name       | email          | unit    |
  | Jane Admin | jane@admin.com | Surgery |

  When I am logged in as the Admin "Jane Admin"
  And I am on the Manage Nurses page
  And I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I press "Finalize Nurses"
  And I am on the Finalize Nurses page
  And I fill in "Message" with "Your Vacation Scheduling Account Information"
  And I press "Finalize Nurse"

Scenario: After finalizing, should be on Manage Nurse with no more edit or delete nurse options
  Then I should be on the Manage Nurses page
  And I should not see "Jane Doe_delete"
  And I should not see "Jane Doe_edit"
  And I should not see "John Doe_delete"
  And I should not see "John Doe_edit"
  And I should see "This nurse list has been finalized."

Scenario: After finalizing, should still see edit or delete options on other unit page.
  When I am on the Manage Nurses page
  And I select "Days" from "Shift"
  And I select "Pediatric" from "Unit"
  And I press "Show"
  Then I should see "Santa C_delete"
  And I should see "Santa C_edit"
  And I should see "Finalize Nurses"

Scenario: Nurses in given unit and shift should  receive email sent from admin
  When I am logged in as the Nurse "Jane Doe"
  Then "jane@doe.come" should receive an email
  And I open the email
  Then I should see "Your Vacation Scheduling Account Information" in the email subject
  And I should see "Username" in the email body
