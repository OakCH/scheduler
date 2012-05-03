Feature: Nurse selecting vacation times

As a nurse,
I want to be able to select vacation times

Background:

  Given the following current years exist
  | year |
  | 2012 |

  Given the following nurses exist:
  | name       | shift | unit    |
  | Jane Doe   | PMs   | Surgery |
  | John Doe   | PMs   | Surgery |
  | Rob Ronney | PMs   | Surgery |    
  
  And the following vacations exist:
  | name       | start_at    | end_at      | pto |
  | Rob Ronney | 11-Apr-2012 | 17-Apr-2012 | 1   |

  And the following nurse batons exist
  | unit    | shift | nurse    |
  | Surgery | PMs   | Jane Doe |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurse Calendar page for "Jane Doe" in "April" of "2012"
  And I follow "Add a vacation segment"

Scenario: Add a vacation
  When I fill in "event_start_at" with "04/18/2012"
  And I fill in "event_end_at" with "04/25/2012"
  And I press "Save Changes"
  Then I should see the vacation belonging to "Jane Doe" from "18-Apr-2012" to "25-Apr-2012"

Scenario: Add a vacation that overlaps
  When I fill in "event_start_at" with "04/11/2012"
  And I fill in "event_end_at" with "04/17/2012"
  And I press "Save Changes"
  Then I should see "You have selected a day that has no more availability"

Scenario: Add a vacation that is for a wrong year
  When I fill in "event_start_at" with "04/18/2019"
  And I fill in "event_end_at" with "04/25/2019"
  And I press "Save Changes"
  Then I should see "Please select a vacation for the currently scheduled year"


