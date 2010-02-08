Допустим /^у пользователя "([^\"]*)" есть следующие файлы:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|
    hash["user_id"] = user.id
    Factory(:attachment, hash)  
  end
end


То /^(?:|[Я|я] )должен увидеть список файлов:$/ do |table|
  response.should have_tag("table") do 
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end
    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["Name"])
        with_tag("td", hash["Uploaded"])      
        with_tag("td") do 
          att = current_user.attachment_files.find_by_name(hash["Name"])
          with_tag("a[href='#{edit_user_file_path(att)}']","Edit" )
          with_tag("a.delete[href='#{user_file_path(att)}']","" )
        end
      end
    end
  end
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
Если /^Я удаляю "([^\"]*)" файл$/ do |file_name|
  file = current_user.attachment_files.find_by_name(file_name)
  file.destroy
  Допустим %{Я перешел на страницу "user files"}
end
