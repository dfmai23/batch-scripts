rem "https://www.dostips.com/?t=Batch.FindAndReplace"
rem https://stackoverflow.com/questions/9153139/batch-file-to-read-and-modify-text-file
rem https://stackoverflow.com/questions/5477209/how-to-replace-text-in-text-file-using-bat-file-script
rem https://stackoverflow.com/questions/9102422/windows-batch-set-inside-if-not-working
rem https://stackoverflow.com/questions/25384358/batch-if-elseif-else
rem http://www.lagmonster.org/docs/DOS7/pipes.html

rem echo.1:2 . does empty string, : more robust
rem %~1 removes quotes if any surrounding the value
rem disabledelayedexpansion to avoid problems with exclamations inside the data 
rem enabledelayedexpansion for ! expansion to be evaluated at execution since % expansion is at parse time
rem goes line by line in file and replaces DataCenterHint with new region
rem %%a is first token (line number), %%b is remaining token

@echo off
setlocal enableextensions
setlocal disabledelayedexpansion

set textfile=GameSettings.ini
set textfile2=GameSettings2.ini
set tempfile=TempSettings.ini
rem set textfile=file.txt
set region=eastasia

copy %textfile% %tempfile%
del %textfile%

for /f "tokens=1,* delims=]" %%a in ('"type %tempfile%|find /n /v """') do (
	setlocal enabledelayedExpansion
	set currentline=%%b
	set truncline=!currentline:~0,15!
	rem echo [LINE]!currentline!
	rem echo !truncline!

	if /i !truncline!==DataCenterHint= (
		rem print new datacenter
		echo !truncline!%region%
	) else (
	if not defined currentline (
		rem print blank line
		echo:
	) else (
		rem print original line
		echo !currentline!
	)
	)
	endlocal	
) >> %textfile%

del %tempfile%