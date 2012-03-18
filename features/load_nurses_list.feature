Feature: Bulk Upload User Data

As an admin
I want to bulk upload user data
So that I don't have to enter in everyone's names one at a time

Background:

  I am on the Edit Nurses page

Scenario: Upload schedule for PM shift
  When I select "PM" from "Shift"
  And when I select "Surgery" from "Unit"
  And when I fill in upload with "nurseslist.xls"
  And I press "Upload File"
  Then I should see "Jane Doe"

Scenario: Forget to enter in a shift
  When I select "Surgery" from "Unit"
  And when I fill in upload with "nurseslists.xls"
  And I press "Upload File"
  Then I should see "Error: Forgot to specify shift"

Scenario: Forget to enter in a unit
  When I select "Day Time" from "Shift"
  And when I fill in upload with "nurseslists.xls"
  And I press "Upload File"
  Then I should see "Error: Forgot to specify unit"
  
Scenario: Upload an invalid schedule
  When I select "Day Time" from "Shift"
  And when I select "Surgery" from "Unit"
  And when I fill in upload with ""
  And I press "Upload File"
  Then I should see "Error: Invalid file"



