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
  | John Doe   | 24-Feb-2012 | 5-Mar-2012  | 2        |


  And I am on the Nurse Calendar page for "Jane Doe"

Scenario: Viewing calendar for March 
  Then I should see "Jane Doe"

Scenario: Changing month with two nurses per month
  When I select "March" from "Months"
  And I press "Submit"
  Then I should see "Jane Doe" 
  And I should see "John Doe"

Scenario: Viewing other unit or shift
  When I select "January" from "Months"
  And I press "Submit"
  Then I should not see "J.P. Morgan"
  And I should not see "K.D. Tang"
