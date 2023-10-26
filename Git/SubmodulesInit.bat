@echo off

::Cookie
@echo Unreal Git submodules initialization script by Obiwan Medeiros.
echo:

:: Get root directory
for %%I in ("%~dp0..\..") do set "ROOTPATH=%%~fI"

:: Change the current directory to the project root
pushd "%ROOTPATH%" 2>nul || (echo ERROR: Failed to change the current directory to:& echo "%ROOTPATH%"& exit /B 1)

@echo on
git submodule init
git submodule update --init --recursive
@echo off

popd
@echo:
pause