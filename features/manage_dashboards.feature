# language: ru
Функционал: Главная страница сервиса (Dashboard)
  Работы с сервисом
  Пользователь
  Должен перейти на главную страницу сайта (Dashboard)

  Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
       | nickname   | password | email                | admin |
       | admin      | secret   | admin_user@gmail.com | true  |
       | free_user  | secret   | free_user@gmail.com  | false |
       | other_user | secret   | other_user@gmail.com | false |
       И у пользователя "free_user@gmail.com" есть следующие активные задачи:
        | name  | category | state    | links                                                           | created_at |
        | task1 | alpha    | finished | http://media.railscasts.com/videos/200_rails_3_beta_and_rvm.mov | 01.01.2010 |
        | task2 | zeta     | finished | http://media.railscasts.com/videos/199_mobile_devices.mov       | 11.02.2010 |
       И у пользователя "other_user@gmail.com" есть следующие активные задачи:
 | name  | category | state       | links                                                                   | created_at |
 | task6 | zeta     | downloading | http://media.railscasts.com/videos/192_authorization_with_cancan.mov    | 02.03.2010 |
 | task5 | alpha    | packing     | http://media.railscasts.com/videos/194_mongodb_and_mongomapper.mov      | 02.02.2010 |
 | task4 | gamma    | packing     | http://media.railscasts.com/videos/195_my_favorite_web_apps_in_2009.mov | 01.02.2010 |
 | task3 | gamma    | queued      | http://media.railscasts.com/videos/197_nested_model_form_part_2.mov     | 01.01.2010 |

   Сценарий: Авторизованный пользователь заходит на главную страницу сайта(dashboard)
     Допустим Я зашел в сервис как "other_user@gmail.com/secret"
         Если Я перешел на страницу "dashboard"
           То Я должен увидеть главное меню
              И должен увидеть панель пользователя
              И должен увидеть ссылку "Create task"
              И должен увидеть таблицу задач:
              | Category | Name  | Status      |
              | zeta     | task6 | Downloading |
              | alpha    | task5 | Packing     |
              | gamma    | task4 | Packing     |
              | gamma    | task3 | Queued      |
              И должен увидеть фильтр Category

   Сценарий: Администратор заходит на главную страницу сайта(dashboard)
     Допустим Я зашел в сервис как "admin_user@gmail.com/secret"
         Если Я перешел на страницу "dashboard"
           То Я должен увидеть главное меню
              И должен увидеть панель пользователя
              И должен увидеть ссылку "Create task"
              И должен увидеть таблицу задач:
              | Category | Name  | Status      |
              | zeta     | task6 | Downloading |
              | zeta     | task2 | Finished    |
              | alpha    | task5 | Packing     |
              | gamma    | task4 | Packing     |
              | alpha    | task1 | Finished    |
              | gamma    | task3 | Queued      |
              И должен увидеть фильтр Category


   Сценарий: Не авторизованный пользователь заходит на главную страницу сайта(dashboard)
     Допустим Я не авторизован
         Если Я перешел на страницу "dashboard"
           То Я должен оказаться на страницу "login"
              И должен увидеть сообщение "You must be logged in to access this page"


