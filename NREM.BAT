@echo off
:: Set UTF-8 code page for better character support
chcp 65001 >nul

setlocal EnableDelayedExpansion


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
if "%choice%"=="12" goto subdomains
if "%choice%"=="13" goto reverseip
if "%choice%"=="14" goto dorkgen
if "%choice%"=="15" goto shodan
if "%choice%"=="16" goto metadata
if "%choice%"=="17" goto pastebin
if "%choice%"=="18" goto usernamecheck
if "%choice%"=="19" goto phoneosint
if "%choice%"=="20" goto wayback
if "%choice%"=="21" goto iprangescan
if "%choice%"=="0" exit
echo Invalid option. Try again.
pause
goto main

:header
echo.
echo ==============================================
echo  ███╗   ██╗██████╗ ███████╗███╗  ███╗
echo  ████╗  ██║██╔══██╗██╔════╝████╗ ████║
echo  ██╔██╗ ██║██║  ██║█████╗  ██╔████╔██║
echo  ██║╚██╗██║██║  ██║██╔══╝  ██║╚██╔╝██║
echo  ██║ ╚████║██████╔╝███████╗██║ ╚═╝ ██║
echo  ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝     ╚═╝
echo ==============================================
echo NREM PROJECT - made by Linux Services
echo Version 1.3
echo Time: %time%
echo.
exit /b

:scanips
cls
echo Scanning local network for active IPs...
echo Please wait, this might take a minute...
del active_ips.txt 2>nul

for /L %%i in (1,1,254) do (
    echo Scanning 192.168.1.%%i
    ping -n 1 -w 200 192.168.1.%%i | find "TTL=" >nul
    if not errorlevel 1 echo 192.168.1.%%i >> active_ips.txt
)

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
call :header
set /p ip=Enter IP to ping: 
ping "%ip%"
pause
goto main

:portscan
cls
call :header
set /p ip=Enter IP to scan ports (1–1024): 
powershell -Command "1..1024 | ForEach-Object { try { if (Test-NetConnection -ComputerName '%ip%' -Port $_ -InformationLevel Quiet) { Write-Host ('Port open: ' + $_) } } catch {} }"
pause
goto main

:geolocate
cls
call :header
setlocal EnableDelayedExpansion
set /p ip=Enter IP to geolocate: 

:: Get JSON response
curl -s "http://ip-api.com/json/%ip%" > geolocate_raw.json

:: Clean up the output
del geolocate_result.txt 2>nul
(for /f "usebackq delims=" %%A in ("geolocate_raw.json") do (
    set "line=%%A"
    set "line=!line:{=!"
    set "line=!line:}=!"
    set "line=!line:,=!"
    for %%B in (!line!) do (
        echo %%B | findstr /r /i "country regionName city zip isp org lat lon" >> geolocate_result.txt
    )
))

:: Show results
echo.
type geolocate_result.txt
echo.
echo Saved to geolocate_result.txt
endlocal
pause
goto main

:socialsearch
cls
call :header
set /p username=Enter username to search for: 
start "" "https://www.google.com/search?q=%username: =+%+site:twitter.com+OR+site:instagram.com+OR+site:tiktok.com+OR+site:facebook.com"
pause
goto main

:intextsearch
cls
call :header
set /p keyword=Enter keyword to search in text: 
start "" "https://www.google.com/search?q=intext:%keyword: =+%"
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
curl -I "%url%" > headers.txt
type headers.txt
echo HTTP headers saved to headers.txt
pause
goto main

:reversedns
cls
call :header
set /p ip=Enter IP for reverse DNS lookup: 
nslookup "%ip%" > reverse_dns.txt
type reverse_dns.txt
echo Reverse DNS info saved to reverse_dns.txt
pause
goto main

:subdomains
cls
call :header
set /p domain=Enter domain to find subdomains: 
start "" "https://crt.sh/?q=%domain%"
pause
goto main

:reverseip
cls
call :header
set /p ip=Enter IP for reverse lookup: 
nslookup "%ip%" > reverse_ip.txt
type reverse_ip.txt
pause
goto main

:dorkgen
cls
call :header
set /p dork=Enter Google Dork (e.g., site:, filetype:, inurl:): 
start "" "https://www.google.com/search?q=%dork: =+%"
pause
goto main

:shodan
cls
call :header
set /p target=Enter IP/domain for Shodan search: 
start "" "https://www.shodan.io/search?query=%target: =+%"
pause
goto main

:metadata
cls
call :header
set /p filepath=Enter path to file (requires exiftool): 
exiftool "%filepath%" > metadata.txt
type metadata.txt
pause
goto main

:pastebin
cls
call :header
set /p email=Enter email to search on Pastebin: 
start "" "https://pastebin.com/search?q=%email%"
pause
goto main

:usernamecheck
cls
call :header
set /p username=Enter username to check: 
start "" "https://namechk.com/"
pause
goto main

:phoneosint
cls
call :header
set /p number=Enter phone number: 
start "" "https://www.truecaller.com/"
pause
goto main

:wayback
cls
call :header
set /p site=Enter website URL to check archive: 
start "" "https://web.archive.org/web/*/%site%"
pause
goto main

:iprangescan
cls
call :header
set /p base=Enter base IP (e.g., 192.168.0): 
for /L %%i in (1,1,254) do (
    echo Pinging %%i...
    ping -n 1 -w 200 %base%.%%i | find "TTL=" && echo %base%.%%i >> scanned_range.txt
)
echo Results saved to scanned_range.txt
pause
goto main
