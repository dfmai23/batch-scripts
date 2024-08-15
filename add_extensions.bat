@echo off
set ext=png

for %%f in (*.) do (
	echo %%f
	ren "%%f" "%%f.%ext%"
)