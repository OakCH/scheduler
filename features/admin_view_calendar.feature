Feature: View Calendar as Admin

As an admin, 
I want to be able to see the calendar with the nurses' vacation assignments
So that I can monitor the vacation scheduling

Background:

  Given the following admin unit relations exist
  | admin_id    | unit       |
  | Jane Doe    |            |

  And I am logged in as an Admin

Scenario: Viewing calendar by Day Time shift
  Then I should see "Jane Doe" 
  And I should see the vacation belonging to "Jane Doe" from "17-Feb-2012" to "24-Feb-2012"

Scenario: Changing month with two possible nurses per month
  When I follow "March"
  Then I should see "Jane Doe"
  Then I should see the vacation belonging to "Jane Doe" from "4-Mar-2012" to "12-Mar-2012"
  But I should not see "John Doe"
  And I should not see the vacation belonging to "John Doe" from "1-Mar-2012" to "8-Mar-2012"

Scenario: Changing to shift that has no vacations scheduled
  When I select "Surgery" from "Unit"
  And I select "Nights" from "Shift"
  And I press "Filter calendars"
  Then I should not see "Jane Doe" 
  And I should not see "John Doe"

Scenario: Viewing other units, shifts, and month
  When I select "Cardiology" from "Unit"
  And I select "PMs" from "Shift"
  And I press "Filter calendars"
  When I follow "January"
  Then I should not see "J.P. Morgan"
  And I should see "K.D. Tang"
  And I should see the vacation belonging to "K.D. Tang" from "17-Jan-2012" to "24-Jan-2012"
