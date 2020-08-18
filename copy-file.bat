@echo off

set newfile=filenamehere

rem %~1 removes quotes if any surrounding the value
rem add quotes to deal with spaces
echo %~1

rem /y suppress confirm 
copy %~1 %newfile% /y

rem pause