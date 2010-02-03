Given /^the following profile_tasks:$/ do |profile_tasks|
  ProfileTask.create!(profile_tasks.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) profile_task$/ do |pos|
  visit profile_tasks_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following profile_tasks:$/ do |expected_profile_tasks_table|
  expected_profile_tasks_table.diff!(tableish('table tr', 'td,th'))
end
