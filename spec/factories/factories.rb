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
Factory.define :user_file, :class => UserFile do |c|
  c.attachment File.new("#{RAILS_ROOT}/spec/factories/test_files/small_text_file.txt", "rb")
  c.assetable_type "User"
end
Factory.define :profile, :class => Profile do |c|
end

Factory.define :task, :class => Task do |t|
  t.association :category, :factory => :category
end

Factory.define :active_task, :class => Task do |t|
  t.state %w( queued downloading extracting generation renaming packing uploading finished)[rand(8)]
end
Factory.define :completed_task, :class => Task do |t|
  t.state %w( error completed )[rand(2)]
end
# do |f|
#   f.sequence(:username) { |n| "foo#{n}" }
#   f.password "foobar"
#   f.password_confirmation { |u| u.password }
#   f.sequence(:email) { |n| "foo#{n}@example.com" }
# end
