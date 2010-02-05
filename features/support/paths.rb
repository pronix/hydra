module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^edit settings/
      edit_settings_path
    when /^settings/
      settings_path
    when /^categories/
      categories_path
    when /dashboard/
      dashboards_path
    when /login/
      login_path
    when /the home\s?page/
      '/'
    when /the new profile_task page/
      new_profile_task_path

    when /the new profile_tasks page/
      new_profile_tasks_path

    when /the new profiles page/
      new_profiles_path

    when /the new cat page/
      new_cat_path

    when /the new cat page/
      new_cat_path

    when /^new categories/
      new_category_path
      
    when /^edit category for (.*)$/
      @category = Category.find_by_name $1
      edit_category_path(@category)
        
    when /the new profiles page/
      new_profiles_path

    when /the new user_files page/
      new_user_files_path

    when /the new macros page/
      new_macros_path

    when /the new users page/
      new_users_path

    when /the new tasks page/
      new_tasks_path

    when /the new tasks page/
      new_tasks_path

    when /the new dashboard page/
      new_dashboard_path

    when /the new dashboard page/
      new_dashboard_path

    when /the new frooble page/
      new_frooble_path

    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
