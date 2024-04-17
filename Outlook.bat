@echo off
:check_Permissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
        echo Failure: You need to run this as Admin!!!
		pause
		goto konec
    )

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==64BIT copy AppxManifest.xml %systemdrive%\users
if %OS%==32BIT copy AppxManifestx86.xml %systemdrive%\users\AppxManifest.xml
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >NUL 2>NUL
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"
powershell add-appxpackage -register "%systemdrive%\users\AppxManifest.xml"

:konec