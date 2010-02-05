Factory.define :user, :class => User do  |c|
end
Factory.define :category, :class => Category do  |c|
end

# do |f|
#   f.sequence(:username) { |n| "foo#{n}" }
#   f.password "foobar"
#   f.password_confirmation { |u| u.password }
#   f.sequence(:email) { |n| "foo#{n}@example.com" }
# end
