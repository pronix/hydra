module UserHelpers
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
 
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
end
World(UserHelpers)
 

Допустим /^в сервисе зарегистрированы следующие пользователи:$/ do |table|
  Factory(:admin_role)
  Factory(:user_role)
  table.hashes.each do |hash|  
    hash["name"] = hash["nickname"]
    hash["password_confirmation"] = hash["password"]
    hash.delete("nickname")
    admin = hash["admin"].to_s == "true" ? true : false
    hash.delete("admin")
    user = Factory(:user,hash)
    admin ? user.has_role!(:admin) : user.has_role!(:user)
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

Допустим /^(?:|[Я|я] )зашел в сервис как "(.*)\/(.*)"$/ do |email, password|

  Допустим %{Я перешел на страницу "login"}
         И %{заполнил поле "user_session[email]" значением "#{email}" }
         И %{заполнил поле "user_session[password]" значением "#{password}" }
         И %{нажал кнопку "Login"}

end
