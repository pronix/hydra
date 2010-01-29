# language: ru
 Функционал: Управление задачами - Tasks
   Для работы с задачами 
   Как пользователь
   Я должен создавать и управлять задачами

   Сценарий: Список задач
     Допустим Я авторизован
              И у меня нет задач
         Если Я перешел на страницу задач
           То Я должен увидеть пустую таблицу активных задач:
              | Name | Category | description |
              И должен увидеть пустую таблицу завершенных задач:
              | Name | Category | description |

   Сценарий: Создание новой задача с всеми верными  параметрами
     Допустим Я на страницу "задач"
              И у меня нет задач
         Если Я нажал ссылку "Новая задача"
              И заполнил поле "Name" значение "Donwload all internet"
              И выбрал категорию задачи
              И заполнил описание задачи
              И заполнил ссылку на скачиваемый файл
              И заполнил пароль к скачиваемому файлу
              И выбрал макрос для превью                             
              И выбрал один файл для обложки
              И включил флажок "Добавление скринлиста в архив "
              И включел флажок "Добавление обложек в архив"
              И включил флажок "Добавление файлов в архив"
              И выбрал профайл для заливки файлов
              И выключил флажок "Использовать прокси"
              # job_list
              И включен флажок "download"
              И включил флажок "извлечение файлов из архива"
              И включил флажок "Переименовывать файлы"
              И выбрал переключатель "rename arhive"
              И заполнил имя архива
              И заполнил текст
              И заполнил макрос              
              И включил флажок "Создание картинки"
              И выбрал макрос для превью              
              И включил флажок "Загрузка картинок"
              И выбрал тип "image хостинга"
              И выбрал тип получение ссылок на картинки
              И включил флажок "Упаковка файла в архив"
              И заполнил размер архива
              И заполнил имя пароля для архива 
              И включил флажок "Загрузка файлов и получение ссылок"
           То Я должен увидеть "Создана новая задача."            
              И теперь у меня должно быть одна активная задача

   Сценарий: Удаление задачи
     Допустим У меня есть слудующие задачи:
              | name   | category  | description |
              | task 1 | category1 | desc 1      |
              | task 2 | category2 | desc 2      |
              | task 3 | category3 | desc 3      |
              | task 4 | category4 | desc 4      |
       Если Я удаляю 3 задачу
       То я должен увидеть оставшиеся задачи:
              | name   | category  | description |
              | task 1 | category1 | desc 1      |
              | task 2 | category2 | desc 2      |
              | task 4 | category4 | desc 4      |

