Feature: Print Calendar as Admin

As an admin, 
I want to be able to print the entire schedule the nurses' vacation assignments
So that I can monitor the vacation scheduling.

Background:

  Given the following current years exist
  | year |
  | 2012 |

  Given the following nurses exist
  | name        | shift | unit       |
  | Jane Doe    | Days  | Surgery    |
  | John Doe    | PMs   | Surgery    |
  | J.P. Morgan | PMs   | Surgery    |
  | K.D. Tang   | PMs   | Cardiology |

  And the following vacations exist
  | name        | start_at    | end_at      | 
  | Jane Doe    | 17-Mar-2012 | 23-Mar-2012 | 
  | John Doe    | 1-Apr-2012  | 8-Apr-2012  | 
  | Jane Doe    | 4-Apr-2012  | 12-Apr-2012 | 
  | J.P. Morgan | 17-Feb-2012 | 24-Feb-2012 | 
  | K.D. Tang   | 17-Feb-2012 | 24-Feb-2012 |

  And I am logged in as an Admin
  And I am on the Admin Calendar page in "March" of "2012"
  And I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I press "Filter calendars"
  And I follow "View and print entire schedule"

Scenario: Print calendar for the Surgery unit and the Days shift
  Then I should not see vacations belonging to "John Doe"
  And I should not see vacations belonging to "J.P. Morgan"
  And I should see vacations belonging to "Jane Doe"
  And I should not see vacations belonging to "K.D. Tang"
