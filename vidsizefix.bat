rem NEU Meram Tip Fakultesi MP4 dosyasi boyut ayarlayici
rem GPL v3 - Barkin Ilhan (barkin@unrlabs.org)

@echo off

rem --- Hedef dosya buyuklugu -> 40mb
set /a size=40

set /a abitrate=128
set ifn=%1

rem --- Hedef dosya adi
for /f "tokens=1,2 delims=." %%a in ("%ifn%") do (
 set froot=%%a
 set fext=%%b
)
set ofn=%froot%-%size%mb.%fext%
rem echo %ofn%

c:\ffmpeg\ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 %ifn% > temp.txt
set /p duration=<temp.txt
del temp.txt

for /f "tokens=1,2 delims=." %%a in ("%duration%") do (
 set left=%%a
 set right=%%b
)
set right=%right:~0,1%
if defined right if %right% GEQ 5 ( 
 set /a dur=%left%+1
) else ( 
 set /a dur=%left%
)
set /a vbitrate=%size% *1024*1024*8/dur/1000-%abitrate%
rem echo %vbitrate% %abitrate%

c:\ffmpeg\ffmpeg -y -i %ifn% -c:v libx264 -preset medium -b:v %vbitrate%k -pass 1 -c:a aac -b:a %abitrate%k -f mp4 NUL && ^
c:\ffmpeg\ffmpeg -i %ifn% -c:v libx264 -preset medium -b:v %vbitrate%k -pass 2 -c:a aac -b:a %abitrate%k %ofn%
