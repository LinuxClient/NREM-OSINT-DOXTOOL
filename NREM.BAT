@echo off
:: Set UTF-8 code page for better character support
chcp 65001 >nul

:: Force color to blue text on black background (1F)
color 01

:: Set window size (Adjusted for compatibility)
mode con: cols=100 lines=30

:: Title
title NREM PROJECT - OSINT Tool v1.2

:: Create required directories
if not exist logs mkdir logs
if exist active_ips.txt del active_ips.txt
if exist wifi_passwords.txt del wifi_passwords.txt
if exist geolocate_result.txt del geolocate_result.txt

:main
cls
call :header

:: Main menu
echo [1]  Scan for Active IPs and Wi-Fi Passwords
echo [2]  Ping IP Address
echo [3]  Scan for Open Ports
echo [4]  IP Geolocation Lookup
echo [5]  Search for Social Media Accounts
echo [6]  Intext/Keyword Web Search
echo [7]  Domain WHOIS Lookup
echo [8]  DNS Records Lookup
echo [9]  Email Breach Check
echo [10] HTTP Headers Check
echo [11] Reverse DNS Lookup
echo [0]  Exit
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
if "%choice%"=="10" goto headerscheck
if "%choice%"=="11" goto reversedns
if "%choice%"=="0" exit
goto main

:header
echo.
echo [94m==============================================[0m
echo [96m ███╗   ██╗██████╗ ███████╗███╗  ███╗[0m
echo [96m ████╗  ██║██╔══██╗██╔════╝████╗ ████║[0m
echo [96m ██╔██╗ ██║██║  ██║█████╗  ██╔████╔██║[0m
echo [96m ██║╚██╗██║██║  ██║██╔══╝  ██║╚██╔╝██║[0m
echo [96m ██║ ╚████║██████╔╝███████╗██║ ╚═╝ ██║[0m
echo [96m ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝     ╚═╝[0m
echo [94m==============================================[0m
echo NREM PROJECT - made by Linux Services
echo Version 1.2
echo Time: %time%
echo.
exit /b

:scanips
cls
call :header
echo Scanning local network for active IPs...
echo Please wait...
(for /L %%i in (1,1,254) do (
    ping -n 1 -w 10 192.168.1.%%i | find "TTL=" >nul && echo 192.168.1.%%i >> active_ips.txt
))
echo.
echo Active IPs saved to active_ips.txt

:: Wi-Fi password extraction
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
call :header
set /p ip=Enter IP to ping: 
ping %ip%
pause
goto main

:portscan
cls
call :header
set /p ip=Enter IP to scan ports (1–1024): 
powershell -Command "1..1024 | ForEach-Object { if (Test-NetConnection -ComputerName '%ip%' -Port $_ -InformationLevel Quiet) { Write-Host ('Port open: ' + $_) } }"
pause
goto main

:geolocate
cls
call :header
set /p ip=Enter IP to geolocate: 
curl -s "http://ip-api.com/json/%ip%" > geolocate_result.json
(for %%A in (country city region zip isp org lat lon) do findstr /i "%%A" geolocate_result.json) > geolocate_result.txt
type geolocate_result.txt
echo.
echo Saved to geolocate_result.txt
pause
goto main

:socialsearch
cls
call :header
set /p username=Enter username to search for: 
start "" "https://www.google.com/search?q=%username%+site:twitter.com+OR+site:instagram.com+OR+site:tiktok.com+OR+site:facebook.com"
pause
goto main

:intextsearch
cls
call :header
set /p keyword=Enter keyword to search in text: 
start "" "https://www.google.com/search?q=intext:%keyword%"
pause
goto main

:whoislookup
cls
call :header
set /p domain=Enter domain to lookup: 
whois %domain% > whois_result.txt 2>nul
if exist whois_result.txt (
    type whois_result.txt
    echo WHOIS information saved to whois_result.txt
) else (
    echo WHOIS command not available or failed.
)
pause
goto main

:dnslookup
cls
call :header
set /p domain=Enter domain for DNS check: 
nslookup %domain% > dns_result.txt
type dns_result.txt
echo DNS info saved to dns_result.txt
pause
goto main

:emailbreach
cls
call :header
set /p email=Enter email to check: 
start "" "https://haveibeenpwned.com/"
pause
goto main

:headerscheck
cls
call :header
set /p url=Enter URL (with https://) to check headers: 
curl -I %url% > headers.txt
type headers.txt
echo HTTP headers saved to headers.txt
pause
goto main

:reversedns
cls
call :header
set /p ip=Enter IP for reverse DNS lookup: 
nslookup %ip% > reverse_dns.txt
type reverse_dns.txt
echo Reverse DNS info saved to reverse_dns.txt
pause
goto main
