Feature: Admin Sign In

As an admin,
I want to be able to sign in to the website
So that I will be able to access scheduling information

Background:

  Given the following current years exist
  | year |
  | 2012 |

  Given the following nurses exist
  | name     | email        |
  | Jane Doe | jane@doe.com |
    
  And the following vacations exist:
  | name     | start_at    | end_at      |
  | Jane Doe | 17-Apr-2012 | 24-Apr-2012 |
    
Scenario: Sign in with valid credentials
  Given the following admins exist
  | name      | email         |
  | Admin Doe | admin@doe.com |

  And I am on the Sign In page
  And I fill in "Email" with "admin@doe.com"
  And I fill in "Password" with "admin_pw"
  When I press "Sign in"
  Then I should be on the Admin Calendar page

Scenario Outline: Admin should be able to view pages nurses can as well as admin pages
  And I am logged in as an Admin
  When I am on <authorized-page>
  Then I should not see "You cannot access that page"

Examples:
| authorized-page                                                      |
| the Nurse Calendar page for "Jane Doe"                               |
| the Vacation page for "Jane Doe" from "17-Apr-2012" to "24-Apr-2012" |
| the Edit Nurses page                                                 |

Scenario: Signed in nurse should not be able to view admin pages
  And I am logged in as the Nurse "Jane Doe"
  When I am on the Edit Nurses page
  Then I should be on the Nurse Calendar page for "Jane Doe"
  And I should see "You cannot access that page"
