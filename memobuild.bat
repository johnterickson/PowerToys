set TEMP=%CD:~0,3%\TEMP
set TMP=%TMP%
mkdir %TEMP%
rmdir /S /Q %USERPROFILE%\.nuget\packages\memobuild
git submodule update --init --recursive
git clean -xdf
curl.exe https://dist.nuget.org/win-x86-commandline/v6.7.0/nuget.exe -o tools\nuget.exe
tools\nuget restore packages.config -SolutionDirectory . || exit /b 1
powershell .\hack_packages.ps1
tools\nuget restore .\PowerToys.sln || exit /b 1
IF "%SYSTEM_TEAMFOUNDATIONCOLLECTIONURI%"=="https://dev.azure.com/artifactsandbox0/" (
    for /F %%I in ('az account get-access-token --query accessToken --output tsv') DO (set "SYSTEM_ACCESSTOKEN=%%I")
)
MSBuild.exe /t:restore || exit /b 1
MSBuild.exe /graph /restore:false /nr:false /reportfileaccesses /bl %1 %2 %3 %4 %5 %6 %7 %8 %9