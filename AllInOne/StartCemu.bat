@echo off

REM Define file names and locations using relative paths.
SET "cemu_file_name=cemu.exe"
SET "cemu_location=..\..\cemu-180b"
SET "speedhack_file_name=SuperSpeedHack25.EXE"
SET "speedhack_location=..\..\AutoSpeedHackBetterDefaults"
SET "game=U-King.rpx"
SET "game_location=..\game\00050000101C9500-120\code" REM Relative to Cemu location!
SET "backup_location=..\..\Saves-Backup"
SET "seven_zip_location=C:\Program Files\7-Zip\7z.exe"

REM Change to directory of bash file it self, needed when run as admin
pushd %~dp0

REM Check if Cemu is already running, if yes, inform user and exit after timeout
tasklist /FI "IMAGENAME eq %cemu_file_name%" 2>NUL | find /I /N "%cemu_file_name%">NUL
if "%ERRORLEVEL%"=="0" (
    echo Cemu is running, nothing to do.
    TIMEOUT 3
    EXIT
)

:start

REM Make back up before start
REM Get current date and time
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"

set "YY=%dt:~2,2%"
set "YYYY=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%"
set "Min=%dt:~10,2%"
set "Sec=%dt:~12,2%"

set "fullstamp=%YYYY%%MM%%DD%-%HH%%Min%%Sec%"

REM Create 7z file of all Cemu saves at ultra compress level
"%seven_zip_location%" a "%backup_location%\%fullstamp%.7z" "%cemu_location%\mlc01\emulatorSave\*" -mx=9

REM In case 7z returns error (for ex. not installed), simply copy files.
if NOT "%ERRORLEVEL%"=="0" (
    echo 7zip did not work, copying folder instead.
    echo Creating back up folder: %fullstamp%
    md "%backup_location%\%fullstamp%"
    xcopy /E "%cemu_location%\mlc01\emulatorSave" "%backup_location%\%fullstamp%"
)

TIMEOUT 1

REM Start cemu with specified game and full screen option.
start "" "%cemu_location%\%cemu_file_name%" -g "%game_location%\%game%" -f

REM Timeout to handle Super Speed Hack only working once game is loaded.
REM Give Cemu time to start and load cache.
TIMEOUT 25

REM Start speed hack application with precompiled desired values:
REM Target: 24, Min 1 Max 2.
start "" "%speedhack_location%\%speedhack_file_name%"

REM Check every second if the SuperSpeedHack has started, 
REM so the active screen can be set to Cemu.

:focus_window

TIMEOUT 2

tasklist /FI "IMAGENAME eq %speedhack_file_name%" 2>NUL | find /I /N "%speedhack_file_name%">NUL
if "%ERRORLEVEL%"=="0" (
    REM Small time delay to allow the actual GUI to show.
    TIMEOUT 5
    REM Send no key instruction to Cemu screen, activating the window
    call ../ThirdParty/sendKeys.bat "Cemu" ""
    goto:continue
)
goto :focus_window

:continue

REM Check every 5 seconds if Cemu has crashed
REM by checking for the WerFault application.
REM Note that this could cause trouble if a 
REM different application crashes.

:crash_detect_loop

tasklist /FI "IMAGENAME eq WerFault.exe" 2>NUL | find /I /N "WerFault.exe">NUL
if "%ERRORLEVEL%"=="0" (
    call ../ThirdParty/sendKeys.bat "bat" ""
    echo Detected WerFault.exe
    REM Small delay to let the user see the Windows
    REM crash report message from WerFault.
    TIMEOUT 3
    REM Force stop the three applications
    taskkill /IM WerFault.exe /f
    taskkill /IM %cemu_file_name% /f
    taskkill /IM %speedhack_file_name% /f
    echo Restarting Cemu with BOTW
    TIMEOUT 1
    goto :start
)

REM Check if Cemu is no longer running, if not, inform user and exit after timeout
tasklist /FI "IMAGENAME eq %cemu_file_name%" 2>NUL | find /I /N "%cemu_file_name%">NUL
if NOT "%ERRORLEVEL%"=="0" (
    echo Cemu no longer running, assumed closed by user.
    TIMEOUT 3
    taskkill /IM %speedhack_file_name% /f
    EXIT
)

echo Cemu is still running OK.

TIMEOUT 5

goto :crash_detect_loop