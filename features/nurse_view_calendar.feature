Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar (with the blacked out times), even when it's not my turn
So that I can start planning my vacation time

Background:

  Given the following dates have been taken:
  | Jane Doe   | 17-Jan-2012 | 24-Jan-2012 |
  | John Doe   | 24-Feb-2012 | 5-Mar-2012  |
  | Jane Doe   | 4-Mar-2012  | 12-Mar-2012 |

  I am on the Nurse Calendar page

Scenario: Viewing calendar when it's not my turn
  When it is not my turn
  Then I should not be able to select a date

Scenario: Selecting blacked out time
  When it is my turn
  I should not be able to select "January" 17

Scenario: Selecting vacation times
  When it is my turn
  And I select "May" from "Months"
  And I press "Submit"
  And I select "10"
  And I select "17" 
  Then "10" through "17" should be black
  And I should see "May 10-17"
  And I should see "Two more weeks of vacation left"

Scenario: Finish selecting times
  When it is my turn
  And I press "Done"
  Then I should see "Vacation times selected"
  



  