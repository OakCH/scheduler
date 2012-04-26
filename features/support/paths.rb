# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'

    when /^the Edit Nurses page$/
      '/admin/upload/'

    when /^the Nurse Calendar page for "([^"]*)" in "([^"]*)" of "([^"]*)"$/
      nurse = Nurse.find_by_name($1)
      month = Date::MONTHNAMES.index($2)
      nurse_calendar_index_path(nurse, :month => month.to_s, :year => $3.to_s)

    when /^the Nurse Calendar page for "([^"]*)"$/
      nurse_calendar_index_path(Nurse.find_by_name($1))

    when /^the Admin Calendar page in "([^"]*)" of "(\d{4})"$/
      month = Date::MONTHNAMES.index($1)
      admin_calendar_path(:month => month.to_s, :year => $2.to_s)

    when /^the Sign In page$/
      new_user_session_path

    when /^the Vacation page for "([^"]*)" from "([^"]*)" to "([^"]*)"$/
      nurse_calendar_path(Nurse.find_by_name($1), event_finder($1, $2, $3))

    when /^the Rules page$/
      '/admin/rules'

    when /^the Admin Calendar page$/
      admin_calendar_path

    when /^the Units page$/
      units_path

    when /^the Manage Nurses page$/
      nurse_manager_index_path

    when /^the Nurse Print page for "([^"]*)"$/
      print_nurse_calendar_index_path(Nurse.find_by_name($1))

    # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
    #
      #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
