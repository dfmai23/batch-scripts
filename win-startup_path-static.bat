
@echo off
REM windows app launch script
REM steam
REM discord
REM firefox
REM windows media player

@echo on
cd C:\
start cmd /c "%ProgramFiles%\Mozilla Firefox\firefox.exe"
start cmd /c "%ProgramFiles(x86)%\Steam\steam.exe"
start cmd /c "%ProgramFiles(x86)%\Windows Media Player\wmplayer.exe"
start cmd /c "%LOCALAPPDATA%\Discord\Update.exe --processStart Discord.exe"

D:
start cmd /c "D:\Program Files\qBittorrent\qbittorrent.exe"