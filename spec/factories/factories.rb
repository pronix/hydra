Factory.define :user, :class => User do  |c|
end
Factory.define :category, :class => Category do  |c|
end
Factory.define :admin_role, :class => Role do  |c|
  c.name "admin"
end
Factory.define :user_role, :class => Role do  |c|
  c.name "user"
end
Factory.define :proxy, :class => Proxy do |c|
end
Factory.define :attachment, :class => AttachmentFile do |c|
  c.file File.new("#{RAILS_ROOT}/spec/factories/test_files/small_text_file.txt", "rb")
end
Factory.define :profile, :class => Profile do |c|
  
end
# do |f|
#   f.sequence(:username) { |n| "foo#{n}" }
#   f.password "foobar"
#   f.password_confirmation { |u| u.password }
#   f.sequence(:email) { |n| "foo#{n}@example.com" }
# end
