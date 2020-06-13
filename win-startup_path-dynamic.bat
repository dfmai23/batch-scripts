
@echo off
REM windows app launch script
REM steam
REM discord
REM firefox
REM windows media player

@echo on
cd C:\

for /f "delims=" %%A in ('where /R "%ProgramFiles%" firefox.exe') do set varA=%%A

for /f "delims=" %%A in ('where /R "%ProgramFiles(x86)%" steam.exe') do set varB=%%A

for /f "delims=" %%A in ('where /R "%ProgramFiles(x86)%" wmplayer.exe') do set varC=%%A

REM for /f "delims=" %%A in ('where /R "%USERPROFILE%\AppData" discord.exe') do set varD=%%A

start cmd /c "%varA%"
start cmd /c "%varB%"
start cmd /c "%varC%"
REM start cmd /c "%varD%"

D:
for /f "delims=" %%A in ('where /R "D:\Program Files" qbittorrent.exe') do set var=%%A
start cmd /c "%var%"