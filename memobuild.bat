set TEMP=%CD:~0,3%TEMP
set TMP=%TEMP%
mkdir %TEMP%

IF "%PLATFORM%"=="" (
    set PLATFORM=x64
)

set MSBUILDDEBUGONSTART_ORIGINAL=%MSBUILDDEBUGONSTART%
set MSBUILDDEBUGONSTART=0
rmdir /S /Q %USERPROFILE%\.nuget\packages\memobuild
git submodule update --init --recursive
git clean -xdf
curl.exe https://dist.nuget.org/win-x86-commandline/v6.7.0/nuget.exe -o tools\nuget.exe
tools\nuget restore packages.config -SolutionDirectory . || exit /b 1
tools\nuget restore .\PowerToys.sln || exit /b 1
IF "%SYSTEM_TEAMFOUNDATIONCOLLECTIONURI%"=="https://dev.azure.com/artifactsandbox0/" (
    for /F %%I in ('az account get-access-token --query accessToken --output tsv') DO (set "SYSTEM_ACCESSTOKEN=%%I")
)
MSBuild.exe /t:restore /p:Platform=%PLATFORM% || exit /b 1
set MSBUILDDEBUGONSTART=%MSBUILDDEBUGONSTART_ORIGINAL%
echo MSBUILDDEBUGONSTART=%MSBUILDDEBUGONSTART%
MSBuild.exe /graph /restore:false /nr:false /reportfileaccesses /bl /p:Platform=%PLATFORM% /p:MemoBuildEnabled=true %*