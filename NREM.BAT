@echo off
:: Set to UTF-8 code page for better character support
chcp 65001

:: Force the color to blue text on black background (1F)
color 01

:: Set window size (Adjusted for compatibility)
mode con: cols=100 lines=30

:: Title
title NREM PROJECT - OSINT Tool

:main
cls
echo.
echo ███╗   ██╗██████╗ ███████╗███╗  ███╗
echo ████╗  ██║██╔══██╗██╔════╝████╗ ████║
echo ██╔██╗ ██║██║  ██║█████╗  ██╔████╔██║
echo ██║╚██╗██║██║  ██║██╔══╝  ██║╚██╔╝██║
echo ██║ ╚████║██████╔╝███████╗██║ ╚═╝ ██║
echo ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝     ╚═╝
echo.
echo             NREM PROJECT
echo         made by Linux Services
echo                  v1.1
echo -------------------------------------
echo Time: %time%
echo.
echo [1] Scan for Active IPs and Wi-Fi Passwords
echo [2] Ping IP Address
echo [3] Scan for Open Ports
echo [4] IP Geolocation Lookup
echo [5] Search for Social Media Accounts
echo [6] Intext/Keyword Web Search
echo [7] Domain WHOIS Lookup
echo [8] DNS Records Lookup
echo [9] Email Breach Check
echo [0] Exit
echo.
set /p choice=Choose an option: 

if "%choice%"=="1" goto scanips
if "%choice%"=="2" goto pingip
if "%choice%"=="3" goto portscan
if "%choice%"=="4" goto geolocate
if "%choice%"=="5" goto socialsearch
if "%choice%"=="6" goto intextsearch
if "%choice%"=="7" goto whoislookup
if "%choice%"=="8" goto dnslookup
if "%choice%"=="9" goto emailbreach
if "%choice%"=="0" exit
goto main

:scanips
cls
echo Scanning local network for active IPs...
echo Please wait, this might take a minute...
(for /L %%i in (1,1,254) do (
    ping -n 1 -w 10 192.168.1.%%i | find "TTL=" >nul && echo 192.168.1.%%i >> active_ips.txt
))
arp -a >> active_ips.txt
echo.
echo Active IPs saved to active_ips.txt

echo.
echo Retrieving saved Wi-Fi passwords...
netsh wlan show profiles > temp_profiles.txt
for /f "tokens=2 delims=:" %%A in ('findstr "All User Profile" temp_profiles.txt') do (
    set "ssid=%%A"
    call :getpw
)
del temp_profiles.txt
echo Wi-Fi passwords saved to wifi_passwords.txt
pause
goto main

:getpw
setlocal enabledelayedexpansion
set "ssid=!ssid:~1!"
echo === !ssid! === >> wifi_passwords.txt
netsh wlan show profile name="!ssid!" key=clear | find "Key Content" >> wifi_passwords.txt
endlocal
exit /b

:pingip
cls
set /p ip=Enter IP to ping: 
ping %ip%
pause
goto main

:portscan
cls
set /p ip=Enter IP to scan ports (1–1024): 
echo Scanning ports using PowerShell...
powershell -Command "1..1024 | ForEach-Object { if (Test-NetConnection -ComputerName '%ip%' -Port $_ -InformationLevel Quiet) { Write-Host ('Port open: ' + $_) } }"
pause
goto main

:geolocate
cls
set /p ip=Enter IP to geolocate: 
echo Getting location using ip-api...

:: Get JSON response from ip-api and save to a file
curl -s "http://ip-api.com/json/%ip%" > geolocate_result.json

:: Extract and format the key geolocation details
for /f "delims=" %%A in ('findstr /i "country city region zip isp org" geolocate_result.json') do (
    echo %%A >> geolocate_result.txt
)

:: Adding readable titles for the saved results
echo. >> geolocate_result.txt
echo ** Geolocation Information for IP: %ip% ** >> geolocate_result.txt
echo ------------------------------------------ >> geolocate_result.txt
echo Country: >> geolocate_result.txt
findstr /i "country" geolocate_result.json >> geolocate_result.txt
echo Region: >> geolocate_result.txt
findstr /i "regionName" geolocate_result.json >> geolocate_result.txt
echo City: >> geolocate_result.txt
findstr /i "city" geolocate_result.json >> geolocate_result.txt
echo ZIP Code: >> geolocate_result.txt
findstr /i "zip" geolocate_result.json >> geolocate_result.txt
echo ISP: >> geolocate_result.txt
findstr /i "isp" geolocate_result.json >> geolocate_result.txt
echo Organization: >> geolocate_result.txt
findstr /i "org" geolocate_result.json >> geolocate_result.txt
echo Lat/Lon: >> geolocate_result.txt
findstr /i "lat" geolocate_result.json >> geolocate_result.txt
findstr /i "lon" geolocate_result.json >> geolocate_result.txt

:: Display the formatted results in the console
type geolocate_result.txt
echo.
echo Saved to geolocate_result.txt
pause
goto main

:socialsearch
cls
set /p username=Enter username to search for: 
start "" "https://www.google.com/search?q=%username%+site:twitter.com+OR+site:instagram.com+OR+site:tiktok.com+OR+site:facebook.com"
echo Opened browser to search for social media accounts.
pause
goto main

:intextsearch
cls
set /p keyword=Enter keyword to search in text: 
start "" "https://www.google.com/search?q=intext:%keyword%"
echo Opened browser to search intext keyword.
pause
goto main

:whoislookup
cls
set /p domain=Enter domain to lookup (e.g., example.com): 
echo Fetching WHOIS info...
whois %domain% > whois_result.txt 2>nul
if exist whois_result.txt (
    type whois_result.txt
    echo.
    echo WHOIS information saved to whois_result.txt
) else (
    echo WHOIS command not available or failed.
)
pause
goto main

:dnslookup
cls
set /p domain=Enter domain to check DNS records (e.g., example.com): 
echo Fetching DNS info...
nslookup %domain% > dns_result.txt
type dns_result.txt
echo.
echo DNS info saved to dns_result.txt
pause
goto main

:emailbreach
cls
set /p email=Enter email address to check for breaches: 
echo Checking if the email is compromised...
start "" "https://haveibeenpwned.com/"
echo Opened browser to check email breach status.
pause
goto main
