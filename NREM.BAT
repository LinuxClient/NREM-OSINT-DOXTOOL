@echo off
:: Set UTF-8 code page for better character support
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: Change to script's directory
cd /d "%~dp0"

:: Force color to blue text on black background (1F)
color 01

:: Set window size (Adjusted for compatibility)
mode con: cols=100 lines=30

:: Title
title NREM PROJECT - OSINT Tool v1.3

:: Create required directories
if not exist logs mkdir logs
if exist active_ips.txt del active_ips.txt
if exist wifi_passwords.txt del wifi_passwords.txt
if exist geolocate_result.txt del geolocate_result.txt

:: Timestamp for logs
for /f "tokens=1-4 delims=/:. " %%a in ("%date% %time%") do set timestamp=%%d-%%b-%%c_%%a%%b

:: Check for required tools
where curl >nul 2>nul || (echo ERROR: 'curl' is not available. Install it or upgrade to Windows 10+. & pause & exit)
where whois >nul 2>nul || echo WARNING: 'whois' is not available. WHOIS lookup may not work.

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
echo [12] Subdomain Finder
echo [13] Reverse IP Lookup (Hostnames)
echo [14] Google Dork Generator
echo [15] Shodan Lookup
echo [16] Metadata Extractor (via exiftool)
echo [17] Pastebin Email Leak Search
echo [18] Username Availability Checker
echo [19] Phone Number OSINT
echo [20] Wayback Machine Lookup
echo [21] IP Range Scanner
echo [0]  Exit
set /p choice=Choose an option: 

if not defined choice goto main

for %%i in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 0) do (
    if "%choice%"=="%%i" goto opt%%i
)
echo Invalid option. Try again.
call :pauseAndReturn

:header
echo.
echo ===================================================
echo         ███╗   ██╗███████╗██████╗ ███╗   ███╗      
echo         ████╗  ██║██╔════╝██╔══██╗████╗ ████║      
echo         ██╔██╗ ██║█████╗  ██████╔╝██╔████╔██║      
echo         ██║╚██╗██║██╔══╝  ██╔══██╗██║╚██╔╝██║      
echo         ██║ ╚████║███████╗██║  ██║██║ ╚═╝ ██║      
echo         ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝      
echo ===================================================
echo NREM PROJECT - made by Linux Services
echo Version 1.4
echo Time: %time%
echo.
exit /b

:pauseAndReturn
echo.
pause
goto main

:opt1
cls
echo Scanning local network for active IPs...
set "baseip=192.168.1"
(for /L %%i in (1,1,254) do (
    echo Scanning !baseip!.%%i
    ping -n 1 -w 150 !baseip!.%%i | find "TTL=" && echo !baseip!.%%i >> active_ips.txt
))
arp -a >> active_ips.txt
copy active_ips.txt logs\active_ips_%timestamp%.txt >nul

echo.
echo Retrieving saved Wi-Fi passwords...
netsh wlan show profiles > temp_profiles.txt
for /f "tokens=2 delims=:" %%A in ('findstr "All User Profile" temp_profiles.txt') do (
    set "ssid=%%A"
    call :getpw
)
del temp_profiles.txt
copy wifi_passwords.txt logs\wifi_passwords_%timestamp%.txt >nul
call :pauseAndReturn

:getpw
setlocal enabledelayedexpansion
set "ssid=!ssid:~1!"
echo === !ssid! === >> wifi_passwords.txt
netsh wlan show profile name="!ssid!" key=clear | find "Key Content" >> wifi_passwords.txt
endlocal
exit /b

:opt2
cls
call :header
set /p ip=Enter IP to ping: 
ping "%ip%"
call :pauseAndReturn

:opt3
cls
call :header
set /p ip=Enter IP to scan ports (1–1024): 
powershell -Command "1..1024 | ForEach-Object { try { if (Test-NetConnection -ComputerName '%ip%' -Port $_ -InformationLevel Quiet) { Write-Host ('Port open: ' + $_) } } catch {} }"
call :pauseAndReturn

