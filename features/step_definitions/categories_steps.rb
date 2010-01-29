Given /^the following categories:$/ do |categories|
  Categories.create!(categories.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) categories$/ do |pos|
  visit categories_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following categories:$/ do |expected_categories_table|
  expected_categories_table.diff!(tableish('table tr', 'td,th'))
end

Допустим /^в системе уже есть следующие категории Category1, Category2, Category3$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я перешел на страницу категорий$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть список категорий:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Допустим /^в системе еще нет категорий$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я перешел на страницу добавления категорий$/ do
  pending # express the regexp above with the code you wish you had
end

То /^список категорий не должен быть пустым$/ do
  pending # express the regexp above with the code you wish you had
end

Допустим /^Я на странице редактирования категории$/ do
  pending # express the regexp above with the code you wish you had
end

Если /^Я изменил поле "([^\"]*)" на значение "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

То /^поле "([^\"]*)" должно содержать "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Допустим /^есть следующие категории:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Если /^Я удаляю 3 категорию$/ do
  pending # express the regexp above with the code you wish you had
end

То /^Я должен увидеть следующие категории:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
