Feature: Bulk Upload User Data

As an admin
I want to bulk upload user data
So that I don't have to enter in everyone's names one at a time

Background:
  
  Given the following nurses exist:
  | name     | shift | unit    |
  | Jane Doe | Days  | Surgery |
  | John Doe | Days  | Surgery |

  And I am logged in as an Admin
  And I am on the Edit Nurses page
  When I select "Days" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"

Scenario: Upload xls schedule for PM shift
  When I select "PMs" from "Shift"
  And I select "Surgery" from "Unit"
  And I press "Show"
  And I choose "basic_spreadsheet.xls" to upload
  And I press "Upload"
  Then I should see the following nurses: "Nurse1, Nurse2, nurse 3"

Scenario: Upload xlsx file for Days shift
  And I choose "basic_spreadsheet.xlsx" to upload
  And I press "Upload"
  Then I should see the following nurses: "Nurse1, Nurse2, nurse 3"

Scenario Outline: Upload an invalid file
  And I choose "<file>" to upload
  And I press "Upload"
  Then I should see "<error>"
  And I should see the following nurses: "Jane Doe, John Doe"

  Examples:
  | file                    | error                                          |
  | not_a_spreadsheet.txt   | File to parse was not a valid xls or xlsx      |
  | missing_name_header.xls | Header row is missing the Name column          |
  | blank.xls               | Header row is missing the Name column          |
  | blank.xls               | Header row is missing the Email column         |
  | blank.xls               | Header row is missing the Num Weeks Off column |

Scenario: Upload xls with invalid nurses
  And I choose "invalid_nurses.xls" to upload
  And I press "Upload"
  Then I should see "Nurse in row 3: Name can't be blank"
  And I should see "Nurse in row 4: Num weeks off can't be blank"
  And I should see "Nurse1"
  And I should not see the following nurses: "Jane Doe, John Doe"
