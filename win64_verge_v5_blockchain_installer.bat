@ echo off
color 0C
title Verge (XVG) QT Wallet v5.0 Blockchain Data Downloader & Installer
REM Created by @lloydwoods
cls
REM Download Verge Blockchain Section
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo ****Downloading Verge Blockchain data****
echo ****PLEASE BE PATIENT - THE BLOCKCHAIN DATA DOWNLOAD IS LARGE AND THE DOWNLOAD MAY TAKE SOME TIME DEPENDING ON YOUR INTERNET SPEEDS (avg 20-30 minutes on a 100Mb/s internet connection)****
REM Make directory for Blockchain data download 
md c:\windows\temp\verge
REM Make directory for Blockchain data in Verge operating directory in the instance that QT has never been ran on this machine
md %userprofile%\AppData\Roaming\verge\

REM This line and the line after is included but ignored because it is slow downloading but may be required for Win7
REM powershell -Command "Invoke-WebRequest https://verge-blockchain.com/blockchain5/Codebase_5.0_Verge-Blockchain_2019-April-3.zip -OutFile c:\windows\temp\verge\XVGBlockChain.zip"

REM Command to download the files
powershell Start-BitsTransfer https://verge-blockchain.com/blockchain5/Codebase_5.0_Verge-Blockchain_2019-April-3.zip c:\windows\temp\verge\XVGBlockChain.zip
echo ****Once the download has finished the blue box with yellow text will disappear above and you will see this message, press any key to continue****
pause
cls

REM Cleaning out old block and chainstate folders possibly containing v4 data
echo ****Cleaning out old blockchain data from previous versions of the Verge Windows QT Wallet****
del /F /Q /S %userprofile%\AppData\Roaming\verge\blocks\*.*
del /F /Q /S %userprofile%\AppData\Roaming\verge\chainstate\*.*
cls

REM Unzipping the data to temp and copying it to the working dir
echo ****Unzipping and copying the Blockchain Data****
powershell -Command "expand-archive -literalpath c:\windows\temp\verge\XVGBlockChain.zip -destinationpath c:\windows\temp\verge\blockchain"
xcopy c:\windows\temp\verge\blockchain\*.* %userprofile%\AppData\Roaming\verge\ /e /c /y
cls
echo ****Congratulations, the updated v5.0 blockchain has been downloaded and put in place.
echo ****We will clean up our temp files next, so you will see a few files being deleted from c:\windows\temp\verge\****
pause

REM Cleanup our temp files
del /F /Q /S c:\windows\temp\verge\*.*
echo ****All done, Have a nice day!  Please launch Verge Core now to begin using your v5 Verge wallet****
pause
