# language: ru
 Функционал: Главная страница сервиса (Dashboard)
   Работы с сервисом 
   Пользователь
   Должен перейти на главную страницу сайта (Dashboard)

   Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
             | nickname   | password | login      | email                | admin |
             | admin      | secret   | admin      | admin_user@gmail.com | true  |
             | free_user  | secret   | free_user  | free_user@gmail.com  | false |
             | other_user | secret   | other_user | other_user@gmail.com | false |
      И у пользователь "free_user" есть задачи "task1", "task2"
      И у пользователь "other_user" есть задачи "task3", "task4"


   Сценарий: Авторизованный пользователь заходит на главную страницу сайта(dashboard)
     Допустим Я вошел в сервис как "free_user"
         Если Я перешел на страницу "dashboard"
           То Я должен увидеть главное меню
              И должен увидеть панель пользователя
              И должен увидеть ссылку "Create task"
              И должен увидеть таблицу со своими активными заданиями:
              | Alpha    | task1 | Finished         |
              | Category | Name  | Status           |
              | Delta    | task2 | Extracting files |
              И должен увидеть фильтр "Category"

   Сценарий: Администратор заходит на главную страницу сайта(dashboard)
     Допустим Я вошел в сервис как "admin"
         Если Я перешел на страницу "dashboard"
           То Я должен увидеть главное меню
              И должен увидеть панель пользователя
              И должен увидеть ссылку "Create task"
              И должен увидеть таблицу со всеми активными заданиями:
              | Category | Name  | Status           |
              | Alpha    | task1 | Finished         |
              | Delta    | task2 | Extracting files |
              | Zeta     | task3 | Downloading      |
              | Gamma    | task4 | Finished         |
              И должен увидеть фильтр "Category"

   Сценарий: Не авторизованный пользователь заходит на главную страницу сайта(dashboard)
     Допустим Я не авторизован
         Если Я перешел на страницу "dashboard"
           То Я должен перейти на "страницу входа"
              И увидеть сообщение "Доступ только зарегистрированным пользователям"


