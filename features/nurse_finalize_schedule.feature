Feature: Finalize vacation segments for given nurse and notify next nurse it's their turn

As a nurse,
I want to be able to receive an email when it is my turn to schedule my vacations
So that I know when to choose and finalize my vacation segments for the year.

As an admin,
I want to receive an email when each nurse I am responsible for begins scheduling her vacations
So that I can keep track of the scheduling process.

Background:

  Given the following current years exist
  | year |
  | 2012 |

  Given the following nurses exist in this seniority order:
  | name     | shift | unit      | email        |
  | Jane Doe | PMs   | Surgery   | jane@doe.com |
  | John Doe | PMs   | Surgery   | joe@doe.com  |
  | Santa C  | Days  | Pediatric | santa@np.com |

  And the following admins with units exist:
  | name       | email          | units     |
  | Jane Admin | jane@admin.com | Surgery   |
  | John Admin | joe@admin.com  | Pediatric |

  And the following vacations exist:
  | name               | start_at    | end_at      |
  | Jane Doe           | 11-Apr-2012 | 19-Apr-2012 |
  | John Doe           | 20-Apr-2012 | 27-Apr-2012 |
  | John Doe           | 2-May-2012  | 9-May-2012  |
  | Santa C            | 1-Apr-2012  | 8-Apr-2012  |

  And the following nurse batons exist:
  | unit    | shift | nurse    |
  | Surgery | PMs   | Jane Doe |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurse Calendar page for "Jane Doe" in "April" of "2012"
  When I press "finalize_schedule"

Scenario: After finalizing schedule, nurse can no longer edit vacation segments.
  Then I should not see "Add a vacation segment"
  And I should not see "Finalize Your Vacation"

Scenario: After finalizing schedule, next nurse should be able to see edit options.
  When I log out
  And I am logged in as the Nurse "John Doe"
  And I am on the Nurse Calendar page for "John Doe" in "April" of "2012"
  Then I should see "Add a vacation segment"
  And I should see "Finalize Your Vacation Segments"

Scenario: After finalizing schedule, next nurse should be able to add a vacation segment
  When I log out
  And I am logged in as the Nurse "John Doe"
  And I am on the Nurse Calendar page for "John Doe" in "April" of "2012"
  And I follow "Add a vacation segment"
  Then I should see "Choose"

Scenario: After finalizing schedule, next nurse should be able to edit a vacation segment
  When I log out
  And I am logged in as the Nurse "John Doe"
  And I follow "Edit vacation segment"
  Then I should see "Change"

Scenario: After finalizing schedule, nurse should not be able to add a vacation segment
  When I am on the Add Vacation page for "Jane Doe"
  Then I should see "You cannot access that page"

Scenario: After finalizing schedule, nurse should not be able to edit a vacation segment
  When I am on the Update Vacation page for "Jane Doe" from "11-Apr-2012" to "19-Apr-2012"
  Then I should see "You cannot access that page"

Scenario: After finalizing schedule, next nurse should receive an email sent from admin
  Then "joe@doe.com" should receive an email
  And I open the email
  Then I should see "It is now your turn to schedule your vacation" in the email subject
  And I should see "Please log in to schedule your vacation:" in the email body

Scenario: After finalizing schedule, admin should receive an email indicating the previous nurse has finished
  Then "jane@admin.com" should receive an email
  And I open the email
  Then I should see "Jane Doe has finished scheduling his or her vacation" in the email subject
  Then I should see "The calendar has moved on to the next nurse" in the email body
  But "joe@admin.com" should have no emails

Scenario: After every nurse in a Unit and Shift has been finalized, admin should receive an email
  When I log out
  And I am logged in as the Nurse "John Doe"
  And I am on the Nurse Calendar page for "John Doe" in "April" of "2012"
  And I press "finalize_schedule"
  Then "jane@admin.com" should receive an email with subject "[Surgery, PMs] All vacations have been scheduled"
  And I open the email with subject "[Surgery, PMs] All vacations have been scheduled"
  Then I should see "All vacations have been scheduled for the Surgery unit, PMs shift." in the email body
  But "joe@admin.com" should have no emails

Scenario: Admin should be able to add vacations if baton exists
  When I log out
  And I am logged in as the Admin "Jane Admin"
  And I am on the Nurse Calendar page for "John Doe" in "April" of "2012"
  And I follow "Add a vacation segment"
  When I fill in "event_start_at" with "06/18/2012"
  And I fill in "event_end_at" with "06/25/2012"
  And I press "Save Changes"
  Then I should see the vacation belonging to "John Doe" from "18-June-2012" to "25-June-2012"

Scenario: Admin should be able to add vacations if baton doesn't exist
  When I log out
  And I am logged in as the Admin "Jane Admin"
  And I am on the Nurse Calendar page for "Santa C" in "April" of "2012"
  And I follow "Add a vacation segment"
  When I fill in "event_start_at" with "06/18/2012"
  And I fill in "event_end_at" with "06/25/2012"
  And I press "Save Changes"
  Then I should see the vacation belonging to "Santa C" from "18-June-2012" to "25-June-2012"

Scenario: Admin should be able to delete vacations regardless of batons.
  When I log out
  And I am logged in as the Admin "Jane Admin"
  And I am on the Nurse Calendar page for "Santa C" in "April" of "2012"
  And I press "Delete"
  Then I should not see "Vacation Segments for Santa C"

Scenario: Admin should be able to edit vacations if baton exists
  When I log out
  And I am logged in as the Admin "Jane Admin"
  And I am on the Nurse Calendar page for "John Doe" in "April" of "2012"
  And I follow "Edit vacation segment"
  And I fill in "event_start_at" with "06/18/2012"
  And I fill in "event_end_at" with "06/25/2012"
  And I press "Update vacation time"
  Then I should see the vacation belonging to "John Doe" from "18-June-2012" to "25-June-2012"
