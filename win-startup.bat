
@echo off
REM windows app launch script
REM steam
REM discord
REM firefox
REM windows media player

cd C:/
where /R "%ProgramFiles%" firefox.exe | cmd
where /R "%ProgramFiles(x86)%" steam.exe | cmd
where /R "%ProgramFiles(x86)%" wmplayer.exe | cmd
where /R "%USERPROFILE%\AppData" discord.exe | cmd

D:
where /R "D:\Program Files" qbittorrent.exe | cmd