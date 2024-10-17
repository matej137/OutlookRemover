@echo off
:check_Permissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
        echo Failure: You need to run this as Admin!!!
		pause
		goto koniec
    )

mkdir %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==AMD64 copy AppxManifest.xml %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==x86 copy AppxManifestx86.xml %appdata%\NewOutlook\AppxManifest.xml
if %PROCESSOR_ARCHITECTURE%==ARM64 copy AppxManifest-ARM64.xml %appdata%\NewOutlook\AppxManifest.xml
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >NUL 2>NUL
echo Uninstalling the original version (reffer to readme for errors/red text)
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"
echo installing the patched one (Errors are bad now)
powershell add-appxpackage -register "%appdata%\NewOutlook\AppxManifest.xml"
echo Done!

:koniec