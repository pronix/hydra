module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^completed tasks/
      tasks_path(:status => :completed)
    when /^active tasks/
      tasks_path(:status => :active )
    when /^delete profile (.*)$/
      @profile = current_user.profile.find_by_name $1
      profile_path(@profile, :delete)
    when /^edit profile for (.*)$/
      @profile = current_user.profiles.find_by_name $1
      edit_profile_path(@profile)
    when /^new profile/
      new_profile_path
    when /^profiles/
      profiles_path

    when /^new file/
      new_user_file_path
    when /^user files/
      user_files_path

    when /^edit proxy for (.*)$/
      @proxy = current_user.proxies.find_by_address $1
      edit_proxy_path(@proxy)

    when /^proxies/
      proxies_path

    when /^edit user for (.*)$/
      @user = User.find_by_email $1
      edit_user_path(@user)

    when /^new user/
      new_user_path
    when /^users/
      users_path
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
    when /the new checker_proxy page/
      new_checker_proxy_path

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
