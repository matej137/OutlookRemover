@echo off
:check_Permissions
::# self elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)

mkdir %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==AMD64 copy "%~dp0AppxManifest.xml" %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==x86 copy "%~dp0AppxManifestx86.xml" %appdata%\NewOutlook\AppxManifest.xml
if %PROCESSOR_ARCHITECTURE%==ARM64 copy "%~dp0AppxManifest-ARM64.xml" %appdata%\NewOutlook\AppxManifest.xml
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >NUL 2>NUL
echo Uninstalling the original version (reffer to readme for errors/red text)
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"
echo installing the patched one (Errors are bad now)
powershell add-appxpackage -register "%appdata%\NewOutlook\AppxManifest.xml"
echo Done!
echo .
echo Press any key to close this window
pause