
Управляющие переменные
----------------------

## Свойства Цели сборки

|     переменная         |                        значение                                 |
|:----------------------:|:---------------------------------------------------------------:|
| PATH_TO_SOURCES        | Путь к каталогу цели сборки                                     |
| SPECIALIZATION         | Специализация цели (UNIT_TEST|EXAMPLE)                          |
| LANGUAGE               | Язык программирования (CXX или C)                               |
| SHORT                  | Тип цели (test/bin|exe|lib|dll|hpp, so)                         |
| NAME                   | Имя цели                                                        |
| TYPE                   | Тип цели (EXECUTABLE|STATIC_LIBRARY|SHARED_LIBRARY|HEADER_ONLY) |
| INCLUDES               | Список путей, где искать хедеры                                 |
| SOURCES                | Список .cpp, которые вошли в сборку                             |
| HEADERS                | Список .hpp, которые вошли в сборку                             |
| RESOURCES              | Список каталогов, которые нужно скопировать к бинарнику         |
| PREPROCESSOR           | Список дефайнов препроцессора                                   |
| DEPENDENCIES           | Список целей от которых зависит данная                          |
| PATHS_LIBRARIES        | Список путей к каталогам внешних библиотек                      |
| NAMES_LIBRARIES        | Список имён внешних библиотек                                   |
| ADD_HEADERS            | Список путей, откуда нужно подтянуть хэдера                     |
| ADD_SOURCES            | Список путей, откуда нужно подтянуть исходники                  |





## Переменные окружения

|     переменная         |                        значение                     |
|:----------------------:|:---------------------------------------------------:|
| gENVIRONMENT_VARIABLES | Список используемых переменных окружения            |
| gDIR_WORKSPACE         | Путь к WorkSpace                                    |
| gDIRS_EXTERNALS        | Список путей к external                             |
| gDIR_SOURCE            | Путь к каталогу с исходниками                       |
| gNAME_PROJECT          | Имя проекта                                         |
| gDIR_BUILD             | Каталог, где осуществляется сборка                  |
| gDIR_PRODUCT           | Каталог, где нужно разместить продукты сборки       |
| gVERSION               | Версия движка (нафига???)                           |
| gSUFFIX                | Суффик путей                                        |
| gCOMPILER_TAG          | Компилятор                                          |
| gBUILD_TYPE            | Тип сборки (debug/release)                          |
| gADDRESS_MODEL         | Битность: 32 или 64                                 |
| gRUNTIME_CPP           | Линковка с рантаймом с++ (dynamic/static)           |
| gDEFINES               | Дефайны препроцессора                               |


## Глобальные Переменные

|     переменная         |                        значение                     |
|:----------------------:|:---------------------------------------------------:|
| gDEBUG                 | Включить детальный вывод логов                      |
| gDIR_CMAKE_SCENARIO    | Путь к каталогу с сценарием сборки                  |


gMINIMALIST_VERSION_MAJOR
gMINIMALIST_VERSION_MINOR
gMINIMALIST_VERSION_PATCH


gSTABLE_RELEASE
gVIEW_COMPILER_KEYS