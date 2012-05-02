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
  | name      | email     | units           |
  | Admin Doe | ad@ad.com | Surgery, Trauma |

  And I am logged in as the Admin "Admin Doe"
  And I am on the Associate Units page

Scenario: Seeing all the units
  Then I should see "ICU"
  And I should see "Surgery"
  And I should see "NICU"
  And I should see "Trauma"


Scenario: I should see the Surgery and Trauma checkbox marked
  Then the following checkboxes should be checked: "Surgery, Trauma"
  And the Admin "Admin Doe" should be watching the following units: "Surgery, Trauma"
  But the following checkboxes should not be checked: "NICU, ICU"
  And the Admin "Admin Doe" should not be watching the following units: "NICU, ICU"

Scenario: Adding ICU
  When I check "ICU"
  When I press "Submit"
  Then I should see "Units association changed"
  And the following checkboxes should be checked: "Surgery, Trauma, ICU"
  And the Admin "Admin Doe" should be watching the following units: "Surgery, Trauma, ICU"
  But the following checkboxes should not be checked: "NICU"
  And the Admin "Admin Doe" should not be watching the following units: "NICU"

Scenario: Removing all units
  When I uncheck "Surgery"
  And I uncheck "Trauma"
  And I press "Submit"
  Then I should see "Units association changed."
  But the following checkboxes should not be checked: "Surgery, NICU, ICU, Trauma"
  And the Admin "Admin Doe" should not be watching the following units: "Surgery, NICU, ICU, Trauma"

Scenario: Removing surgery and adding NICU
  When I uncheck "Surgery"
  And I check "NICU"
  When I press "Submit"
  And I should see "Units association changed."
  Then the following checkboxes should be checked: "Trauma, NICU"
  And the Admin "Admin Doe" should be watching the following units: "Trauma, NICU"
  But the following checkboxes should not be checked: "ICU, Surgery"
  And the Admin "Admin Doe" should not be watching the following units: "ICU, Surgery"
  
