@echo off

:: Cookie
@echo Unreal clean script by Obiwan Medeiros.
@echo This will delete everything inside the .vs, Binaries, Intermediate and Saved folders for the project and plugins.
@echo If you want some file to not be deleted, like some pdb or dll, replace "file1.txt" in line 39 with that file(s) name(s).
echo:

:: Define the project root directory based on the batch file's location
set "PROJECTPATH=%~dp0.."

:: Change the current directory to the project root
pushd "%PROJECTPATH%" 2>nul || (echo ERROR: Failed to change the current directory to: "%PROJECTPATH%" & exit /B 1)

:: Remove unnecessary files and directories
if exist "%PROJECTPATH%\Binaries" rmdir /s /q "%PROJECTPATH%\Binaries"
if exist "%PROJECTPATH%\Intermediate" rmdir /s /q "%PROJECTPATH%\Intermediate"
if exist "%PROJECTPATH%\Saved" rmdir /s /q "%PROJECTPATH%\Saved"
if exist "%PROJECTPATH%\DerivedDataCache" rmdir /s /q "%PROJECTPATH%\DerivedDataCache"
if exist "%PROJECTPATH%\Build" rmdir /s /q "%PROJECTPATH%\Build"
if exist "%PROJECTPATH%\.vs" rmdir /s /q "%PROJECTPATH%\.vs"

del "%PROJECTPATH%\*.opensdf" /Q
del "%PROJECTPATH%\*.sdf" /Q
del "%PROJECTPATH%\*.sln" /Q
del "%PROJECTPATH%\*.suo" /Q

:: Clean Plugins
if exist "%PROJECTPATH%\Plugins" (
    
    setlocal EnableDelayedExpansion

    :: Set the specified files to be hidden
    for /f %%G in ('dir /s /b "%PROJECTPATH%\Plugins\*"') do (
        :: Get the folder name without the path
        set "FILENAME=%%~nxG"

        :: Add here, separated by space, all the files you don't want to be deleted (ex: "val1.file" "val2.file" "val3.file" "val4.file" "val5.file")
        for %%A in ("file1.txt") do (
            if "!FILENAME!"=="%%~A" (
                %SystemRoot%\System32\attrib.exe +H "%%G" /S
            )
        )
    )
    
    :: Delete all files in 'Binaries' and 'Intermediate'
    for /f %%G in ('dir /s /b "%PROJECTPATH%\Plugins\*"') do (
        :: Get the folder name without the path
        set "FILENAME=%%~nxG"

        if "!FILENAME!"=="Intermediate" (
            :: Delete all files in 'Intermediate' but the hidden ones
            del "%%G" /F /Q /S
        ) else if "!FILENAME!"=="Binaries" (
            :: Delete all files in 'Binaries' but the hidden ones
            del "%%G" /F /Q /S
        )
    )

    :: Set all hidden files within 'Binaries', 'Intermediate', and 'ThirdParty' to be visible
    for /f %%G in ('dir /s /b "%PROJECTPATH%\Plugins\*"') do (
        :: Get the folder name without the path
        set "FILENAME=%%~nxG"

        if "!FILENAME!"=="Intermediate" (
            %SystemRoot%\System32\attrib.exe -H "%%G\*" /S
        ) else if "!FILENAME!"=="Binaries" (
            %SystemRoot%\System32\attrib.exe -H "%%G\*" /S
        ) else if "!FILENAME!"=="ThirdParty" (
            %SystemRoot%\System32\attrib.exe -H "%%G\*" /S
        )
    )

    endlocal
)

popd
echo:
echo Clean successful. Exiting...
TIMEOUT /T 10
exit