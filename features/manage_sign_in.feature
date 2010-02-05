# language: ru
 Функционал: Вход
   Для доступа к сервису
   Пользователь 
   Должен иметь возможность входа


  Сценарий: Пользователь зарегистрирован
    Допустим в сервисе зарегистрированы следующие пользователи:
             | nickname  | password | login     | email                | admin |
             | admin     | secret   | admin     | admin_user@gmail.com | true  |
             | free_user | secret   | free_user | free_user@gmail.com  | false |
      Если Я перешел на страницу "login"
           И заполнил поле "login" значением "free_user"
           И заполнил поле "password" значением "secret"
           И нажал кнопку "Login"
        То Я должен быть переправлен на страницу "dashboard"

  Сценарий: Авторизация пользователя с запоминанием для следующего входа 
    Допустим в сервисе зарегистрированы следующие пользователи:
             | nickname  | password | login     | email                | admin |
             | admin     | secret   | admin     | admin_user@gmail.com | true  |
             | free_user | secret   | free_user | free_user@gmail.com  | false |
      Если Я перешел на страницу "login"
           И заполнил поле "login" значением "free_user"
           И заполнил поле "password" значением "secret"
           И включил флажок "Remember me" 
           И нажал кнопку "Login"
        То Я должен быть переправлен на страницу "dashboard"
      Если Я занова перешел на страницу "login"
        То Я должен быть переправлен на страницу "dashboard"

  Сценарий: Пользователь не зарегистрирован
    Допустим в сервисе нет зарегистрированных пользователей
      Если Я перешел на страницу "login"
           И заполнил поле "login" значением "free_user"
           И заполнил поле "password" значением "secret"
           И нажал кнопку "login"
        То Я должен увидеть сообщение "is not valid"

  Сценарий: Пользователь вводит неверный пароль
    Допустим в сервисе зарегистрированы следующие пользователи:
             | nickname  | password | login     | email                | admin |
             | admin     | secret   | admin     | admin_user@gmail.com | true  |
             | free_user | secret   | free_user | free_user@gmail.com  | false |
      Если Я перешел на страницу "login"
           И заполнил поле "login" значением "free_user"
           И заполнил поле "password" значением "secret1"
           И нажал кнопку "Login"
        То Я должен увидеть сообщение "is not correct"

