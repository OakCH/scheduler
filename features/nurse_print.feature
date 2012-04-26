Feature: Print Calendar As Nurse

As a nurse, 
I want to be able to print my vacation schedule.
So I can use it when I'm using a computer.

Background:

  Given the following nurses exist:
  | name               | shift | unit       |
  | Jane Doe           | PMs   | Surgery    |
  | John Doe           | PMs   | Surgery    |
  | J.D. Another Unit  | PMs   | Cardiology |
  | J.D. Another Shift | Days  | Surgery    |
  
  And the following vacations exist:
  | name               | start_at    | end_at      |
  | Jane Doe           | 11-Apr-2012 | 19-Apr-2012 |
  | John Doe           | 20-Apr-2012 | 27-Apr-2012 |
  | John Doe           | 2-May-2012  | 9-May-2012  |
  | J.D. Another Unit  | 1-Apr-2012  | 8-Apr-2012  |
  | J.D. Another Shift | 1-Apr-2012  | 8-Apr-2012  |

  And I am logged in as the Nurse "John Doe"
  And I am on the Nurse Print page for "John Doe"

Scenario: Nurse should see all months when she's going to be on vacation
  Then I should see vacations belonging to "John Doe"
  And I should not see vacations belonging to "Jane Doe"
  And I should see "April"
  And I should see "May"
  And I should not see "January"
  And I should not see "February"
  And I should not see "July"
  And I should not see "August"
  And I should not see "September"
  And I should not see "October"
  And I should not see "November"
  And I should not see "December"
