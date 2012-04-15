Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar, even when it's not my turn
So that I can start planning my vacation time

Background:

  Given the following nurses exist:
  | name               | shift | unit       |
  | Jane Doe           | PMs   | Surgery    |
  | John Doe           | PMs   | Surgery    |
  | J.D. Another Unit  | PMs   | Cardiology |
  | J.D. Another Shift | Days  | Surgery    |
  
  And the following vacations exist:
  | name               | start_at    | end_at      |
  | Jane Doe           | 17-Apr-2012 | 24-Apr-2012 |
  | John Doe           | 20-Apr-2012 | 25-Apr-2012 |
  | John Doe           | 2-May-2012  | 9-May-2012  |
  | J.D. Another Unit  | 1-Apr-2012  | 9-Apr-2012  |
  | J.D. Another Shift | 1-Apr-2012  | 9-Apr-2012  |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurse Calendar page for "Jane Doe" in "April" of "2012"

Scenario: Viewing calendar for April
  Then I should see "Jane Doe"
  But I should not see "J.D. Another Unit" 
  And I should not see the vacation belonging to "J.D. Another Unit" from "1-Apr-2012" to "9-Apr-2012"
  And I should not see "J.D. Another Shift" 
  And I should not see the vacation belonging to "J.D. Another Shift" from "1-Apr-2012" to "9-Apr-2012"

Scenario: Changing month to March
  When I follow "March"
  Then I should not see "Jane Doe"

Scenario: Changing month to May
  When I follow "May"
  Then I should not see "John Doe"
  But I should see the vacation belonging to "John Doe" from "2-May-2012" to "9-May-2012"

Scenario: Overlapping vacations
  Then I should see "Jane Doe"
  Then I should see the vacation belonging to "Jane Doe" from "17-Apr-2012" to "24-Apr-2012"
  Then I should not see "John Doe"
  But I should see the vacation belonging to "John Doe" from "20-Apr-2012" to "25-Apr-2012"
