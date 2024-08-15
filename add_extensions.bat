@echo off
set ext=png

for %%f in (*.) do (
	echo %%f -^> %%f.%ext%
	ren "%%f" "%%f.%ext%"
)