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
  
  And the following admins exist:
  | name       | email          | unit    |
  | Jane Admin | jane@admin.com | Surgery |
  | Joe Admin  | joe@admin.com  | Surgery |
  | Bob Admin  | bob@admin.com  | ER      |

Scenario: Next nurse receiving email after previous nurse has submitted vacation schedule
  And I am logged in as the Nurse "Jane Doe"
  And I press "Finalize"
  Then "jane@doe.com" should receive an email
  And I open the email
  Then I should see "It is now your turn to schedule your vacation" in the email subject
  And I should see the email delivered from "admin@chovacationsched.com"
  And I should see "Please log in to schedule your vacation:" in the email body
  And I click the first link in the email
  And I should see "Jane Doe"

Scenario: Admin receives email when a nurse is done scheduling
  And I am logged in as the Nurse "Jane Doe"
  And I press "Finalize"
  And I log out
  And I am logged in as the Admin "Jane Admin"
  Then "jane@admin.com" should receive an email
  And "joe@admin.com" should receive an email
  And "bob@admin.com" should receive no email
  And I open the email
  Then I should see "Jane Doe has finished scheduling his or her vacation" in the email subject
  And I should see the email delivered from "admin@chovacationsched.com"
  And I should see "The calendar has moved on to the next nurse." in the email body
  And I click the first link in the email
  And I should see "Admin"
  And I should see "Calendar"
