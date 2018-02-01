@ echo off
color 0C
title Verge (XVG) QT Wallet v4.0.1.0-794660a Installer

REM Created by @lloydwoods
cls

echo ****Installing VergeQT Wallet v4.0.1.0-794660a - Welcome to the XVG Family!!!****
TIMEOUT /T 5 /NOBREAK
cls

REM Testing to see if port 9089 is open using Netstat
echo Testing to see if port 9089 is in use on your PC, which is required for VergeQT Wallet to function...
TIMEOUT /T 5 /NOBREAK
netstat -an | find "9089" > porttest.txt
FINDSTR /R "LISTENING" porttest.txt
If %ERRORLEVEL% EQU 0 ECHO ****Something on your PC is using port 9089, VergeQT Wallet will not function if this is the case and will return a "Cannot find onion hostname" error, we will continue installing however****
If %ERRORLEVEL% EQU 1 ECHO ****Port 9089 is not in use on this PC, continuing with installation****
pause
cls

:index
echo Do you want to install VergeQT Wallet to the default location of c:\vergeqt?
set /p choice="yes or no? "
if '%choice%'=='yes' goto :choice1
if '%choice%'=='y' goto :choice1
if '%choice%'=='no' goto :choice2
if '%choice%'=='n' goto :choice2
goto :index

:choice1
set installpath=c:\vergeqt\
echo VergeQT Wallet will be installed to c:\vergeqt
cls

REM Copies files to installed directory
xcopy "*.*" "%installpath%" /y /c /h /e /d

REM This section makes a desktop shortcut
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\Verge Wallet.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%installpath%\VERGE-qt.exe" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
REM End desktop shortcut section

goto :end

:choice2
set altpath=
set /P altpath=Please enter the path where you would like VergeQT Wallet installed (eg d:\myvergewallet\) %=%
echo VergeQT Wallet will be installed to %altpath%

REM Copies files to installed directory
xcopy "*.*" "%altpath%" /y /c /h /e /d

REM This section makes a desktop shortcut
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\Verge Wallet.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%altpath%\VERGE-qt.exe" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
REM End desktop shortcut section

goto :end

:end
echo ****Congradulations, VergeQT Wallet is now installed on your computer and a shortcut has been placed on the desktop.****
cls

:index
echo Would you like to download the Verge blockchain now? (this speeds up wallet syncing drastically, but this step does take some time)
set /p choice="yes or no? "
if '%choice%'=='yes' goto :choice1
if '%choice%'=='y' goto :choice1
if '%choice%'=='no' goto :choice2
if '%choice%'=='n' goto :choice2

:choice1

REM Download Verge Blockchain Section
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo ****Downloading Verge Blockchain data****
echo ****PLEASE BE PATIENT - THE BLOCKCHAIN DATA DOWNLOAD LARGE AND THE DOWNLOAD MAY TAKE SOME TIME DEPENDING ON YOUR INTERNET SPEEDS****
md %TEMP%\verge
REM powershell -Command "(New-Object Net.WebClient).DownloadFile('https://s1.verge-blockchain.com/Wallet_v4.x_Verge-Blockchain_2018-January-29.zip', '%TEMP%\verge\XVGBlockChain.zip')"
powershell -Command "Invoke-WebRequest https://s1.verge-blockchain.com/Wallet_v4.x_Verge-Blockchain_2018-January-29.zip -OutFile %TEMP%\verge\XVGBlockChain.zip"
cls
echo ****Download complete!  Unzipping and copying the Blockchain Data****
powershell -Command "expand-archive -literalpath %TEMP%\verge\XVGBlockChain.zip -destinationpath %TEMP%\verge\blockchain"
xcopy %TEMP%\verge\blockchain\*.* %userprofile%\AppData\Roaming\VERGE\ /e /c /d /y
cls
echo ****Congradulations, VergeQT Wallet v4.0.1.0-794660a has been installed, and the blockchain has been downloaded and put in place as well.
echo ****Press any key to exit the installer and begin using the Verge QT Wallet using the icon on the desktop****
echo.
echo ****We will clean up our temp files next, so you will see a few files being deleted****
pause
goto :end

:choice2
cls
echo ****Congradulations, VergeQT Wallet v4.0.1.0-794660a is installed, but the blockchain data has not been downloaded****
pause
goto :end

:end
REM Cleanup our temp files
del /F /Q /S %TEMP%\verge\*.*
echo Have a nice day!
exit


pause


