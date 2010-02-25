 user_role = Role.find_or_create_by_name "user"
 if user_role
  User.all.each { |u| u.has_role! user_role.name.to_sym }
 end


