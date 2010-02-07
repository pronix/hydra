Допустим /^в сервисе уже есть следующие категории:$/ do |table|
  table.hashes.each do |hash|
    Factory(:category, :name => hash["name"], :created_at => hash["created_at"])
  end
end


То /^(?:|[Я|я] )должен увидеть список категорий:$/ do |table|
  response.should have_tag("table") do 
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end
    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["Name"])
        with_tag("td", hash["Created"])      
        with_tag("td") do 
          category = Category.find_by_name(hash["Name"])
          with_tag("a[href='#{edit_category_path(category)}']","Edit" )
          with_tag("a[href='#{edit_category_path(category)}']","Edit" )
        end
      end
    end
  end
end

То /^должен увидеть список категорий без ссылок редактирования:$/ do |table|
 response.should have_tag("table") do 
    
    with_tag("tr") do 
      table.headers.each do |k|
        with_tag("th", k)
      end
    end
    
    table.hashes.each do |hash|
      with_tag("tr") do
        with_tag("td", hash["Name"])
        with_tag("td", hash["Created"]) 
        category = Category.find_by_name(hash["Name"])
        without_tag("a[href='#{edit_category_path(category)}']","Edit" )
      end
    end
    
  end
  
end


Допустим /^в сервисе еще нет категорий$/ do
  Category.destroy_all
end


То /^список категорий не должен быть пустым$/ do
  Category.all.size.should == 1
end
Допустим /^(?:|[Я|я] )нажал ссылку "([^\"]*)" для категории "([^\"]*)"$/ do |link, category|
  @category = Category.find_by_name category
  click_link "href='#{edit_category_path(@category)}'"

end


Допустим /^перешел на страницу редактирования категории для "([^\"]*)"$/ do |category|
  visit path_to("edit category for #{category}")
end


Если /^(?:|[Я|я] )удаляю категорию "([^\"]*)"$/ do |category|
  puts response.body
  # @category = Category.find_by_name category
  # @category.destroy
  # visit path_to("categories"
                # ) 
  # within("td", category) do 
  #   click_link "Delete"
  # end
  # //a[@id='#{locator}' or contains(.,'#{locator}') or @title='#{locator}']
  # within "//td[text()='#{category}' and .//a[text()='Delete']" do |scope| 
  doc = Nokogiri::XML.parse(response.body)
  f =  doc.xpath("//td[text()='#{categories_steps.rb}']")
  f do |scope|
    scope.click_link "Delete"
  end
end

# When /I delete the "(.*)" entity/ do |row|
#   visits entities_url
#   puts entities_url
#   my_entity = Entity.find_by_entity_name(
#               "my entity number #{row.hll_words_to_i}")
#   puts "selector found" if have_selector(
#                "table > tbody > tr#" + dom_id(my_entity) + " > td > a")
#   within("table > tbody > tr#" + dom_id(my_entity) + " > td > a") do
#   click_link "Destroy Entity"
#   end
# end
 #  within "//*[.//text()='#{cell_value}' and .//a[text()='#{link}']]" do |scope|
 #   scope.click_link link
 # end
# When I follow the "Delete" link for "Harry Potter and half blood prince"
