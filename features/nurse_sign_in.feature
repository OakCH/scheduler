Feature: Nurse Sign In

As a nurse,
I want to be able to sign in to the website
So that I will be directed to the proper calendar page

Background:

  Given the following nurses exist
  | name     | email        | password  |
  | Jane Doe | jane@doe.com | nurse_pw  |
  | John Doe | john@doe.com | nurse_pw2 |

  And the following vacations exist:
  | name     | start_at    | end_at      |
  | Jane Doe | 17-Apr-2012 | 24-Apr-2012 |
  | John Doe | 20-Apr-2012 | 27-Apr-2012 |
  
Scenario: Sign in with valid credentials
  And I am on the Sign In page
  And I fill in "Email" with "jane@doe.com"
  And I fill in "Password" with "nurse_pw"
  When I press "Sign in"
  Then I should be on the Nurse Calendar page for "Jane Doe"

Scenario: Shouldn't be able to view a different nurse's calendar page
  And I am logged in as the Nurse "Jane Doe"
  When I am on the Nurse Calendar page for "John Doe"
  Then I should be on the Nurse Calendar page for "Jane Doe"
  And I should see "You cannot access that page"

Scenario: Should be able to view ones own event page
  And I am logged in as the Nurse "Jane Doe"
  When I am on the Vacation page for "Jane Doe" from "17-Apr-2012" to "24-Apr-2012"
  And I should not see "You cannot access that page"

Scenario: Shouldn't be able to view a different nurse's event page
  And I am logged in as the Nurse "Jane Doe"
  When I am on the Vacation page for "John Doe" from "20-Apr-2012" to "27-Apr-2012"
  Then I should be on the Nurse Calendar page for "Jane Doe"
  Then I should see "You cannot access that page"