:opt4
cls
call :header
set /p ip=Enter IP to geolocate: 
curl -s "http://ip-api.com/json/%ip%" > geo.json
(for %%G in (country regionName city zip isp org lat lon) do (
    findstr "%%G" geo.json >> geolocate_result.txt
))
copy geolocate_result.txt logs\geolocate_%timestamp%.txt >nul
type geolocate_result.txt
call :pauseAndReturn

:opt5
cls
call :header
set /p username=Enter username to search for: 
start "" "https://www.google.com/search?q=%username: =+%+site:twitter.com+OR+site:instagram.com+OR+site:tiktok.com+OR+site:facebook.com"
call :pauseAndReturn

:opt6
cls
call :header
set /p keyword=Enter keyword to search in text: 
start "" "https://www.google.com/search?q=intext:%keyword: =+%"
call :pauseAndReturn

:opt7
cls
call :header
set /p domain=Enter domain to lookup: 
whois %domain% > whois_result.txt 2>nul
if exist whois_result.txt (
    type whois_result.txt
    copy whois_result.txt logs\whois_%timestamp%.txt >nul
    echo WHOIS information saved.
) else (
    echo WHOIS command not available or failed.
)
call :pauseAndReturn

:opt8
cls
call :header
set /p domain=Enter domain for DNS check: 
nslookup %domain% > dns_result.txt
type dns_result.txt
copy dns_result.txt logs\dns_%timestamp%.txt >nul
call :pauseAndReturn

:opt9
cls
call :header
set /p email=Enter email to check: 
start "" "https://haveibeenpwned.com/"
call :pauseAndReturn

:opt10
cls
call :header
set /p url=Enter URL (with https://) to check headers: 
curl -I "%url%" > headers.txt
type headers.txt
copy headers.txt logs\headers_%timestamp%.txt >nul
call :pauseAndReturn

:opt11
cls
call :header
set /p ip=Enter IP for reverse DNS lookup: 
nslookup "%ip%" > reverse_dns.txt
type reverse_dns.txt
copy reverse_dns.txt logs\reverse_dns_%timestamp%.txt >nul
call :pauseAndReturn

:opt12
cls
call :header
set /p domain=Enter domain to find subdomains: 
start "" "https://crt.sh/?q=%domain%"
call :pauseAndReturn

:opt13
cls
call :header
set /p ip=Enter IP for reverse lookup: 
nslookup "%ip%" > reverse_ip.txt
type reverse_ip.txt
copy reverse_ip.txt logs\reverse_ip_%timestamp%.txt >nul
call :pauseAndReturn

:opt14
cls
call :header
set /p dork=Enter Google Dork (e.g., site:, filetype:, inurl:): 
start "" "https://www.google.com/search?q=%dork: =+%"
call :pauseAndReturn

:opt15
cls
call :header
set /p target=Enter IP/domain for Shodan search: 
start "" "https://www.shodan.io/search?query=%target: =+%"
call :pauseAndReturn

:opt16
cls
call :header
set /p filepath=Enter path to file (requires exiftool): 
exiftool "%filepath%" > metadata.txt
type metadata.txt
copy metadata.txt logs\metadata_%timestamp%.txt >nul
call :pauseAndReturn

:opt17
cls
call :header
set /p email=Enter email to search on Pastebin: 
start "" "https://pastebin.com/search?q=%email%"
call :pauseAndReturn

:opt18
cls
call :header
set /p username=Enter username to check: 
start "" "https://namechk.com/"
call :pauseAndReturn

:opt19
cls
call :header
set /p number=Enter phone number: 
start "" "https://www.truecaller.com/"
call :pauseAndReturn

:opt20
cls
call :header
set /p site=Enter website URL to check archive: 
start "" "https://web.archive.org/web/*/%site%"
call :pauseAndReturn

:opt21
cls
call :header
set /p base=Enter base IP (e.g., 192.168.0): 
(for /L %%i in (1,1,254) do (
    echo Pinging %%i...
    ping -n 1 -w 200 %base%.%%i | find "TTL=" && echo %base%.%%i >> scanned_range.txt
))
copy scanned_range.txt logs\iprange_%timestamp%.txt >nul
call :pauseAndReturn

:opt0
exit
