Given /^the following macros:$/ do |macros|
  Macros.create!(macros.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) macros$/ do |pos|
  visit macros_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following macros:$/ do |expected_macros_table|
  expected_macros_table.diff!(tableish('table tr', 'td,th'))
end
 Given /^the following cats:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When /^I delete the 3rd cat$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the following cats:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я на странице нового макроса$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я заполнил поле "([^\"]*)" значением "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Если /^заполнил поле "([^\"]*)" значением "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Если /^включил флажок "([^\"]*)" значением "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Если /^выбрал значение "([^\"]*)" поля "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Если /^нажал кнопку "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть сообщение "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Допустим /^у меня есть следующие макросы:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Если /^Я удаляю третий макрос$/ do
  pending # express the regexp above with the code you wish you had
end

То /^я должен увидеть слудующие макросы:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
