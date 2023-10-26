@echo off

::Cookie
@echo Unreal script setup by Obiwan Medeiros.
echo:

::Variable declarations
set "ROOTPATH="
set "UPROJECTPATH="
set "PROJECTNAME="
set "ENGINEVERSION="
set "ENGINEDIR="
set "BUILDBATPATH="

:: Get root directory
for %%I in ("%~dp0..") do set "ROOTPATH=%%~fI"
@echo Project root directory: %ROOTPATH%
echo:

:: Find UProject file
for /r "%ROOTPATH%" %%i in (*.uproject) do set "UPROJECTPATH=%%i"

:: Remove path and extension from PROJECTPATH
if defined UPROJECTPATH (
    @echo UProject directory: %UPROJECTPATH%
    echo:
    setlocal EnableDelayedExpansion
    for %%A in (!UPROJECTPATH!) do endlocal & set "PROJECTNAME=%%~nA"
) else (
    @echo No UProject file found in %ROOTPATH%, aborting...
    Pause
    exit
)
@echo Project name: %PROJECTNAME%
echo:

:: Get Engine version from uproject file
for /f "usebackq tokens=*" %%A in ("%UPROJECTPATH%") do (
    @echo %%A|find "EngineAssociation" >nul
    if not errorlevel 1 (set "ENGINELINE=%%A" && goto FoundEngineLine)
)

:FoundEngineLine

if defined ENGINELINE (
    setlocal EnableDelayedExpansion
    set "ENGINEVERSION=%ENGINELINE:* =%"
    set "ENGINEVERSION=!ENGINEVERSION:~1,-2!"
    for /f "delims=" %%B in ("!ENGINEVERSION!") do endlocal & set "ENGINEVERSION=%%B"
) else (
    @echo Engine version not found, aborting...
    Pause
    exit
)

@echo Engine version: %ENGINEVERSION%
echo:

:: Get the Engine directory from the registry key
set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\EpicGames\Unreal Engine\%ENGINEVERSION%"
set VALUE_NAME=InstalledDirectory
for /f "usebackq skip=2 tokens=1-4" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO set ENGINEDIR=%%C %%D

if defined ENGINEDIR (
    set "ENGINEDIR=%ENGINEDIR:~0,-1%"
    echo Binary engine installation found at: %ENGINEDIR%
    echo:
) else (
    setlocal EnableDelayedExpansion
    ::Attempt to locate engine from user input path
    echo Source engine installation not found. Please enter the engine installation path, example D:\UnrealEngine:
    set /p "ENGINEINSTALLPATHINPUT="
    set "ENGINEDIR=!ENGINEINSTALLPATHINPUT!"
    set "BUILDBATPATH=!ENGINEDIR!\Engine\Build\BatchFiles\Build.bat"
)

echo:

if exist %BUILDBATPATH% (
    @echo Engine installation found at %ENGINEDIR%
    echo:
    @echo Build batch file found at %BUILDBATPATH%
    echo:

    :: Export the values of ENGINE_INSTALL_PATH and BUILDBATPATH to a temporary text file
    echo ROOTPATH=%ROOTPATH%>.data
    echo UPROJECTPATH=%UPROJECTPATH%>>.data
    echo PROJECTNAME=%PROJECTNAME%>>.data
    echo ENGINEDIR=%ENGINEDIR%>>.data
    echo ENGINEVERSION=%ENGINEVERSION%>>.data
    echo BUILDBATPATH=%BUILDBATPATH%>>.data

    echo Setup successful.
    TIMEOUT /T 10
    exit
) else (
    @echo Engine installation not found at "%ENGINEDIR%", aborting...
    Pause
    exit
)