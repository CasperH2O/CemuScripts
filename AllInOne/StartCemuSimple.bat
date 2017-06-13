@echo off

REM Define file names and locations using relative paths.
SET "cemu_file_name=Cemu.exe"
SET "cemu_location=..\..\cemu-180b"
SET "game=U-King.rpx"
SET "game_location=..\game\00050000101C9500-120\code" REM Relative to Cemu location!

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

REM Start cemu with specified game and full screen option.
start "" "%cemu_location%\%cemu_file_name%" -g "%game_location%\%game%" -f

REM Check every 5 seconds if Cemu has crashed
REM by checking for the WerFault application.
REM Note that this could cause trouble if a 
REM different application crashes.

:crash_detect_loop

tasklist /FI "IMAGENAME eq WerFault.exe" 2>NUL | find /I /N "WerFault.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Detected WerFault.exe
    REM Small delay to let the user see the Windows
    REM crash report message from WerFault.
    TIMEOUT 3
    REM Force stop the three applications
    taskkill /IM WerFault.exe /f
    taskkill /IM %cemu_file_name% /f
    echo Restarting Cemu with BOTW
    TIMEOUT 1
    goto :start
)

REM Check if Cemu is no longer running, if not, inform user and exit after timeout
tasklist /FI "IMAGENAME eq %cemu_file_name%" 2>NUL | find /I /N "%cemu_file_name%">NUL
if NOT "%ERRORLEVEL%"=="0" (
    echo Cemu no longer running, assumed closed by user.
    echo Closing automatic restart script. Goodbye!
    TIMEOUT 3
    EXIT
)

echo Cemu is still running OK.

TIMEOUT 5

goto :crash_detect_loop