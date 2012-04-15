Feature: Administrators should be able to change the rules

As an admin, 
I want to be able to change the rules governing vacation times
So that I can continue using this website in the future

Background:
	Given "Surgery" is a type of Unit
	And the following nurses exist
	 | name      | shift | unit    |
	 | Jane Doe  | Days  | Surgery |
	 | John Doe  | Days  | Surgery |
	 | Bob Doe   | Days  | Surgery |
	 | Bill Doe  | Days  | Surgery |
	And I am logged in as an Admin
	And I am on the Rules page

Scenario: Don't have 3-month segments to choose from
	When I select "Days" from "Shift"
  	And I select "Surgery" from "Unit"
  	And I press "Next"
  	Then I should see "There are no additional 3-month segments this year."

Scenario: Choosing 3-month segments
	Given the following nurses exist
	 | name      | shift | unit    |	
	 | David Doe | Days  | Surgery |
	 | Jeff Doe  | Days  | Surgery |
	And I select "Days" from "Shift"
  	And I select "Surgery" from "Unit"
  	And I press "Next"
	And I select "January" from "Segment 1"
	And I select "February" from "Segment 2"
	And I press "Done"
	Then I should see "Your changes have been saved"
