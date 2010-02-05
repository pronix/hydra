То /^должен увидеть свой "([^\"]*)"$/ do |field|
  response.should contain(current_user.send(field.to_sym))
end

То /^(?:|[Я|я] )должен увидеть кнопку "([^\"]*)"$/ do |value|
  response.should have_tag("input[type=submit][value='#{value}']")
end

То /^(?:|[Я|я] )должен увидеть текстовое поле "([^\"]*)"$/ do |field|
  response.should have_tag("input[type=text][name='#{field}']")
end

То /^должен увидеть поле для пароля "([^\"]*)"$/ do |field|
  response.should have_tag("input[type=password][name='#{field}']")
end

Допустим /^перешел на страницу редактирования настроек$/ do
  visit path_to("edit settings")
end

То /^должен увидеть свой новый nickname  "([^\"]*)"$/ do |value|
  response.should contain(value) 
end
