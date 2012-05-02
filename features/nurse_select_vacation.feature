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
  | unit | shift   | nurse    |
  | PMs  | Surgery | Jane Doe |

  And I am logged in as the Nurse "Jane Doe"
  And I am on the Nurse Calendar page for "Jane Doe" in "April" of "2012"

Scenario: Add a vacation
  When I follow "Add a vacation segment"
  And I fill in "start_at" with "18-Apr-2012"
  And I fill in "end_at" with "25-Apr-2012"
  And I press "Save Changes"
  Then I should see the vacation belonging to "Jane Doe" from "18-Apr-2012" to "25-Apr-2012"

Scenario: Add a vacation that overlaps
  When I follow "Add a vacation segment"
  And I fill in "start_at" with "11-Apr-2012"
  And I fill in "end_at" with "17-Apr-2012"
  And I press "Save Changes"
  Then I should see "The vacation to schedule was not valid"

Scenario: Add a vacation that is for a wrong year
  When I follow "Add a vacation segment"
  And I fill in "start_at" with "18-Apr-2019"
  And I fill in "end_at" with "25-Apr-2019"
  And I press "Save Changes"
  Then I should see "The vacation to schedule was not valid"


