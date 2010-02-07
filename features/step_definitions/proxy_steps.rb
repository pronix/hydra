Допустим /^у пользователя "([^\"]*)" есть следующие proxy:$/ do |user_email, table|
  user = User.find_by_email user_email
  table.hashes.each do |hash|  
    Factory(:proxy,hash)
  end

end
То /^должен увидеть список proxy:$/ do |table|
  response.should have_tag("table") do 
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end

    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["address"])
        with_tag("td", hash["country"])
        with_tag("td", hash["status"])
        with_tag("td") do 
          with_tag("a", "Edit")
          with_tag("a", "Delete")
        end
      end
    end
  end
end
