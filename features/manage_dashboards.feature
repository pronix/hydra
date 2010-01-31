# language: ru
 Функционал: Dashboard
   Для работы с сервисом 
   Как пользователь
   Я должен перейти на главную страницу сайта (Dashboard)

   Сценарий: Авторизованный пользователь заходит на главную страницу сайта(dasboard)
     Допустим Я авторизован
         Если Я перешел на страницу "dashboard"
           То Я должен увидеть ссылку на "Tasks"
              И должен увидеть ссылку на "Tools"
              И должен увидеть ссылку на "Files"
              И должен увидеть ссылку на "Profiles"
              И должен увидеть ссылку на "Categories"        
              И должен увидеть ссылку на "Settings"
              И должен увидеть ссылку на "Proxy settings"     
              И должен увидеть таблицу с активными заданиями:
              | task 1 | state 1 |
              | task 2 | state 2 |
              | Name   | State   |
              | task 3 | state 1 |
           


   Сценарий: Не авторизованный пользователь заходит на главную страницу сайта(dashboard)
     Допустим Я не авторизован
         Если Я перешел на страницу "dashboard"
           То Я должен перейти на "страницу авторизации"


