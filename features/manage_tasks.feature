# language: ru
Функционал: Управление задачами - Tasks
  Для работы с задачами 
  Как пользователь
  Я должен создавать и управлять задачами

=begin
 aria2c - менеджер закачек который будем использовать для скачивания файлов. (http://aria2.sourceforge.net/aria2c.1.html)
          Есть callback начало и окончания загрузки, есть возможность получать статус скачивания по RPC.
           
 Выполнение заданий:
 Список задач - это упрощенно очередь задач, у каждого пользователя свои задачи -  своя очередь.

 Из задач пользователя самая ранняя со статусом new будет передаваться aria для загрузки файлов, 
 остальные задачи этого пользователя будут ждать окончания выполняемой задачи.
 Получаеться что из задач каждого пользователя будет одновременно выполняться только одна задача.
 

=end

  Предыстория:
    Допустим у нас есть следующие пользователи
        | nickname   | password | admin |
        | admin      | secret   | true  |
        | free_user  | secret   | false |
        | other_user | secret   | false |
       И у пользователь "free_user" есть активные задачи:
        | name  | category | status               |
        | task1 | alpha    | Finished             |
        | task2 | zeta     | Finished             |
        | task3 | gamma    | Stopped - error code |
       И у пользователь "free_user" есть завершенные задачи:
        | name  | category | status   |
        | task4 | gamma    | Complete |
        | task5 | alpha    | Complete |
        | task6 | zeta     | Complete |


  Сценарий: Список активных задач
    Допустим Я зашел в сервис как "free_user"
        Если Я перешел на страницу задач "tasks"
          То Я должен увидеть главное меню
             И должен увидеть дополнительное меню "tasks"
             И должен увидеть панель пользователя
             И должен увидеть ссылку "Create task"
             И должен увидеть таблицу активный задач:
               | category | name  | status               | actions |
               | gamma    | task3 | Stopped - error code | delete  |
               | alpha    | task1 | Finished             | delete  |
               | zeta     | task2 | Finished             | delete  |
             И должен увидеть фильтр "Category"

  Сценарий: Удаление активной задачи
    Допустим Я зашел в сервис как "free_user"
             И перешел на страницу задач "tasks"
             И у меня есть следующие активные задачи:
               | category | name  | status               | actions |
               | gamma    | task3 | Stopped - error code | delete  |
               | alpha    | task1 | Finished             | delete  |
               | zeta     | task2 | Finished             | delete  |
       Если Я удаляю 3 задачу
       То я должен увидеть оставшиеся задачи:
               | category | name  | status               | actions |
               | alpha    | task1 | Finished             | delete  |
               | zeta     | task2 | Finished             | delete  |



  Сценарий: Список завершенных задач
    Допустим Я зашел в сервис как "free_user"
        Если Я перешел на страницу задач "completed tasks"
          То Я должен увидеть главное меню
             И должен увидеть дополнительное меню "tasks"
             И должен увидеть панель пользователя
             И должен увидеть ссылку "Create task"
             И должен увидеть таблицу завершенных задач:
               | category | name  | status   | actions |
               | gamma    | task4 | Complete | delete  |
               | alpha    | task5 | Complete | delete  |
               | zeta     | task6 | Complete | delete  |
             И должен увидеть фильтр "Category"

  Сценарий: Удаление завершенной задачи
    Допустим Я зашел в сервис как "free_user"
             И перешел на страницу задач "completed tasks"
             И у меня есть следующие завершенные задачи:
               | category | name  | status   | actions |
               | gamma    | task4 | Complete | delete  |
               | alpha    | task5 | Complete | delete  |
               | zeta     | task6 | Complete | delete  |
       Если Я удаляю 6 задачу
       То я должен увидеть оставшиеся задачи:
               | category | name  | status   | actions |
               | gamma    | task4 | Complete | delete  |
               | alpha    | task5 | Complete | delete  |


  Сценарий: Добаление задач
    Допустим Я зашел в сервис как "free_user"
             И у меня нет задач
             И нахожусь на странице "new task"
        Если Я заполнил поле "Name" значение "Donwload all internet"
             И заполнил поле "Category" значение "alpha" 
             И включил флажок "Use proxy"                
             И заполний поле "Description" значением "Download all internet"
             И заполнил поле "Links" значением "http://login:pwd@domain.com/file.rar, http://www.domain.com/file.rar, ftp://login:pwd@domain.com/file.rar, ftp://domain.com/file.rar"
             И включил флажок "Passwort"
             И заполнил поле "Password" значением "secret"
             # Add files
             И добавил файл обложки "test_cover.png"
             И добавил файл обложки "test_cover1.png"
             И включил флажок  "Add screen list to arhive" 
             И включел флажок "Add covers to arhive"       
             И добавил дополнительный файл "test_attachment.txt"
             И добавил дополнительный файл "test_attachment1.txt"
             # job_list
             И включен флажок "download"
             И включил флажок "Extracting files"
             И включил флажок "Rename"
             И выбрал переключатель "rename arhive"
             И заполнил поле "arhive name" значением "new_file"
             И заполнил поле "text"              
             И заполнил поле "macros" значением "[file_name]"
             И включил флажок "Create screen list"
             И выбрал значение "Macros1" поля "screen_list_macros"
             И включил флажок "Upload images"
             И выбрал значение "imagehosting1" поля "image_hosting"
             И включил флажок "Create arhive"
             И заполнил поле "arhive_size" значением "100"
             И заполнил поле "password_arhive" значением "secret_arhive"
          То Я должен увидеть "Create new task."            
             И теперь у меня должно быть одна активная задача

  Сценарий: Завершение задачи
    Допустим есть список задач:
             | gamma | task3 | Stopped - error code | delete           |
             | alpha | task1 | Finished             | delete, complete |
             | zeta  | task2 | Finished             | delete, complete |
        Если Я нажал ссылку "complete" для "task1"
          То Я должен увидеть сообщение "Task task1 has been completed"
             И должен увидеть следующий список активных задач:
             | gamma | task3 | Stopped - error code | delete           |
             | zeta  | task2 | Finished             | delete, complete |
             И должен увидеть следующий список завершенных задач:
             | alpha | task1 | Complete | delete |
