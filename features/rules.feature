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
	 | David Doe | Days  | Surgery |
	 | Jeff Doe  | Days  | Surgery |
	And I am logged in as an Admin
	And I am on the Rules page

Scenario: Choosing 3-month segments
	When I select "Days" from "Shift"
  	And I select "Surgery" from "Unit"
  	And I press "Next"
	And I select "January" from "seg2"
	And I select "February" from "seg1"
	And I press "Done"
	Then I should see "You have selected January and February as the start date for your additional segments"
