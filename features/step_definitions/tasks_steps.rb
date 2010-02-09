Допустим /^у пользователя "([^\"]*)" есть следующие активные задачи:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["user_id"] = user.id
    hash["category_id"] = Factory(:category, :name => hash[:category]).id
    hash.delete("category")
    Factory(:task, hash)
  end

end
Допустим /^у пользователя "([^\"]*)" есть завершенные задачи:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["user_id"] = user.id
    hash["category_id"] = Factory(:category, :name => hash[:category]).id
    hash.delete("category")
    Factory(:task, hash)
  end
end


То /^должен увидеть таблицу задач:$/ do |table|
 table.diff!(tableish('table.tasks tr', 'td,th'))
end
То /^должен увидеть фильтр Category$/ do
  response.should have_tag("select") do
    Category.all.each do |t|
      with_tag("option", t.name)
    end
  end
end
