@echo off

::Cookie
@echo Unreal build script by Obiwan Medeiros.
echo:

:: Check if the Data text file exists
if not exist .data (
    @echo Data file not found. Plase run Setup.bat first.
	echo:
    pause
    exit /b
)

setlocal EnableDelayedExpansion

:: Load the values of ENGINE_INSTALL_PATH and BUILDBATPATH from the temporary text file
for /f "tokens=1* delims==" %%A in (.data) do (
    if "%%A"=="ENGINEDIR" (
        set "ENGINEDIR=%%B"
    ) else if "%%A"=="BUILDBATPATH" (
        set "BUILDBATPATH=%%B"
    ) else if "%%A"=="PROJECTNAME" (
        set "PROJECTNAME=%%B"
    ) else if "%%A"=="UPROJECTPATH" (
        set "UPROJECTPATH=%%B"
    )
)

if exist %BUILDBATPATH% (
	call %BUILDBATPATH% %PROJECTNAME%Editor Win64 Development %UPROJECTPATH% -waitmutex -NoHotReload
	echo:
	::Finalization
	if errorlevel 0 (
		@echo Build successful, exiting...
		TIMEOUT /T 10
		exit
	) else (
		@echo Build failed.
		Pause
		exit
	)
) else (
	@echo Build bat file found, aborting... 
	Pause
	exit
)