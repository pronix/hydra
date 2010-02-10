# language: ru
 Функционал: Управление Пользователями
   Настройка пользователей
   Администратор должен иметь возможность добавлять, удалять и редактировать пользователей.
   Пользователь должен иметь возможность редактировать свою учетную запись

   Предыстория:
     Допустим в сервисе зарегистрированы следующие пользователи:
              | nickname  | password | email                | admin | completed_tasks | active_tasks | created_at       |
              | admin     | secret   | admin_user@gmail.com | true  |               3 |           12 | 20.01.2010 15:09 |
              | free_user | secret   | free_user@gmail.com  | false |               2 |            9 | 12.12.2009 12:24 |
              И зашел в сервис как "admin_user@gmail.com/secret"

    Сценарий: Список пользователей
      Допустим Я перешел на страницу "users"
            То Я должен увидеть главное меню
               И должен увидеть панель пользователя
               И должен увидеть ссылку "Add user"
               И должен увидеть дополнительное меню Settings для администратора
               И должен увидеть таблицу пользователей:
                 | Login                | Added date       | Tasks | Actions     |
                 | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |
                 | free_user@gmail.com  | 12.12.2009 12:24 | 9/2   | Edit Delete |


    Сценарий: Создание нового пользователя
      Допустим я перешел на страницу "new user"
          Если Я заполнил поле "user[name]" значением "other_user"
               И заполнил поле "user[email]" значением "other_user@gmail.com"
               И заполнил поле "user[notification_email]" значением "other_user@gmail.com"
               И заполнил поле "user[password]" значением "other_secret"
               И заполнил поле "user[password_confirmation]" значением "other_secret"
               И выбрал роль "admin"
               И нажал кнопку "Create"
            То Я должен увидеть сообщение "User was successfully created."

    Сценарий: Редактирование данных пользователя
      Допустим Я перешел на странице редактирования пользователя "free_user@gmail.com"
          Если Я изменил поле "user[name]" на значение "new_nickname"
               И нажал кнопку "Save"
            То Я должен увидеть сообщение "User was successfully updated."

   Сценарий: Удаление пользователя
      Допустим у пользователя "free_user@gmail.com" нет задач
               И перешел на страницу "users"
               И должен увидеть таблицу пользователей:
                 | Login                | Added date       | Tasks | Actions     |
                 | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |
                 | free_user@gmail.com  | 12.12.2009 12:24 | 0/0   | Edit Delete |
          Если Я удаляю пользователя "free_user@gmail.com"
            То Я должен увидеть таблицу пользователей:
                 | Login                | Added date       | Tasks | Actions     |
                 | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |

   Сценарий: Удаление пользователя у которого есть задачи
      Допустим Я перешел на страницу "users"
               И должен увидеть таблицу пользователей:
                 | Login                | Added date       | Tasks | Actions     |
                 | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |
                 | free_user@gmail.com  | 12.12.2009 12:24 | 9/2   | Edit Delete |
               И у пользователя "free_user@gmail.com" есть список задач
          Если Я удаляю пользователя "free_user@gmail.com"
            То Я должен увидеть следующий список пользователей:
                 | admin      | admin      | admin@gmail.com      |
                 | other_user | other_user | other_user@gmail.com |
               И должен увидеть пользователя "free_user" в удаленных пользователях
               И должен увидеть что активные задачи пользователя приостановлены


