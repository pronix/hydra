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


 Последовательность выполнения операций в задаче:
 1 - Создание задачи, заполнение нужных параметров(название, описание, ссылки на файлы, параметры для скрин лист),
     статус - Queued
 2 - Передача задачи на скачивание, статус - DOWNLOADING
 3 - После скачивание, скаченные файлы поподают на распаковку, статус -  EXTRACTING.
       Выполняеться только после завершение скачивания
 4 - После завершения распаковки файлов, запускаеться генерация скрин листов, статус - GENERATION.
       Кол-во картинок(фреймов) на скрин листе будет равно  количеству картинок заданное в макросе умноженное
        на кол-во видео файлов в архиве.(в макросе указано 10, в архиве 3 видео файла = 30 картинок на скрин листе)
       Пользователь может запустить повторно генерацию со статуса FINISHED.
       Таким образом генерация скрин листов доступна после завершения EXTRACTING или на стадии FINISHED.
 5 - После завершения генерации скрин листов, запускаеться переименовывание файлов (если указано в задаче),
       статус - RENAMING. Выполняеться только после завершение генерации скрин листов
 6 - После завершение переименовыание файлов, запускаеться упаковка файлов, статус - PACKING.
       Выполняеться только после переименовывание файлов.
 7 - После завершения переименовыание файлов, запускаеться закачивание картинок|файлов, статус - UPLOADING
        Пользователь может повторий закачку файлов после завершения из состояния задачи: FINISHED или COMPLETED
 8 - После завершения закачивание файлов, задача переходит в статус FINISHED
     И удаляем скаченные файлы с удаленных хостов.
     При статусе FINISHED пользователь при просмотрет задачи видит ссылки на ссылки на сгененрированные скрин листы
     и на файлы, а также кнопку повторной генерации скрин листов и кнопку завершения задачи COMPLETED.
     Также будет видеть кнопку повторой закачки файлов.

 9 - Из статуса FINISHED задача может быть пользователем переведена в состояние COMPLETED
     И удаляем видео файл.
     Пользоватлеь здесь видит  ссылки на ссылки на сгененрированные скрин листы
     и на файлы, а также кнопку повторной генерации скрин листов и кнопку повторой закачки файлов.

10 - При возникновение ошибки, задача из любого состояния переходить в статус ERROR, с указанием ошибки.


