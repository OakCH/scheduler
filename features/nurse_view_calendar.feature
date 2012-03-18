Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar (with the blacked out times), even when it's not my turn
So that I can start planning my vacation time

Background:

  Given the following dates have been taken:
  | Jane Doe   | 17-Jan-2012 | 24-Jan-2012 | days | Surgery    |
  | John Doe   | 24-Feb-2012 | 5-Mar-2012  | days | Surgery    |
  | Jane Doe   | 4-Mar-2012  | 12-Mar-2012 | days | Surgery    |
  | J.P. Morgan| 17-Jan-2012 | 24-Jan-2012 | pms  | Surgery    |
  | K.D. Tang  | 17-Jan-2012 | 24-Jan-2012 | days | Cardiology |

  I am on the Nurse Calendar page
  And I select "days" from "Shift"
  And I select "Surgery" from "unit"

Scenario: Viewing calendar
  When I select "January" from "Months"
  And I press "Submit"
  Then I should see "Jane Doe"
  When I select "February" from "Months"
  And I press "Submit"
  Then I should see "John Doe"
  When I select "March" from "Months"
  And I press "Submit"
  Then I should see "Jane Doe" 
  Then I should see "John Doe"

Scenario: Viewing other units
  When I select "January" from "Months"
  And I press "Submit"
  Then I should not see "J.P. Morgan"
  And I should not see "K.D. Tang"