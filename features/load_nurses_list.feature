Feature: Bulk Upload User Data

As an admin
I want to bulk upload user data
So that I don't have to enter in everyone's names one at a time

Background:

  Given "Surgery" is a type of Unit
  And I am on the Edit Nurses page

Scenario: Upload xls schedule for PM shift
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Next"
  And I choose "sample.xls" to upload
  And I press "Upload"
  Then I should see "Jane Doe"

Scenario: Upload xlsx file
  When I select "Days" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Next"
  And I choose "basic_spreadsheet.xlsx" to upload
  And I press "Upload"
  Then I should see "Nurse1"
  And I should see "Nurse2"
  And I should see "nurse 3"

Scenario: Upload an invalid file
  When I select "Days" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Next"
  And I choose "not_a_spreadsheet.txt" to upload
  And I press "Upload"
  Then I should see "File to parse was not a valid xls or xlsx"

Scenario: Upload malformed xls file
  When I select "Days" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Next"
  And I choose "missing_name_header.xls" to upload
  And I press "Upload"
  Then I should see "Header row is missing the name column"