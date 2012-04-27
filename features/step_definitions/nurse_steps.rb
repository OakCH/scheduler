Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.

    myregex = /.*#{e1}.*(.*\n)*\s*.*#{e2}.*/
    assert page.body =~ myregex 
end

