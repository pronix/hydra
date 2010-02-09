Given /^the following checker_proxies:$/ do |checker_proxies|
  CheckerProxy.create!(checker_proxies.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) checker_proxy$/ do |pos|
  visit checker_proxies_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following checker_proxies:$/ do |expected_checker_proxies_table|
  expected_checker_proxies_table.diff!(tableish('table tr', 'td,th'))
end
