@echo off & cls & @echo. & @echo.

set "PATHS=C:\Program Files\7-Zip; C:\Program Files (x86)\7-Zip"

set "EXCLUDE1=ipch; .vs; *VC.db; *.VC.opendb; *.sdf; .svn; .git" 
set "EXCLUDE2=_backup; _build; _products; _cache; _stash" 
set "EXCLUDE3=external; boost; googletest" 
set "EXCLUDE=%EXCLUDE1%; %EXCLUDE2%; %EXCLUDE3%" 

rem              srcDirecotry    dstDirectory    excludeList    name
call :backupData  "%~dp0"       "%~dp0_backup"   "%EXCLUDE%"     ""
exit /b 

rem =========================================================================
rem =========================================================================

:dateTime
    rem %~1 variable name 

    setlocal
    for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do (
        set "DTS=%%~a"  
    )

    if errorlevel 1 (
        @echo [ERROR] 'WMIC' finished with error 
        exit /b 1
    )

    set "YY=%DTS:~0,4%"
    set "MM=%DTS:~4,2%"
    set "DD=%DTS:~6,2%"

    set "HH=%DTS:~8,2%"
    set "MIN=%DTS:~10,2%"
    set "SS=%DTS:~12,2%"
    rem set "MS=%DTS:~15,3%"

    set "curDate=%YY%y-%MM%m-%DD%d"
    set "curTime=%HH%h-%MIN%min"
    set "curDateTime=%curDate%_%curTime%"

    endlocal & set "%~1=%curDateTime%"
exit /b 

rem =========================================================================
rem =========================================================================

:backupData
    setlocal
    set "srcDirectory=%~1"
    set "dstDirectory=%~2"
    set "excludeMasks=%~3"
    set "nameArchive=%~4"

    call :find7z
    if errorlevel 1 endlocal & exit /b 1

    call :dateTime timestamp
    if errorlevel 1 endlocal & exit /b 1

    call :normalizePath srcDirectory "%srcDirectory%"
    call :normalizePath dstDirectory "%dstDirectory%"

    call :makeExcludeList

    if not defined nameArchive (
        for %%a in ("%srcDirectory%\.") do (
            set "nameArchive=%%~na%%~xa"
        )
    )

    set "archive=%nameArchive%-%timestamp%.7z"

    @echo.
    @echo [DST-DIR] %dstDirectory%
    @echo [SRC-DIR] %srcDirectory%
    @echo [ARCHIVE] %archive%

    7z.exe a -y -t7z -ssw -mx9      ^
      "-mmt=%NUMBER_OF_PROCESSORS%" ^
      %excludeList%                 ^
      "%dstDirectory%\%archive%"    ^
      "%srcDirectory%" 

    endlocal
exit /b 

rem =========================================================================
rem =========================================================================

:makeExcludeList
    set "excludeList="
:loopMakeExcludeList
    for /f "tokens=1* delims=; " %%g in ("%excludeMasks%") do (
        set "excludeMasks=%%~h"
        set "excludeList=%excludeList% -xr!%%g"
    )
    if defined excludeMasks goto :loopMakeExcludeList
exit /b

rem =========================================================================
rem =========================================================================

:find7z
    set "PATH=%PATHS%;%PATH%"
    where 7z.exe >nul 2>nul
    if errorlevel 1 (@echo [ERROR] 7z.exe not found)
exit /b

rem =========================================================================
rem =========================================================================

:normalizePath
    call :normalizePathImpl "%~1" "?:\%~2\."
exit /b

:normalizePathImpl
    setlocal
    set "RETVAL=%~f2"
    endlocal & set "%~1=%RETVAL:?:\=%" 
exit /b

rem =========================================================================
rem =========================================================================
