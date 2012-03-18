Feature: View Calendar as Admin

As an admin, 
I want to be able to see the calendar with the nurses' vacation assignments
So that I can monitor the vacation scheduling

Background:

  Given the following dates have been taken:
  | Jane Doe   | 17-Jan-2012 | 24-Jan-2012 | Days | Surgery |
  | John Doe   | 24-Feb-2012 | 5-Mar-2012  | PMs  | Surgery |
  | Jane Doe   | 4-Mar-2012  | 12-Mar-2012 | Days | Surgery |
  | J.P. Morgan| 17-Jan-2012 | 24-Jan-2012 | PMs  | Surgery    |
  | K.D. Tang  | 17-Jan-2012 | 24-Jan-2012 | PMs | Cardiology |

  And I am on the "Admin Calendar" page

Scenario: Viewing calendar by Day Time shift
  When I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I select "January" from "Months"
  And I press "Submit"
  Then I should see "Jane Doe"

Scenario: Changing month with two nurses per month
  When I select "March" from "Months"
  And I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I press "Submit"
  Then I should see "Jane Doe" 
  And I should see "John Doe"

Scenario: Changing shift and month with two nurse per month
  When I select "April" from "Months"
  And I select "Surgery" from "Unit"
  And I select "PMs" from "Shift"
  And I press "Submit"
  Then I should not see "Jane Doe" 
  And I should not see "John Doe"

Scenario: Viewing other units
  When I select "Cardiology" from "Unit"
  And I select "PMs" from "Shift"
  And I select "January" from "Months"
  And I press "Submit"
  Then I should not see "J.P. Morgan"
  And I should see "K.D. Tang"