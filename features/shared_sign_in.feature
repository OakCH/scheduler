Feature: Shared Sign In

As a nurse or admin,
I want to be able to sign in to the website
So that I can access pages available to me while other pages are protected

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

  And I am on the Sign In page

Scenario: Sign in with valid credentials
  And I fill in "Email" with "jane@doe.com"
  And I fill in "Password" with "nurse_pw"
  When I press "Sign in"
  Then I should not see "Invalid email or password."

Scenario: Sign in with invalid credentials
  And I fill in "Email" with "jane@doe.com"
  And I fill in "Password" with "nurse_pw2"
  When I press "Sign in"
  Then I should be on the Sign In page
  And I should see "Invalid email or password."

Scenario: Logging in should be remembered
  And I am logged in as the Nurse "Jane Doe"
  When I am on the Sign In page
  Then I should be on the Nurse Calendar page for "Jane Doe"
  
Scenario Outline: Should not be able to view sensitive resources without login
  When I am on <unauthorized-page> 
  Then I should be on the Sign In page
  And I should see "You need to sign in or sign up before continuing."

Examples:
| unauthorized-page                                                    |
| the Nurse Calendar page for "Jane Doe"                               |
| the Vacation page for "Jane Doe" from "17-Apr-2012" to "24-Apr-2012" |
| the Edit Nurses page                                                 |

Scenario: Requesting a password reset
  And I follow "Forgot your password?"
  And I fill in "Email" with "jane@doe.com"
  And I press "Reset password"
  Then "jane@doe.com" should receive an email
