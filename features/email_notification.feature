Feature: Email notification as nurse or admin

As a nurse
I want to get an email when it is my turn to schedule vacation
So that I can schedule my vacation 

As an admin
I want to get an email when a nurse has finished scheduling
So that I know the status of the scheduling

Background:

  Given the following nurses exist:
  | name     | shift | unit    | email        |
  | Jane Doe | PMs   | Surgery | jane@doe.com |
  | John Doe | PMs   | Surgery | john@doe.com |
  
  And the following admins with units exist:
  | name       | email          | units    |
  | Jane Admin | jane@admin.com | Surgery |
  | Joe Admin  | joe@admin.com  | Surgery |
  | Bob Admin  | bob@admin.com  | ER      |
  
  And the following nurse batons exist:
  | nurse    | shift | unit    |
  | Jane Doe | PMs   | Surgery |

Scenario: After an admin finalizes the nurse list, the first nurse should receive an email
  And I finalize the nurse list for the "Surgery" unit, "PMs" shift  
  Then "jane@doe.com" should receive 2 emails
  And I open the email with subject "It is now your turn to schedule your vacation"
  And I should see the email delivered from "admin@chovacationsched.com"
  And I should see "Please log in to schedule your vacation:" in the email body

Scenario: If there are no nurses, vacations should be immediately complete
  And I finalize the nurse list for the "Surgery" unit, "Days" shift
  Then "jane@admin.com" should receive an email
  And I open the email
  Then I should see "[Surgery, Days] All vacations have been scheduled" in the email subject
  Then "joe@admin.com" should receive an email
  And I open the email
  Then I should see "[Surgery, Days] All vacations have been scheduled" in the email subject
  And "bob@admin.com" should have no emails
    
Scenario: Next nurse receiving email after previous nurse has submitted vacation schedule
  And I finalize the nurse list for the "Surgery" unit, "PMs" shift  
  And "Jane Doe" sets up her nurse account
  And I am logged in as the Nurse "Jane Doe"
  And I press "Finalize Your Vacation"
  Then "john@doe.com" should receive 2 emails
  And I open the email with subject "It is now your turn to schedule your vacation"
  And I should see the email delivered from "admin@chovacationsched.com"
  And I should see "Please log in to schedule your vacation:" in the email body

Scenario: Admin receives email when a nurse is done scheduling
  And I finalize the nurse list for the "Surgery" unit, "PMs" shift  
  And "Jane Doe" sets up her nurse account
  And I am logged in as the Nurse "Jane Doe"
  And I press "Finalize Your Vacation"
  And I log out
  Then "bob@admin.com" should receive no email
  And "jane@admin.com" should receive an email
  And "joe@admin.com" should receive an email
  And I open the email
  Then I should see "Jane Doe has finished scheduling his or her vacation" in the email subject
  And I should see the email delivered from "admin@chovacationsched.com"
  And I should see "The calendar has moved on to the next nurse." in the email body

Scenario: Admin receives email when all nurses are done scheduling
  And I finalize the nurse list for the "Surgery" unit, "PMs" shift
  And "Jane Doe, John Doe" finalize their vacations
  Then "bob@admin.com" should have no emails
  And "jane@admin.com" should receive an email with subject "[Surgery, PMs] All vacations have been scheduled"
  And "joe@admin.com" should receive an email with subject "[Surgery, PMs] All vacations have been scheduled"
