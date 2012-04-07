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
  | Jane Doe   | 17-Apr-2012 | 24-Apr-2012 | 1        |
  | John Doe   | 20-Apr-2012 | 25-Apr-2012 | 2        |
  | John Doe   | 2-May-2012  | 9-May-2012  | 2        |


  And I am on the Nurse Calendar page for "Jane Doe" in the month "4"

Scenario: Viewing calendar for April
  Then I should see "Jane Doe"

Scenario: Changing month to March
  When I follow "March"
  Then I should not see "Jane Doe"

Scenario: Changing month to May
  When I follow "May"
  Then I should see "John Doe"

Scenario: Overlapping vacations
  Then I should see "Jane Doe"
  Then I should see "John Doe"