=end

  Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
       | nickname  | password | email                | admin |
       | admin     | secret   | admin_user@gmail.com | true  |
       | free_user | secret   | free_user@gmail.com  | false |
       И у пользователя "free_user@gmail.com" есть следующие активные задачи:
        | name  | category | state    | links                                                           | created_at |
        | task1 | alpha    | finished | http://media.railscasts.com/videos/200_rails_3_beta_and_rvm.mov | 01.01.2010 |
        | task2 | zeta     | finished | http://media.railscasts.com/videos/199_mobile_devices.mov       | 11.02.2010 |
       И у пользователя "free_user@gmail.com" есть завершенные задачи:
 | name  | category | state     | links                                                                   | created_at |
 | task3 | gamma    | error     | http://media.railscasts.com/videos/197_nested_model_form_part_2.mov     | 01.01.2010 |
 | task4 | gamma    | completed | http://media.railscasts.com/videos/195_my_favorite_web_apps_in_2009.mov | 01.02.2010 |
 | task5 | alpha    | completed | http://media.railscasts.com/videos/194_mongodb_and_mongomapper.mov      | 02.02.2010 |
 | task6 | zeta     | completed | http://media.railscasts.com/videos/192_authorization_with_cancan.mov    | 02.03.2010 |




  Сценарий: Список активных задач
    Допустим Я зашел в сервис как "free_user@gmail.com/secret"
        Если Я перешел на страницу "active tasks"
          То Я должен увидеть главное меню
             И должен увидеть дополнительное меню Tasks
             И должен увидеть панель пользователя
             И должен увидеть ссылку "Create task"
             И должен увидеть таблицу задач:
               | Category | Name  | Status   | Actions |
               | zeta     | task2 | Finished | Delete  |
               | alpha    | task1 | Finished | Delete  |
             И должен увидеть фильтр Category

  Сценарий: Удаление активной задачи
    Допустим Я зашел в сервис как "free_user@gmail.com/secret"
             И перешел на страницу "active tasks"
             И должен увидеть таблицу задач:
              | Category | Name   | Status      | Actions |
              | zeta     | task2  | Finished    | Delete  |
              | alpha    | task1  | Finished    | Delete  |
       Если Я удаляю задачу "2" с названием "task1"
         То Я должен увидеть таблицу задач:
               | Category | Name  | Status   | Actions |
               | zeta     | task2 | Finished | Delete  |
            И должен удалить скаченные файлы, сгенерированные "scree list"


  Сценарий: Список завершенных задач
    Допустим Я зашел в сервис как "free_user@gmail.com/secret"
        Если Я перешел на страницу "completed tasks"
          То Я должен увидеть главное меню
             И должен увидеть дополнительное меню Tasks
             И должен увидеть панель пользователя
             И должен увидеть ссылку "Create task"
             И должен увидеть таблицу задач:
               | Category | Name  | Status    | Actions |
               | zeta     | task6 | Completed | Delete  |
               | alpha    | task5 | Completed | Delete  |
               | gamma    | task4 | Completed | Delete  |
               | gamma    | task3 | Error     | Delete  |
             И должен увидеть фильтр Category

  Сценарий: Удаление завершенной задачи
    Допустим Я зашел в сервис как "free_user@gmail.com/secret"
             И перешел на страницу "completed tasks"
             И должен увидеть таблицу задач:
              | Category | Name  | Status    | Actions |
              | zeta     | task6 | Completed | Delete  |
              | alpha    | task5 | Completed | Delete  |
              | gamma    | task4 | Completed | Delete  |
              | gamma    | task3 | Error     | Delete  |
       Если Я удаляю задачу "1" с названием "task6"
       То я должен увидеть таблицу задач:
              | Category | Name  | Status    | Actions |
              | alpha    | task5 | Completed | Delete  |
              | gamma    | task4 | Completed | Delete  |
              | gamma    | task3 | Error     | Delete  |

  Сценарий: Добавление задач
    Допустим Я зашел в сервис как "free_user@gmail.com/secret"
             И у меня нет задач
             И в сервисе уже есть следующие категории:
               | name      | created_at |
               | alpha     | 01.01.2010 |
               | gamma     | 11.01.2010 |
               | zeta      | 05.01.2010 |
             И я перешел на страницу "new task"
        Если Я заполнил поле "task[name]" значением "Donwload all internet"
             И выбрал "alpha" из "task[category_id]"
             И включил флажок "task[proxy]"
             И заполнил поле "task[description]" значением "Download all internet"
             И заполнил поле "task[links]" значением
             """
               http://media.railscasts.com/videos/197_nested_model_form_part_2.mov
               http://media.railscasts.com/videos/195_my_favorite_web_apps_in_2009.mov
               http://media.railscasts.com/videos/194_mongodb_and_mongomapper.mov
               http://media.railscasts.com/videos/192_authorization_with_cancan.mov
             """
             И включил флажок "task[use_password]"
             И заполнил поле "task[password]" значением "secret"
             # Add files
             И выбрал в поле "task[covers]" файл "spec/factories/test_files/cover_01.jpg"
             И включил флажок "task[add_screens_to_arhive]"
             И включил флажок "task[add_covers_to_arhive]"
             И выбрал в поле "task[attachment_files]" файл "spec/factories/test_files/attachment_01.jpg"

             И включил флажок "task[extracting_files]"
             И включил флажок "task[rename]"
             И выбрал переключатель "rename arhive"
             И заполнил поле "task[rename_file_name]" значением "new_file"
             И заполнил поле "task[rename_text]" значением "foto_1200"
             И заполнил поле "task[macro_renaming]" значением "[file_name].[text].[ext]"
             И включил флажок "task[screen_list]"
             # И выбрал "macros1" из "task[screen_list_macro_id]"
             И включил флажок "task[upload_images]"
             # И выбрал "imagehostin1" из "task[upload_images_profile_id]"
             И включил флажок "task[mediavalise]"
             # И выбрал "mediavalise1" из "task[mediavalise_profile_id]"
             И включил флажок "task[create_arhive]"
             И заполнил поле "task[part_size]" значением "100"
             И заполнил поле "task[password_arhive]" значением "secret_arhive"
             И нажал кнопку "Create"
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


