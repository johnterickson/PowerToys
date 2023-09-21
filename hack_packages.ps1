
# This version of the package has two fixes:
# 1. In WindowsAppSDK-Nuget-Native.C.props, the "xcopy.exe /y" is now "xcopy.exe /y /d".
# 2. There are two copies of the ARM64 Microsoft.WindowsAppRuntime.Bootstrap.dll. 
#    One is runtimes\win10-arm64\native\Microsoft.WindowsAppRuntime.Bootstrap.dll.
#    The other is inside tools\MSIX\win10-arm64\Microsoft.WindowsAppRuntime.1.4.msix.
#    They are bit-for-bit-identical BUT they have different timestamps.  This causes
#    msbuild to get in an battle where to two copies are overwriting each other because
#    msbuild uses timestamps to determine if they are different.  I replaced the loose
#    file with the one from the MSIX.

$ErrorActionPreference = "Stop"

Copy-Item -Force -Path .\packages\Microsoft.WindowsAppSDK.1.4.230913002\tools\MSIX\win10-arm64\Microsoft.WindowsAppRuntime.1.4.msix -Destination $env:TEMP\Microsoft.WindowsAppRuntime.1.4.msix.zip
Expand-Archive -Force -Path $env:TEMP\Microsoft.WindowsAppRuntime.1.4.msix.zip -DestinationPath  $env:TEMP\Microsoft.WindowsAppRuntime
Copy-Item -Force -Path $env:TEMP\Microsoft.WindowsAppRuntime\Microsoft.WindowsAppRuntime.Bootstrap.dll -Destination .\packages\Microsoft.WindowsAppSDK.1.4.230913002\runtimes\win10-arm64\native\Microsoft.WindowsAppRuntime.Bootstrap.dll

(Get-Content .\packages\Microsoft.WindowsAppSDK.1.4.230913002\build\native\WindowsAppSDK-Nuget-Native.C.props) -replace 'xcopy.exe', 'fc /b "$(MSBuildThisFileDirectory)..\..\runtimes\win10-$(_WindowsAppSDKFoundationPlatform)\native\Microsoft.WindowsAppRuntime.Bootstrap.dll" "$(OutDir)\Microsoft.WindowsAppRuntime.Bootstrap.dll" || xcopy.exe' | Out-File .\packages\Microsoft.WindowsAppSDK.1.4.230913002\build\native\WindowsAppSDK-Nuget-Native.C.props
(Get-Content .\packages\Microsoft.WindowsAppSDK.1.4.230913002\buildTransitive\native\WindowsAppSDK-Nuget-Native.C.props) -replace 'xcopy.exe', 'fc /b "$(MSBuildThisFileDirectory)..\..\runtimes\win10-$(_WindowsAppSDKFoundationPlatform)\native\Microsoft.WindowsAppRuntime.Bootstrap.dll" "$(OutDir)\Microsoft.WindowsAppRuntime.Bootstrap.dll" || xcopy.exe' | Out-File .\packages\Microsoft.WindowsAppSDK.1.4.230913002\build\native\WindowsAppSDK-Nuget-Native.C.props
