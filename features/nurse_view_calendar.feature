Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar, even when it's not my turn
So that I can start planning my vacation time

Background:

  Given the following nurses exist:
  | name       | shift | unit_id | seniority  | num_weeks_off | email           | years_worked |
  | Jane Doe   | PMs   | 1       | 23         | 3            | jad@example.com | 12           |
  | John Doe   | PMs   | 1       | 24         | 4            | jod@example.com | 5            |
  
  And the following events exist:
  | name       | start_at    | end_at      | nurse_id |
  | Jane Doe   | 17-Mar-2012 | 24-Mar-2012 | 1        |
  | John Doe   | 2-Apr-2012  | 9-Apr-2012  | 2        |


  And I am on the Nurse Calendar page for "Jane Doe" in the month "3"

Scenario: Viewing calendar for March 
  Then I should see "Jane Doe"

Scenario: Changing month to February 
  When I follow "month_4"
  Then I should see a stripe "a href="
  Then I should see a stripe "#"
  Then show me the page
