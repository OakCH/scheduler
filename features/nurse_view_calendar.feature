Feature: View Calendar as Nurse

As a nurse, 
I want to be able to view the calendar (with the blacked out times), even when it's not my turn
So that I can start planning my vacation time

Background:

  "January" 6 is blacked out
  I am on the Nurse Calendar page

Scenario: Viewing calendar when it's not my turn
  When it is not my turn
  Then I should not be able to select a date

Scenario: Selecting blacked out time
  When it is my turn
  I should not be able to select "January" 6

Scenario: Selecting vacation times
  When it is my turn
  And I select "January" from "Months"
  And I select "10"
  And I select "17" 
  Then I "10" through "17" should be black
  And I should see "Jan 10-17"
  And I should see "Two more weeks of vacation left"

Scenario: Finish selecting times
  When it is my turn
  And I select "January" from "Months"
  And I select "10"
  And I press "Done"
  Then I should see "Vacation times selected"
  



  