Допустим /^в сервисе зарегистрированы следующие пользователи:$/ do |table|
  table.hashes.each do |hash|  

    user = Factory(:user, 
                   :name => hash["nickname"],
                   :login => hash["login"],
                   :email => hash["email"],
                   :password => hash["password"],
                   :password_confirmation => hash["password"],
                   :admin => hash["admin"])
  end 
end

То /^(?:|Я )должен быть переправлен на страницу "([^\"]*)"$/ do |page|
  redirect_to(path_to(page))

end

Если /^(?:|Я )занова перешел на страницу "([^\"]*)"$/ do |page|
  visit path_to(page)
end

Допустим /^в сервисе нет зарегистрированных пользователей$/ do
 User.destroy_all
end

Допустим /^(?:|Я )зашел в сервис как "(.*)\/(.*)"$/ do |login, password|
  Допустим %{Я перешел на страницу "login"}
         И %{заполнил поле "login" значением "free_user" }
         И %{заполнил поле "password" значением "secret" }
         И %{нажал кнопку "Login"}

end
