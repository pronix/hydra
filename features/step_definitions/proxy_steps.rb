Допустим /^у пользователя "([^\"]*)" есть следующие proxy:$/ do |user_email, table|
  user = User.find_by_email user_email

  table.hashes.each do |hash|
    hash["user_id"] = user.id
    Factory(:proxy,hash)
  end

end
То /^(?:|[Я|я] )должен увидеть список proxy:$/ do |table|
  table.diff!(tableish('table tr', 'td,th'))
end
Допустим /^(?:|[Я|я]) на странице редактирования proxy для "([^\"]*)"$/ do |proxy|
  visit path_to("edit proxy for #{proxy}")
end
