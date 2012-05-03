Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  
    myregex = /.*#{e1}.*(.*\n)*\s*.*#{e2}.*/
    assert page.body =~ myregex 
end

Given /^"(.*)" sets up (?:his|her) nurse account$/ do |nurse_name|
  nurse = Nurse.find_by_name(nurse_name)
  User.accept_invitation!(:invitation_token => nurse.invitation_token, :email => nurse.email,
                          :password => 'nurse_pw', :password_confirmation => 'nurse_pw')
end

Given /^"(.*)" finalize their vacations$/ do |nurse_names|
  nurse_names.split(', ').each do |nurse_name|
    step %Q{"#{nurse_name}" sets up his nurse account}
    step %Q{I am logged in as the Nurse "#{nurse_name}"}
    step %Q{I press "Finalize Your Vacation"}
    step %Q{I log out}
  end
end
