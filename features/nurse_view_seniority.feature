Feature: View Calendar as Nurse

As a nurse, 
I want to view the seniority of the other nurses so I know who to whack to get first pickings.

Background:

  Given the following nurses exist:
  | name               | shift | unit       | years_worked |
  | Jane Doe           | PMs   | Surgery    | 3            |
  | John Doe           | PMs   | Surgery    | 2            |
  | J.D. Another       | PMs   | Surgery    | 5            |
  | J.D. Another 3     | PMs   | Surgery    | 1            |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurses Seniority page for "Jane Doe"
 
Scenario: Viewing nurses listed by seniority in descending order
  Then I should see "J.D. Another" before "Jane Doe" 
  And I should see "Jane Doe" before "John Doe"
  And I should see "John Doe" before "J.D. Another 3"
