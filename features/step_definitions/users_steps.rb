То /^(?:|[Я|я] )должен увидеть таблицу пользователей:$/ do |table|
  response.should have_tag("table") do 
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end

    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["Login"])
        with_tag("td", hash["Added date"])
        with_tag("td", hash["Tasks"])
        with_tag("td") do 
          with_tag("a", "Edit")
          with_tag("a", "Delete")
        end
      end
    end
  end
end

Допустим /^(?:|[Я|я] )перешел на странице редактирования пользователя "([^\"]*)"$/ do |email|
  visit path_to("edit user for #{email}")
end

Допустим /^у пользователя "([^\"]*)" нет задач$/ do |email|
  user = User.find_by_email email
  user.active_tasks = 0
  user.completed_tasks = 0
  user.save
  user.tasks.destroy_all
end

Если /^(?:|[Я|я] )удаляю пользователя "([^\"]*)"$/ do |email|
  user = User.find_by_email email
  user.destroy
  visit path_to("users")
end
Если /^выбрал роль "([^\"]*)"$/ do |role_name|
  role = Role.find_by_name role_name
  check("user_role_ids_#{role.id}")
end
