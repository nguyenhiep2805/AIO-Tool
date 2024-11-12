@echo off&color 70&title  Widows AIO Script - Hiep Code - v1.0>nul
cd /d "%~dp0"

:menu
cls
echo.
echo             ^ ________________________________________________________________
echo             ^|                                                                ^|
echo             ^|               ===================================              ^|
echo             ^|                 Windows AIO Script - Hiep Code                 ^|
echo             ^|               ===================================              ^|
echo             ^|                                                                ^|
echo             ^|      [1] Sao luu danh sach wifi                                ^|
echo             ^|                                                                ^|
echo             ^|      [2] Khoi phuc danh sach wifi                              ^|
echo             ^|                                                                ^|
echo             ^|      [3] Sao luu driver                                        ^|
echo             ^|                                                                ^|
echo             ^|      [4] Khoi phuc driver                                      ^|
echo             ^|                                                                ^|
echo             ^|      [5] Kich hoat WinRar                                      ^|
echo             ^|                                                                ^|
echo             ^|      [6] Kiem tra tinh trang pin                               ^|
echo             ^|                                                                ^|
echo             ^|      [7] Sap xep file                                          ^|
echo             ^|                                                                ^|
echo             ^|      [8] Hen gio tat may                                       ^|
echo             ^|                                                                ^|
echo             ^|      [9] Thong tin thiet bi                                    ^|
echo             ^|                                                                ^|
echo             ^|      [10] Tai phan mem mien phi                                ^|
echo             ^|                                                                ^|
echo             ^|      [11] Thoat chuong trinh                                   ^|
echo             ^|                                                                ^|
echo             ^|________________________________________________________________^|

echo.
set /p choice="Vui long chon mot lua chon: "

if "%choice%"=="1" goto backupwifi
if "%choice%"=="2" goto restorewifi
if "%choice%"=="3" goto backupdriver
if "%choice%"=="4" goto restoredriver
if "%choice%"=="5" goto winrar
if "%choice%"=="6" goto checkbattery
if "%choice%"=="7" goto sortfiles
if "%choice%"=="8" goto turnoff
if "%choice%"=="9" goto info
if "%choice%"=="10" goto software
if "%choice%"=="11" goto exit
goto menu

:software
cls
start https://software.nguyenhiep.me
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:info
cls
setlocal enabledelayedexpansion
echo Device name: %COMPUTERNAME%
for /f "delims=" %%I in ('powershell -Command "Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name"') do set Processor=%%I
echo Processor: %Processor%
for /f "delims=" %%I in ('powershell -Command "([math]::round((Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1))"') do set RAM=%%I
echo Installed RAM: %RAM% GB
for /f "tokens=2*" %%I in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OneSettings\appcompat\runtimesdbincloud\QueryParameters" /v deviceid 2^>nul') do (
    set DeviceID=%%J
    set DeviceID=!DeviceID:{=!
    set DeviceID=!DeviceID:}=!
)
echo Device ID: !DeviceID!
for /f "delims=" %%I in ('powershell -Command "Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty SerialNumber"') do set ProductID=%%I
echo Product ID: %ProductID%
for /f "delims=" %%I in ('powershell -Command "(Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty Caption) -replace 'Microsoft ','"'') do set Edition=%%I
echo Edition: %Edition%
echo Device name: %COMPUTERNAME% > temp.txt
echo Processor: %Processor% >> temp.txt
echo Installed RAM: %RAM% GB >> temp.txt
echo Device ID: !DeviceID! >> temp.txt
echo Product ID: %ProductID% >> temp.txt
echo Edition: %Edition% >> temp.txt
type temp.txt | clip
del temp.txt
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:turnoff
cls
set /p seconds="Nhap thoi gian hen gio tat may (giay): "
echo May tinh se tat sau %seconds% giay...
shutdown /s /f /t %seconds%
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:backupwifi
cls
if not exist "Wifi" mkdir "Wifi"
echo Dang sao luu danh sach wifi vao thu muc "Wifi"...
netsh wlan export profile key=clear folder="%~dp0\Wifi"
echo.
echo Danh sach Wifi da duoc sao luu vao thu muc "Wifi".
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:restorewifi
cls
if not exist "Wifi" mkdir "Wifi"
echo Dang nhap danh sach Wifi...
for %%i in ("%~dp0\Wifi\*.xml") do (
    netsh wlan add profile filename="%%i"
)
echo.
echo Tat ca Wifi da duoc khoi phuc tu thu muc "Wifi".
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:backupdriver
if not exist "%~dp0Driver" (
    echo Dang tao thu muc "Driver"...
    mkdir "%~dp0Driver"
)

echo Dang sao luu driver vao thu muc "Driver"...
dism /online /export-driver /destination:"%~dp0Driver"
echo Tat ca driver da duoc sao luu vao thu muc "Driver".
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:restoredriver
echo Dang khoi phuc driver tu thu muc "Driver"...
pnputil /add-driver "%~dp0Driver\*.inf" /subdirs /install
echo Tat ca driver da duoc khoi phuc tu thu muc "Driver".
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:checkbattery
cls
echo Dang tao bao cao tinh trang pin...
powercfg /batteryreport /output "%~dp0\battery-report.html"
echo.
echo Bao cao tinh trang pin da duoc tao "battery-report.html" va luu o duong dan hien tai.
start "" "%~dp0\battery-report.html"
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:winrar
cls
echo Dang kich hoat WinRar...
certutil -decode "%~f0" "%ProgramW6432%\WinRAR\rarreg.key"
echo.
echo WinRar da duoc kich hoat thanh cong.
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:sortfiles
cls
echo Dang sap xep cac tep tin vao thu muc...

REM -- CMD ---
set "destination_folder=CMD"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.cmd *.bat) do move "%%F" "%destination_folder%"

