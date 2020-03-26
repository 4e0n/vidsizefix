rem vidsizefix - Video file size limiter ffmpeg wrapper DOS batch script
rem   Copyright (C) 2020 Barkin Ilhan
   
rem  This program is free software: you can redistribute it and/or modify
rem  it under the terms of the GNU General Public License as published by
rem  the Free Software Foundation, either version 3 of the License, or
rem  (at your option) any later version.
rem  This program is distributed in the hope that it will be useful,
rem  but WITHOUT ANY WARRANTY; without even the implied warranty of
rem  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem  GNU General Public License for more details.
rem  You should have received a copy of the GNU General Public License
rem  along with this program.  If no:t, see <https://www.gnu.org/licenses/>.

rem  Contact info:
rem  E-Mail:  barkin@unrlabs.org
rem  Website: http://icon.unrlabs.org/staff/barkin/
rem  Repo:    https://github.com/4e0n/

rem This script has been written due to the emerged need of limiting
rem the size of .MP4 files recorded by university professors
rem for remote education in Windows environment. These video files
rem are around 20-30 minutes in duration, yet depending on the content
rem being vivid or stable the sizes vary between 50 to 300mb. In that
rem script, regardless of their initial size, they are shrinked to
rem 40mb with H264 proper loss, over ffmpeg.

@echo off

rem --- Destination file size by default -> 40mb (change if needed)
set /a size=40

rem --- Audio bitrate
set /a abitrate=128

set ifn=%1

rem --- dstfilename.mp4=srcfilename-XXmb.mp4
for /f "tokens=1,2 delims=." %%a in ("%ifn%") do (
 set froot=%%a
 set fext=%%b
)
set ofn=%froot%-%size%mb.%fext%
rem echo %ofn%

c:\ffmpeg\bin\ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 %ifn% > temp.txt
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

c:\ffmpeg\bin\ffmpeg -y -i %ifn% -c:v libx264 -preset medium -b:v %vbitrate%k -pass 1 -c:a aac -b:a %abitrate%k -f mp4 NUL && ^
c:\ffmpeg\bin\ffmpeg -i %ifn% -c:v libx264 -preset medium -b:v %vbitrate%k -pass 2 -c:a aac -b:a %abitrate%k %ofn%
