Feature: Notion of time

As an admin,
I want to be able to set time limits
So that nurses don't schedule vacations too advanced into the future

Background:
  Given the following year exists
  | year |
  | 2007 |

  And I am logged in as an Admin

Scenario: Viewing current time
  When I am on the Set Time page
  Then I should see "2007"

Scenario: Changing current time
  When I am on the Set Time page
  And when I select "2008" from "Year"
  And I press "Submit"
  I should see "2008"

