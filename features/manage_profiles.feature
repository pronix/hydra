# language: ru
Функционал: Profiles
  Список Profiles с данными(логин, пароль), для загрузки файлов в сервис mediavalise.
  Как пользователь
  Должен иметь возможность просматривать, редактировать, удалить и добавлять свои profiles.

  Сценарий: Список Profiles
    Допустим у меня есть список profiles Profile1, Profile2
        Если Я перешел на страницу Profiles
          То Я должен увидеть главное меню
             И должен увидеть панель пользователя
             И должен увидеть дополнительное меню "Tools"  
             И должен увидеть ссылку "Create profile"
             И должен увидеть список profile:
                | name      |    created | actions      |
                | profile 1 | 23.01.2010 | edit, delete |
                | profile 2 | 11.01.2010 | edit, delete |

  Сценарий: Добавление Profiles
    Допустим Я на странице нового profile
             И у меня пока нет profile
        Если Я заполнил поле "name" значением "free"
             И заполнил поле "login" значением "free_login"
             И заполнил поле "password" значением "free_secret"
             И нажал кнопку "Create"
          То Я должен увидеть сообщение "New profile free has been created"
             И список profiles не должен быть пустым

  Сценарий: Редактирование Profiles
    Допустим Я на странице редактирования profile1
        Если Я изменил поле "name" на значение "new_profile"
             И нажал кнопку "Updated"
          То Я должен увидеть сообщение "Profile new_profile has been updated"
             И в списке profiles должен быть profile с "name" "new_profile"

  Сценарий: Удаление Profiles
    Допустим у меня есть следующие profile:
             | name     |
             | profile1 |
             | profile2 |
             | profile3 | 
      Если Я удаляю profile2
        То Я должен увидеть сообщение "Profile profile2 has been deleted"
           И должен увидеть следующий список profile:
           | name     |
           | profile1 |
           | profile3 |

