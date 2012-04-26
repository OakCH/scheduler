Feature: Print Calendar as Admin

As an admin, 
I want to be able to print the entire schedule the nurses' vacation assignments
So that I can monitor the vacation scheduling.

Background:

  Given the following nurses exist
  | name        | shift | unit       |
  | Jane Doe    | Days  | Surgery    |
  | John Doe    | PMs   | Surgery    |
  | J.P. Morgan | PMs   | Surgery    |
  | K.D. Tang   | PMs   | Cardiology |

  And the following vacations exist
  | name        | start_at    | end_at      |
  | Jane Doe    | 17-Feb-2012 | 24-Feb-2012 |
  | John Doe    | 1-Mar-2012  | 8-Mar-2012  |
  | Jane Doe    | 4-Mar-2012  | 12-Mar-2012 |
  | J.P. Morgan | 17-Jan-2012 | 24-Jan-2012 |
  | K.D. Tang   | 17-Jan-2012 | 24-Jan-2012 |

  And I am logged in as an Admin
  And I am on the Admin Calendar page in "February" of "2012"
  And I select "Surgery" from "Unit"
  And I select "Days" from "Shift"
  And I press "Filter calendars"
  And 

Scenario: Print calendar for the Surgery unit and the PMs shift
