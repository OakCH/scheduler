Feature: View Calendar as Admin

As an admin, 
I want to be able to see the calendar with the nurses' vacation assignments
So that I can monitor the vacation scheduling

Background:

  Given the following nurses exist
  | name        | shift | unit       |
  | Jane Doe    | Days  | Surgery    |
  | John Doe    | PMs   | Surgery    |
  | J.P. Morgan | PMs   | Surgery    |
  | K.D. Tang   | PMs   | Cardiology |

  And the following vacations exist
  | name        | start_at    | end_at      |
  | Jane Doe    | 17-Jan-2012 | 24-Jan-2012 |
  | John Doe    | 24-Feb-2012 | 5-Mar-2012  |
  | Jane Doe    | 4-Mar-2012  | 12-Mar-2012 |
  | J.P. Morgan | 17-Jan-2012 | 24-Jan-2012 |
  | K.D. Tang   | 17-Jan-2012 | 24-Jan-2012 |

Scenario: Viewing calendar by Day Time shift
  When I am on the Admin Calendar page in "January" of "2012"
  And I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I press "Filter calendars"
  Then I should see the vacation belonging to "Jane Doe" from "17-Jan-2012" to "24-Jan-2012"

Scenario: Changing month with two nurses per month
  When I am on the Admin Calendar page in "March" of "2012"
  And I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I press "Filter calendars"
  Then I should see "Jane Doe"
  And I should not see "John Doe"
  

Scenario: Changing shift and month with two nurse per month
  When I am on the Admin Calendar page in "April" of "2012"
  When I select "Surgery" from "Unit"
  And I select "PMs" from "Shift"
  And I press "Filter calendars"
  Then I should not see "Jane Doe" 
  And I should not see "John Doe"

Scenario: Viewing other units
  When I am on the Admin Calendar page in "January" of "2012"
  When I select "Cardiology" from "Unit"
  And I select "PMs" from "Shift"
  And I press "Filter calendars"
  Then I should not see "J.P. Morgan"
  And I should see "K.D. Tang"
