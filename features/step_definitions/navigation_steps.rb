То /^(?:|[Я|я] )должен увидеть главное меню$/ do
  response.should have_tag("ul.main_menu") do
    with_tag("li") do
      with_tag("a[href='#{dashboards_path}']", "Dashboard")
    end
    with_tag("li") { with_tag("a",  "Tasks") }
    with_tag("li") { with_tag("a",  "Tools") }
    with_tag("li") { with_tag("a",  "Settings") }
  end

end

То /^должен увидеть панель пользователя$/ do
  response.should have_tag("ul.user_panel") do
    with_tag("li", current_user.name || current_user.email)
    with_tag("li") do
      with_tag("a[href='#{logout_path}']", "Sign out")
    end
  end
end

То /^должен увидеть дополнительное меню Tools$/ do
  response.should have_tag("ul.sub_menu") do
    with_tag("li") { with_tag("a", "Macros")     }
    with_tag("li") { with_tag("a", "Files")      }
    with_tag("li") { with_tag("a", "Profiles")   }
    with_tag("li") { with_tag("a", "Categories") }
  end
end

То /^должен увидеть ссылку "([^\"]*)"$/ do |link|
  response.should have_tag("a",  link)
end

То /^должен не видеть ссылку "([^\"]*)"$/ do |link|
  response.should_not have_tag("a",  link)
end

То /^должен увидеть дополнительное меню Settings для пользователя$/ do
  response.should have_tag("ul.sub_menu") do
    with_tag("li") { with_tag("a", "My settings")     }
    with_tag("li") { with_tag("a", "Proxy")           }
  end
end

То /^должен увидеть дополнительное меню Settings для администратора$/ do
  response.should have_tag("ul.sub_menu") do
    with_tag("li") { with_tag("a", "My settings")     }
    with_tag("li") { with_tag("a", "Users")           }
    with_tag("li") { with_tag("a", "Proxy")           }
  end
end

То /^должен увидеть дополнительное меню Tasks$/ do
  response.should have_tag("ul.sub_menu") do
    with_tag("li") { with_tag("a", "Active tasks") }
    with_tag("li") { with_tag("a", "Completed tasks") }
    with_tag("li") { with_tag("a", "Create task") }
  end
end
