
@echo off
REM windows app launch script
REM steam
REM discord
REM firefox
REM windows media player

@echo on
cd C:\

for /f "delims=" %%A in ('where /R "%ProgramFiles%" firefox.exe') do set var=%%A
cmd /c "%var%"

for /f "delims=" %%A in ('where /R "%ProgramFiles(x86)%" steam.exe') do set var=%%A
cmd /c "%var%"

for /f "delims=" %%A in ('where /R "%ProgramFiles(x86)%" wmplayer.exe') do set var=%%A
cmd /c "%var%"

for /f "delims=" %%A in ('where /R "%USERPROFILE%\AppData" discord.exe') do set var=%%A
cmd /c "%var%"

D:
for /f "delims=" %%A in ('where /R "D:\Program Files" qbittorrent.exe') do set var=%%A
cmd /c "%var%"