
[![logo](docs/minimalist25.png)](docs/home.md "home") 

Minimalist - Универсальный сценарий сборки на языке cmake.  
проект разрабатывается под заказ [WorkSpace](https://github.com/Kartonagnick/workspace)  

Идея в том, что бы не писать сценарий сборки каждый раз заново.  
Вместо этого лучше переиспользовать один и тот же универсальный сценарий.  

Универсальность сценария достигается за счет автоматики,
которая, опираясь на ряд несложных правил, 
способна удовлетворить большнство потребностей.  

На сегодняшний день Minimalist умеет:  
  - Aвтоматически определять тип целей сборки:
    - `EXECUTABLE`|`STATIC_LIBRARY`|`SHARED_LIBRARY`|`HEADER_ONLY`|`UNIT_TEST`
  - Aвтоматически определять списки исходников и хэдеров.  
  - Aвтоматически определять списки путей, для поиска include.  
  - Aвтоматически подключать предварительно скомпилированный заголовок.  
  - Aвтоматически копировать ресурсы в каталог к бинарнику.  
  - Aвтоматически определять какие проекты являютс¤ юнит-тестами.
  - Aвтоматически подключать gtest/gmock к проектам юнит-тестов.  
  - Aвтоматически подключать def файл.  
  - Aвтоматически подключать rc файл.  

Так же, есть возможность указать различные настройки вручную.  

Содержание  
----------

1) [Философия](docs/public/000-philosophy.md)  
2) [Как начать](docs/public/001-get_started.md)  

3) [История](docs/history.md)  
