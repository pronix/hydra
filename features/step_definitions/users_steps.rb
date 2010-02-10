То /^(?:|[Я|я] )должен увидеть таблицу пользователей:$/ do |table|
  table.diff!(tableish('table tr', 'td,th'))
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
