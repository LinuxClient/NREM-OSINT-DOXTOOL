PREVIEW!


![Screenshot 2025-05-06 212902](https://github.com/user-attachments/assets/174ecace-119f-4427-8822-0d3523eec2da)





NREM-OSINT-DOXTOOL
THIS TOOL IS USED FOR OSINT AND DOXXING PURPOSES. FOR EDUCATIONAL PURPOSES ONLY.

NREM PROJECT - OSINT Tool Overview
The NREM (Network Reconnaissance and Enumeration Method) Project is an OSINT (Open Source Intelligence) tool designed to perform a wide variety of network scanning tasks. Built primarily using batch scripting, NREM v1.5 has expanded functionality to include network reconnaissance, email and domain validation, file hash checks, and new advanced features such as reverse image searches, disposable email checking, and much more.

The tool aims to provide a comprehensive suite of OSINT features while being lightweight and easily accessible.

New Features in v1.5
Expanded OSINT Functionalities (Options 22-31):

Option 22: Dark Web Email Search (Ahmia) – Search for emails on the dark web.

Option 23: Reverse Image Search – Upload or paste image URLs for reverse search via Google and Yandex.

Option 24: Disposable Email Checker – Identifies disposable email addresses.

Option 25: MAC Address Vendor Lookup – Lookup vendor information for a given MAC address.

Option 26: File Hash Lookup (VirusTotal) – Hash a file and check it against VirusTotal for known threats.

Option 27: Website Screenshot – Generate a screenshot of a website.

Option 28: robots.txt & Sitemap Parser – Fetch and display robots.txt and sitemap.xml from a domain.

Option 29: Email Syntax & MX Validator – Validate email syntax and perform MX record lookup.

Option 30: Public Exploit Search – Search for exploits for software/CVE/products using Exploit-DB.

Option 31: Typosquatting Domain Scanner – Generate typosquatting domain variants for a target domain.

UI and Input Handling Improvements:

Input sanitization to handle special characters and spaces more effectively in user inputs.

Enhanced error logging with timestamped log files and more informative feedback for failed tools or checks.

Bug Fixes:

Fixed duplicate opt0 label causing premature exit behavior.

Improved handling of missing files (robots.txt and sitemap.xml), displaying clearer messages when files aren't found.

Enhanced email validation and MX record lookup functionality.

Improved handling of curl errors by checking if curl is installed.

Core Features (v1.5)
Scan for Active IPs and Wi-Fi Passwords: Scans local networks for active IPs and retrieves saved Wi-Fi passwords (with administrator permissions).

Ping IP Address: Tests connectivity to a specified IP address using ping.

Scan for Open Ports: Scans ports (1–1024) on a specified IP address to identify open ports.

IP Geolocation Lookup: Provides geographical details (country, region, city) of a specified IP.

Search for Social Media Accounts: Searches for social media accounts associated with a given username across platforms like Twitter, Instagram, TikTok, and Facebook.

Intext/Keyword Web Search: Executes Google search queries based on user-provided keywords.

Reverse Image Search: Searches for similar images on Google and Yandex (new in v1.5).

Disposable Email Checker: Identifies disposable email addresses (new in v1.5).

MAC Address Vendor Lookup: Identifies the vendor associated with a given MAC address (new in v1.5).

File Hash Lookup: Checks file hashes against VirusTotal for known threats (new in v1.5).

Website Screenshot Generator: Captures a screenshot of a given website (new in v1.5).

robots.txt & Sitemap Parser: Retrieves and displays the contents of robots.txt and sitemap.xml from a domain (new in v1.5).

Email Syntax & MX Validator: Validates email format and performs MX record lookups (new in v1.5).

Public Exploit Search: Searches Exploit-DB for known exploits related to a specific product or CVE (new in v1.5).

Typosquatting Domain Scanner: Generates and checks potential typosquatting domains for a target domain (new in v1.5).

Known Bugs & Issues
UI/Display Bugs: Some UI features may appear disorganized or broken in the Windows command prompt due to batch scripting limitations. Visual structure improvements are planned for future versions.

Wi-Fi Password Retrieval: This feature may not work on all systems due to different Windows versions or configurations. Ensure that you have the necessary permissions (administrator access).

Geolocation Display: The geolocation results may not always be perfectly formatted, requiring occasional manual inspection.

Scanning Delays: Scanning for active IPs or Wi-Fi passwords can take time due to network scan size. We are optimizing these processes to speed up scans without compromising accuracy.

Exploit Search: Exploit searches may occasionally fail to return results for certain CVEs or software versions. Future updates will improve the search functionality.

How to Use
Download the Tool: Clone the repository or download the NREM.bat and supporting files to your computer.

Run the Script: Open a command prompt in the directory where the tool is located.

Start the Tool: Run NREM.bat.

Follow Prompts: The tool will display a menu with numbered options. Choose a feature by entering the corresponding number.

Available Features:

Type 1 to scan for active IPs and Wi-Fi passwords.

Type 2 to ping an IP address.

Type 3 to scan for open ports.

Type 4 for IP geolocation lookup.

Type 5 to search for social media accounts.

Type 6 to search for keywords on Google.

Type 22 to search for emails on the dark web.

Type 23 to perform reverse image search.

Type 24 to check for disposable email addresses.

Type 25 to look up MAC address vendors.

Type 26 to perform file hash lookups.

Type 27 to generate a website screenshot.

Type 28 to parse robots.txt and sitemap.xml.

Type 29 to validate email syntax and MX records.

Type 30 to search for exploits.

Type 31 to scan for typosquatting domains.

Requirements
Windows Operating System: Compatible with Windows 7, 10, and 11.

Administrator Privileges: Required for features like Wi-Fi password retrieval.

External Tools: Some functionality relies on external tools such as curl, whois, exiftool, and python (for future features). Make sure these tools are installed on your system.

Notes
This tool is designed for educational purposes only. Always use it responsibly and ensure that you have explicit permission to scan networks or systems that do not belong to you.

Some features may not work due to batch scripting limitations or system configurations.

Report bugs and issues to help improve the tool.

Contributing
Feel free to fork this repository and submit pull requests for any improvements, fixes, or additional features. If you encounter any bugs or issues, please report them by opening an issue in this repository.

Disclaimer
This tool is intended for educational purposes only. Use it responsibly and make sure you are not violating any laws or infringing on others' privacy. The author does not take responsibility for any misuse of the tool. Always ensure you have explicit permission before scanning networks or devices that you do not own
