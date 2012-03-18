Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar, even when it's not my turn
So that I can start planning my vacation time

Background:

  Given the following dates have been taken:
  | Jane Doe   | 17-Jan-2012 | 24-Jan-2012 | Days | Surgery    |
  | John Doe   | 24-Feb-2012 | 5-Mar-2012  | Days | Surgery    |
  | Jane Doe   | 4-Mar-2012  | 12-Mar-2012 | Days | Surgery    |
  | J.P. Morgan| 17-Jan-2012 | 24-Jan-2012 | PMs  | Surgery    |
  | K.D. Tang  | 17-Jan-2012 | 24-Jan-2012 | PMs | Cardiology |

  And I am on the "Nurse Calendar" page
  And I select "Days" from "Shift"
  And I select "Surgery" from "Unit"

Scenario: Viewing calendar for January
  When I select "January" from "Months"
  And I press "Submit"
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