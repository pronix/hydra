Given /^the following tasks:$/ do |tasks|
  Tasks.create!(tasks.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) tasks$/ do |pos|
  visit tasks_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following tasks:$/ do |expected_tasks_table|
  expected_tasks_table.diff!(tableish('table tr', 'td,th'))
end
Допустим /^у меня нет задач$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я перешел на страницу задач$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть пустую таблицу активных задач:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

То /^должен увидеть пустую таблицу завершенных задач:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я на страницу "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^Я нажал ссылку "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил название задачи$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал категорию задачи$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил описание задачи$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил ссылку на скачиваемый файл$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил пароль к скачиваемому файлу$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал макрос для превью$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал один файл для обложки$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^включил флажок "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^включел флажок "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал профайл для заливки файлов$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^выключил флажок "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^включен флажок "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал переключатель "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил имя архива$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил текст$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил макрос$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал тип "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал тип получение ссылок на картинки$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил размер архива$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил имя пароля для архива$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

То /^теперь у меня должно быть одна активная задача$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^У меня есть слудующие задачи:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Если /^Я удаляю 3 задачу$/ do
  pending # express the regexp above with the code you wish you had
end

То /^я должен увидеть оставшиеся задачи:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
