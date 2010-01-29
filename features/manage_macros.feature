# language: ru
 Функционал: Macros
   Список макросов.
   Как пользователь
   Должен иметь возможность редактирования, удаления макросов.

  Сценарий: Список макроса


  Сценарий: Создание нового макроса
    Допустим Я на странице нового макроса
        Если Я заполнил поле "Name" значением "Small picture" 
             И заполнил поле "Number of farmes" значением "20"
             И заполнил поле "Columns" значением "20"  
             И заполнил поле "Thumb width" значением "20"
             И заполнил поле "Thumb height" значением "20"
             И включил флажок "Thumb frame " значением "1"
             И заполнил поле "Thumb quality" значением "80"      
             И заполнил поле "Frame size" значением "2"    
             И заполнил поле "Frame color" значением "2"  
             И включил флажок "Thumb shadow" значением "1"    
             И заполнил поле "Space between thumbs" значением "2 2 2 2"  
             # Template
             И выбрал значение "Arial" поля "Font" 
             И заполнил поле "Font size" значением "24"  
             И заполнил поле "Font color" значением "#DDEEFF"  
             И заполнил поле "Template background" значением "#FFFFFF"  
             И заполнил поле "Header text" значением "TEST FILE"
             И включил флажок "Add timestamp" значением "1"    
             И выбрал значение "Left" поля "Position timestamp" 
             И включил флажок "Add logo" значением "1"    
             И выбрал значение "Main logo" поля "Logo" 
             И выбрал значение "png" поля "Screen list file format" 
             И нажал кнопку "Создать"
          То Я должен увидеть сообщение "Создан новый макрос"
          # написать что должен видель пользователь после создание
          # форму редактирования или список макросо

      

  Сценарий: Удаление макроса
    Допустим у меня есть следующие макросы:
             | macros 1 |
             | name     |
             | macros 2 |
             | macros 3 |
             | macros 4 |
        Если Я удаляю третий макрос
        То я должен увидеть слудующие макросы:
             | name     |
             | macros 1 |
             | macros 2 |
             | macros 4 |

