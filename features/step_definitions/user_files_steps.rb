Given /^the following user_files:$/ do |user_files|
  UserFiles.create!(user_files.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) user_files$/ do |pos|
  visit user_files_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following user_files:$/ do |expected_user_files_table|
  expected_user_files_table.diff!(tableish('table tr', 'td,th'))
end
