# language: ru
Функционал: Profiles
  Список Profiles с данными(логин, пароль), для загрузки файлов в сервис mediavalise.
  Как пользователь
  Должен иметь возможность просматривать, редактировать, удалить и добавлять свои profiles.

  Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
      | nickname  | password | email                | admin |
      | admin     | secret   | admin_user@gmail.com | true  |
      | free_user | secret   | free_user@gmail.com  | false |
      И у пользователя "free_user@gmail.com" есть следующие profile:
      | name     | created_at       | login     | password | host         |
      | profile1 | 23.01.2010 12:06 | free_user |   123456 | imagebam.com |
      | profile2 | 11.01.2010 02:34 | paid_user |   123456 | imagebam.com |
      И я зашел в сервис как "free_user@gmail.com/secret"

  Сценарий: Список Profiles
    Допустим Я перешел на страницу "profiles"
          То Я должен увидеть главное меню
             И должен увидеть панель пользователя
             И должен увидеть дополнительное меню Tools
             И должен увидеть ссылку "Create profile"
             И должен увидеть список profiles:
                | Name     | Hosting      | Created          | Actions      |
                | profile1 | imagebam.com | 23.01.2010 12:06 | edit, delete |
                | profile2 | imagebam.com | 11.01.2010 02:34 | edit, delete |

  Сценарий: Добавление Profiles
    Допустим Я на странице "new profile"
             И у меня пока нет profiles
        Если Я заполнил поле "profile[name]" значением "free"
             И заполнил поле "profile[login]" значением "free_login"
             И заполнил поле "profile[password]" значением "free_secret"
             И нажал кнопку "Create"
          То Я должен увидеть сообщение "Profile was successfully created."
             И список profiles не должен быть пустым

  Сценарий: Редактирование Profiles
    Допустим Я на странице редактирования "profile1"
        Если Я изменил поле "profile[name]" на значение "new_profile"
             И нажал кнопку "Save"
          То Я должен увидеть сообщение "Profile was successfully updated."
             И значение поля "name" профайла "new_profile" должно быть "new_profile"


  Сценарий: Удаление Profiles
  Допустим Я перешел на страницу "profiles"
      Если Я удаляю профайл "profile2"
        То Я должен увидеть список profiles:
                | Name     | Hosting      | Created          | Actions      |
                | profile1 | imagebam.com | 23.01.2010 12:06 | edit, delete |


