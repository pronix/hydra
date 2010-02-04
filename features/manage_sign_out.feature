# language: ru
Функционал: Выход из сервиса.
  Пользователь должен иметь возможность выйти из сервиса. 

  
  Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
     | nickname  | password | login     | email                | admin |
     | admin     | secret   | admin     | admin_user@gmail.com | true  |
     | free_user | secret   | free_user | free_user@gmail.com  | false |
  Сценарий: Пользователь выходит из сервиса
    Допустим Я зашел в сервис как "free_user/secret"
       Если Я нажал ссылку "sign out"
         То Я должен увидеть сообщение "Goodbye"
            И должен быть переправлен на страницу "login"


