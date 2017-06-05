@echo off

:loop
tasklist /FI "IMAGENAME eq WerFault.exe" 2>NUL | find /I /N "WerFault.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Detected WerFault.exe, Cemu must have crashed.
    rem Kill WerFault.exe
    echo Restarting Cemu with BOTW
)
TIMEOUT 5
goto :loop