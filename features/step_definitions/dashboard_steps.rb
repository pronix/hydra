Given /^the following dashboards:$/ do |dashboards|
  Dashboard.create!(dashboards.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) dashboard$/ do |pos|
  visit dashboards_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following dashboards:$/ do |expected_dashboards_table|
  expected_dashboards_table.diff!(tableish('table tr', 'td,th'))
end
