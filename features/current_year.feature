Feature: Notion of time

As an admin,
I want to be able to set time limits
So that nurses don't schedule vacations too advanced into the future

Background:
  Given the following current years exist
  | year |
  | 2007 |

  And I am logged in as an Admin
  And I am on the Current Year page

Scenario: Viewing current time
  Then I should see "2007"

Scenario: Changing current time
  And I fill in "year_field" with "2008"
  And I press "Submit"
  Then I should see "2008"

