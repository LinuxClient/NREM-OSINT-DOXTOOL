NREM PROJECT - OSINT Tool
Overview
The NREM (Network Reconnaissance and Enumeration Method) Project is an OSINT (Open Source Intelligence) tool designed to perform various network scanning tasks. The tool is primarily built using batch scripting and offers functionalities like:

Scanning local networks for active IPs and Wi-Fi passwords.

Ping testing an IP address.

Scanning open ports on an IP.

Performing IP geolocation lookups.

Searching for social media accounts associated with a username.

Conducting intext/keyword searches on the web.

The tool is a work-in-progress and is primarily for educational purposes. Please use responsibly and adhere to all applicable laws and ethical standards when using this tool.

Features
Scan for Active IPs and Wi-Fi Passwords: Scans your local network to find active IPs and retrieves saved Wi-Fi passwords.

Ping IP Address: Allows you to ping a specified IP address to test connectivity.

Scan for Open Ports: Scans ports from 1 to 1024 on the specified IP to identify open ports.

IP Geolocation Lookup: Provides geolocation information (e.g., country, region, city) of a specified IP.

Search for Social Media Accounts: Searches for social media accounts related to a username on major platforms like Twitter, Instagram, TikTok, and Facebook.

Intext/Keyword Web Search: Conducts a Google search using the specified keyword(s).

Known Bugs & Issues
UI/Display Bugs: Some UI features may appear unorganized or broken due to compatibility issues with Windows command prompt and batch scripting limitations. We are working on improving the visual structure of the tool.

Wi-Fi Password Retrieval: The Wi-Fi password retrieval feature may not work on all systems due to different versions of Windows or system configurations. Ensure you have the required permissions (Administrator) to run this feature.

Geolocation Display: The geolocation output might not always be perfectly formatted and may require some manual inspection. This will be improved in future versions.

Scanning Delays: Scanning for active IPs and Wi-Fi passwords may take some time due to the nature of the network scan. We are working on optimizations to speed this up without compromising accuracy.

Instructions
How to Use:
Clone the repository or download the files to your computer.

Open a command prompt in the folder where the script files are stored.

Run the NREM.bat file.

Follow the on-screen prompts to use different features.

Features Available:
Type 1 to scan for active IPs and Wi-Fi passwords.

Type 2 to ping an IP address.

Type 3 to scan for open ports.

Type 4 for IP geolocation lookup.

Type 5 to search for social media accounts.

Type 6 to search intext on Google.

Requirements:
Windows Operating System (Windows 7/10/11)

Administrator privileges for some features (e.g., Wi-Fi password retrieval)

Notes:
This tool is designed for educational purposes only. Use responsibly and only on networks that you own or have explicit permission to scan.

Some features may not work as expected due to limitations in batch scripting or Windows system configurations. Always report bugs to help us improve the tool.

Contributing
Feel free to fork the repository and submit pull requests for any improvements or fixes. If you encounter any bugs or issues, please report them by opening an issue on this repository.

Disclaimer
This tool is intended for educational purposes only. Use it responsibly and ensure you are not violating any laws or infringing on the privacy of others. The author does not take any responsibility for any misuse of the tool. Always get explicit permission before scanning networks that do not belong to you.