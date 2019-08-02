@echo off

break>verapp.log

date /T >> verapp.log
time /T >> verapp.log

:: all_but_first
set ALL_BUT_FIRST=""

:: Parse arguments
for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b

:: For single files			
if %1==-file (
echo Checking files: %ALL_BUT_FIRST% >> verapp.log
echo Checking files: %ALL_BUT_FIRST%
echo. >> verapp.log

vera++ -p comap %ALL_BUT_FIRST% >> verapp.log
vera++ -p comap %ALL_BUT_FIRST%
goto :eof
)
:: For current folder
if %1==-folder (
echo Checking folder: %ALL_BUT_FIRST% >> verapp.log
echo. >> verapp.log
for %%i in (*.c *.cpp *.h *.hpp) do vera++ -p comap "%%~i" >> verapp.log vera++ -p comap "%%~i"
goto :eof
)
:: For current folder including subfolders
if %1==-folderSub (
echo Checking files: %ALL_BUT_FIRST% >> verapp.log
echo Checking files: %ALL_BUT_FIRST%
echo. >> verapp.log

 for /r . %%i in (*.c *.cpp *.h *.hpp) do vera++ -p comap "%%~i" >> verapp.log vera++ -p comap "%%~i"
goto :eof
)
:: For specific folders
if %1==-folderRemote (
echo Checking folders: %ALL_BUT_FIRST% >> verapp.log
echo Checking folders: %ALL_BUT_FIRST%
echo. >> verapp.log

call :parse "%ALL_BUT_FIRST%"
goto :eof
)
::**********************************************************************************************************************
:: Print Help
echo usage: verapp_check -h                                help
            echo        verapp_check -file         "path1 path2 ..."   checks For files
            echo        verapp_check -folder                           checks For current folder
            echo        verapp_check -folderSub                        checks For current folder including subfolders
			echo        verapp_check -folderRemote "path1 path2 ..."   checks For specific folders

goto :eof
::**********************************************************************************************************************

:: function to parse arguments by delimiter " ".
:parse
setlocal
set list=%~1
echo list = %list%
for /F "tokens=1* delims= " %%f in ("%list%") do (
    rem if the item exist
    if not "%%f" == "" call :getLineNumber %%f
    rem if next item exist
    if not "%%g" == "" call :parse "%%g"
)
endlocal
goto :eof

:getLineNumber
setlocal
echo folder name is %1
for /r %1 %%i in (*.c *.cpp *.h *.hpp) do vera++ -p comap "%%~i" >> verapp.log
goto :eof

:eof