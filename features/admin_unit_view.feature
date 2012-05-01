Feature: associate with units

As an admin,
I want to be associated with certain units

Background:

  Given the following units exist:
  | name    |
  | Trauma  |
  | Surgery |
  | ICU     |
  | NICU    |

  Given the following admins with units exist:
  | name       | units    |
  | Admin Doe  | asdfSurgery  |

  And I am logged in as an Admin
  And I am on the Associate Units page

Scenario: Seeing all the units
  I should see "ICU"
  And I should see "Surgery"
  And I should see "NICU"
  And I should see "Trauma"


Scenario: I should see the Surgery checkbox marked
  The "Surgery" checkbox should be checked
  And the "ICU" checkbox should not be checked
  And the "Trauma" checkbox should not be checked

Scenario: Adding ICU
  When I check "ICU"
  When I press "Submit"
  Then I should see "ICU added to list of units"
  And the "ICU" checkbox should be checked

Scenario: Removing surgery
  When I uncheck "Surgery"
  And I press "Submit"
  Then I should see "Surgery removed from list of units"
  And the "Surgery" checkbox should not be checked

Scenario: Removing surgery and adding Trauma
  When I uncheck "Surgery"
  And I check "Trauma"
  When I press "Submit"
  Then I should see "Surgery removed from list of units"
  And I should see "Trauma added to list of units"
  And the "Surgery" checkbox should not be checked
  And the "Trauma" checkbox should be checked
  