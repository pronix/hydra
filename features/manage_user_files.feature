# language: ru
Функционал: Files
  Список пользовательских файлов.
  Как пользователь
  Должен иметь возможность размещать небольшие файлы, которые можно будет добавить в архивы.

  Предыстория:
    Допустим в сервисе зарегистрированы следующие пользователи:
      | nickname  | password | email                | admin |
      | admin     | secret   | admin_user@gmail.com | true  |
      | free_user | secret   | free_user@gmail.com  | false |
      И у пользователя "free_user@gmail.com" есть следующие файлы:
      | name       | created_at       |
      | file1_name | 01.01.2010 12:06 |
      | file2_name | 11.01.2010 02:34 |
      И я зашел в сервис как "free_user@gmail.com/secret"

  Сценарий: Список файлов
    Допустим Я перешел на страницу "user files"
          То Я должен увидеть главное меню
             И должен увидеть панель пользователя
             И должен увидеть дополнительное меню Tools  
             И должен увидеть ссылку "Add file" 
             И должен увидеть список файлов:
             | Name       | Uploaded         | Actions |
             | file1_name | 01.01.2010 12:06 | Edit    |
             | file2_name | 11.01.2010 02:34 | Edit    |




  Сценарий: Загрузка нового файла
    Допустим Я на странице "new file"
             И у меня нет не одного файла 
        Если Я выбрал в поле "attachment_file[file]" файл "spec/factories/test_files/small_text_file.txt"
             И заполнил поле "attachment_file[name]" значением "my_foto"
             И заполнил поле "attachment_file[description]" значением "это моё фото"
             И нажал кнопку "Upload"
          То Я должен увидеть сообщение "File was downloaded."
             И список моих файлов не должен быть пустым 
             
  Сценарий: Удаление файла
    Допустим у пользователя "free_user@gmail.com" есть следующие файлы:
              | name       | created_at       |
              | file1_name | 01.01.2010 12:06 |
              | file2_name | 11.01.2010 02:34 |
             И перешел на страницу "user files"
        Если Я удаляю "2" файл с именем "file1_name"
          То Я должен увидеть список файлов:
                | Name       | Uploaded         | Actions      |
                | file2_name | 11.01.2010 02:34 | edit, delete |
             И должен увидеть сообщение "File was successfully destroyed"
