Given /^the following user_files:$/ do |user_files|
  UserFiles.create!(user_files.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) user_files$/ do |pos|
  visit user_files_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following user_files:$/ do |expected_user_files_table|
  expected_user_files_table.diff!(tableish('table tr', 'td,th'))
end


Допустим /^у меня есть несколько макросов Macros1, Mascro2$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я перешел на страницу макросов$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть список макросов:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

То /^у меня теперь должен появиться макрос$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил поле "([^\"]*)" значение "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Допустим /^у меня есть несколько файлов File1, File2$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я перешел на страницу файлов$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть список файлов:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я на странице загрузки нового файла$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^у меня нет не одного файла$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я выбрал файл$/ do
  pending # express the regexp above with the code you wish you had
end

То /^список моих файлов не должен быть пустым$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я на странице файлов$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^у меня есть следующие файлы:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Если /^Я удаляю третий файл$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть следующие файлы:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Допустим /^у нас есть следущие пользователи$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
