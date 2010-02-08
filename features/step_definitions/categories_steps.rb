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

Если /^Я удаляю категорию "([^\"]*)" с названием "([^\"]*)"$/ do |pos, category_name|
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Delete"
  end
end
