Допустим /^у пользователя "([^\"]*)" есть следующие файлы:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["assetable_id"] = user.id
    Factory(:user_file, hash)
  end
end

То /^(?:|[Я|я] )должен увидеть список файлов:$/ do |table|
  # table.diff!(tableish('table.user_files tr', lambda{ |tr| tr.search("td,th").map{ |x| x } }))
  table.diff!(tableish('table.user_files tr', 'td,th'))
end

Допустим /^у меня нет не одного файла$/ do
 current_user.user_files.destroy_all
end
Если /^(?:|[Я|я] )выбрал в поле "([^\"]*)" файл "([^\"]*)"$/ do |field, path|
  type =  case path.split(".")[1]
          when "jpg"
            "image/jpg"
          when "jpeg"
            "image/jpeg"
          when "png"
            "image/png"
          when "gif"
            "image/gif"
            else
            "text/txt"
          end
  attach_file(field, File.join(RAILS_ROOT, path), type)

end

То /^список моих файлов не должен быть пустым$/ do
  current_user.user_files.reload
  current_user.user_files.should_not be_empty
end

Если /^Я удаляю "([^\"]*)" файл с именем "([^\"]*)"$/ do |pos, file_name|
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Delete"
  end
end