REM -- Pictures ---
set "destination_folder=Hinh Anh"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.png *.jpeg *.jpg) do move "%%F" "%destination_folder%"

REM -- Drawings ---
set "destination_folder=Ban Ve"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.dwg *.dwt) do move "%%F" "%destination_folder%"

REM -- Auto Lisp ---
set "destination_folder=Lisp"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.lsp *.vlx *.fas) do move "%%F" "%destination_folder%"

REM -- Movies ---
set "destination_folder=Phim"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.mp4 *.wmv *.avi) do move "%%F" "%destination_folder%"

REM -- Documents ---
set "destination_folder=Tai Lieu"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.pdf *.xlsx *.docx *.txt *.pptx) do move "%%F" "%destination_folder%"

REM -- Compressed Files ---
set "destination_folder=File Nen"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.rar *.zip *.7z) do move "%%F" "%destination_folder%"

REM -- Executables ---
set "destination_folder=File Thuc Thi"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.exe *.msi) do move "%%F" "%destination_folder%"

REM -- Audio Files ---
set "destination_folder=Am Thanh"
if not exist "%destination_folder%" mkdir "%destination_folder%"
for /r "%~dp0" %%F in (*.mp3 *.m4a *.aac) do move "%%F" "%destination_folder%"

REM -- Delete empty directories
for /f "delims=" %%d in ('dir /s /b /ad ^| sort /r') do rd "%%d" 2>nul

echo Tat ca tep tin da duoc sap xep.
echo Nhan phim bat ky de quay lai...
pause >nul
goto menu

:exit
exit

-----BEGIN CERTIFICATE-----
UkFSIHJlZ2lzdHJhdGlvbiBkYXRhDQpEYXRhYmFzZSBBZG1pbmlzdHJhdG9yDQpV
bmxpbWl0ZWQgQ29tcGFueSBMaWNlbnNlDQpVSUQ9MGJkNWMwODU2YmUzMWQ0Mzhm
M2MNCjY0MTIyMTIyNTA4ZjNjMDc4MjYxYzdmOTc3YThlZDEyZmExNzRiMmRkYWJi
MjdjNDM4MDdiOQ0KOTVkZDMxNmI1NjJiYjQzYzA2YTQ2MGZjZTZjYjVmZmRlNjI4
OTAwNzk4NjFiZTU3NjM4NzE3DQo3MTMxY2VkODM1ZWQ2NWNjNzQzZDk3NzdmMmVh
NzFhOGUzMmM3ZTU5M2NmNjY3OTQzNDM1NjUNCmI0MWJjZjU2OTI5NDg2YjhiY2Rh
YzMzZDUwZWNmNzczOTk2MDY1ZWE5MDM4NTJmNDE5NjE0NQ0KNTYwNTU2M2I5YjU0
NWM2NjYyMDRhNzJlYzgwNjE3ZTBhYjhmYzEzZTU5NTIxMmViNjJlZTk2DQoxN2Q5
ZWJkNjVkMzM2MzI0M2MxNjc0NTk4YjEyNDExYTg2MzM5ZjI5M2FjNzViYzg2MDky
MjUNCjM0NzZjM2ZiMjJhNWM0ZjI0NDEyMDk4MWFlNDM1ZWJiOGIxYzhmMzVhNjEy
MDIwODgyNjgwNg==
-----END CERTIFICATE-----
