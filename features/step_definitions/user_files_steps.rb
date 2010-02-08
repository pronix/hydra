Допустим /^у пользователя "([^\"]*)" есть следующие файлы:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["user_id"] = user.id
    Factory(:attachment, hash)  
  end
end

То /^(?:|[Я|я] )должен увидеть список файлов:$/ do |table|
  # table.diff!(tableish('table.user_files tr', lambda{ |tr| tr.search("td,th").map{ |x| x } }))
  table.diff!(tableish('table.user_files tr', 'td,th'))
end

Допустим /^у меня нет не одного файла$/ do
 current_user.attachment_files.destroy_all
end
Если /^Я выбрал в поле "([^\"]*)" файл "([^\"]*)"$/ do |field, path|
 attach_file(field, File.join(RAILS_ROOT, path))

end

То /^список моих файлов не должен быть пустым$/ do
  current_user.attachment_files.should_not be_nil
end

Если /^Я удаляю "([^\"]*)" файл с именем "([^\"]*)"$/ do |pos, file_name|
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Delete"
  end
end
