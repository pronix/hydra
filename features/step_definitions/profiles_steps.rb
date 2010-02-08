Допустим /^у пользователя "([^\"]*)" есть следующие profile:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["user_id"] = user.id
    Factory(:profile, hash)  
  end

end



То /^(?:|[Я|я] )должен увидеть список profiles:$/ do |table|
  response.should have_tag("table") do 
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end
    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["Name"])
        with_tag("td", hash["Created"])      
        with_tag("td") do 
          profile = current_user.profiles.find_by_name(hash["Name"])
          
          with_tag("a.edit[href='#{edit_profile_path(profile)}']","Edit" )
          with_tag("a.delete[href='#{profile_path(profile)}']","" )
        end
      end
    end
  end
end

Допустим /^у меня пока нет profiles$/ do
 current_user.profiles.destroy_all
end

То /^список profiles не должен быть пустым$/ do
  current_user.reload
  current_user.profiles.should_not be_empty
end
Допустим /^Я на странице редактирования "([^\"]*)"$/ do |profile|
  visit path_to("edit profile for #{profile}")
end
То /^значение поля "([^\"]*)" профайла "([^\"]*)" должно быть "([^\"]*)"$/ do |field, profile_name, new_value|
  current_user.profiles.reload
  profile = current_user.profiles.find_by_name profile_name
  profile.send(field.to_sym).should == new_value
end
Если /^Я удаляю профайл "([^\"]*)"$/ do |profile_name|
  profile  = current_user.profiles.find_by_name profile_name
  profile.destroy
  Допустим %{Я перешел на страницу "profiles"}
end
