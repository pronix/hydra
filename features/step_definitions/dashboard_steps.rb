Допустим /^(?:|[Я|я] )не авторизован$/ do
  current_user && current_user.destroy rescue true
end

