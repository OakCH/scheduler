Feature: View Calendar as Nurse

As a nurse, 
I want to view the seniority of the other nurses so I know who to whack to get first pickings.

Background:

  Given the following nurses exist in this seniority order:
  | name           | shift | unit       | years_worked | email            |
  | J.D. Another   | PMs   | Surgery    |           25 | nurse1@nurse.com |
  | Jane Doe       | PMs   | Surgery    |            3 | nurse2@nurse.com |
  | John Doe       | PMs   | Surgery    |            2 | nurse3@nurse.com |
  | J.D. Another 3 | PMs   | Surgery    |            1 | nurse4@nurse.com |
  | Wrong Shift    | Days  | Surgery    |            3 | nurse5@nurse.com |
  | Wrong Unit     | PMs   | Pediatrics |            4 | nurse6@nurse.com |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurses Seniority page for "Jane Doe"
 
Scenario: Viewing nurses listed by seniority
  Then I should see "J.D. Another" before "Jane Doe" 
  And I should see "Jane Doe" before "John Doe"
  And I should see "John Doe" before "J.D. Another 3"

Scenario: Should not see nurses from other units and shifts
  Then I should not see "Wrong Shift"
  And I should not see "Wrong Unit"

Scenario: Should not see sensitive information such as email addresses
  Then I should not see "nurse2@nurse.com"
  And I should not see "nurse4@nurse.com"
  And I should not see "Years Worked"
  And I should not see "25"
