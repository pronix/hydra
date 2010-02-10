# language: ru
 Функционал: Proxy
   Список пользовательских proxy.
   Пользователь должен иметь возможность редактировать, добавлять и удалять proxy.

   Предыстория:
     Допустим в сервисе зарегистрированы следующие пользователи:
       | nickname  | password | email                | admin |
       | admin     | secret   | admin_user@gmail.com | true  |
       | free_user | secret   | free_user@gmail.com  | false |
       И у пользователя "free_user@gmail.com" есть следующие proxy:
       |        address | country | state   |
       | 24.34.21.5:80  | USA     | Online  |
       | 34.32.21.5:80  | USA     | Offline |
       | 34.34.61.5:80  | USA     | Online  |
       И зашел в сервис как "free_user@gmail.com/secret"

   Сценарий: Список proxy
     Допустим Я перешел на страницу "proxies"
           То Я должен увидеть главное меню
              И должен увидеть панель пользователя
              И должен увидеть ссылку "Add proxy"
              И должен увидеть дополнительное меню Settings для пользователя
              И должен увидеть список proxy:
                |       Address | Country | Status  | Actions |
                | 34.34.61.5:80 | USA     | Online  | Edit    |
                | 34.32.21.5:80 | USA     | Offline | Edit    |
                | 24.34.21.5:80 | USA     | Online  | Edit    |


    Сценарий: Редактирование Proxy
      Допустим Я на странице редактирования proxy для "34.34.61.5:80"
          Если Я изменил поле "proxy[address]" на значение "65.54.32.78:80"
               И нажал кнопку "Save"
            То Я должен увидеть сообщение "Proxy was successfully updated."
               И должен увидеть список proxy:
                |        Address | Country | Status  | Actions |
                | 65.54.32.78:80 | USA     | Online  | Edit    |
                |  34.32.21.5:80 | USA     | Offline | Edit    |
                |  24.34.21.5:80 | USA     | Online  | Edit    |

    Сценарий: Удаление Proxy
      Допустим у меня есть список proxy:
                | 234.34.21.5:80 | en | Online  |
                | 224.34.21.5:80 | en | Online  |
                | 234.32.21.5:80 | ru | Offline |
                | 234.34.61.5:80 | ua | Online  |
         Если Я удаляю proxy "224.34.21.5"
           То Я должен увидеть оставшийся список proxy:
                | 234.34.21.5:80 | en | Online  |
                | 234.32.21.5:80 | ru | Offline |
                | 234.34.61.5:80 | ua | Online  |

    Сценарий: Добавление Proxy
      Допустим Я на странице добавление Proxy
               И у меня пока нет proxy
          Если Я заполнил текстовое поле "proxy" значением "231.77.54.12:80\n 231.27.54.12:80\n 221.27.54.12:80"
               И нажал кноку "Добавить"
            То Я должен увидеть сообщение "Proxy added"
               И должен увидеть список proxy:
                | 231.77.54.12:80 | en | Online  |
                | 231.27.54.12:80 | ru | Offline |
                | 221.27.54.12:80 | ua | Online  |

