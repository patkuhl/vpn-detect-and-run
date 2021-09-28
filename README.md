# vpn-detection-folder-reconnection
Installs a Windows Task Scheduler task that, when a VPN connection to your domain is detected, will run the currently logged in user's logon script (which will include gpupdate).

Details
A script for Powershell App Deploy Toolkit to lookup the currently logged in user and their logon script, dump that into a new script and append gpupdate to the end, save it the user's docs folder, edit an xml file which is also saved to the docs folder, then register a Task Scheduler task with the data from the xml file that will run in the background, scanning the Event logs for a connection to your domain via VPN. When it does detect one, it will launch the newly modified logon batch script in the docs folder minimized, and when done will exit.


Notes

- Requires Windows (only tested on Windows 10 2004, but will more than likely work with other versions)
- An application deployment system (MECM/SCCM, PDQ, Lansweeper, etc.) is preferred, but not necessary for this to work, AFAIK
    - The SCCM-MECM-detection script is required for an Application in SCCM/MECM, otherwise, it will fail
- The computer must already be connected to your domain (normal or VPN connection) to run this installer. This is because it utilizes Powershell's adsisearcher to lookup the samaccountname and scriptpath of the logged in user at runtime.

Installation Instructions

1. Copy the PSADT code into your Deploy-Application.ps1 file, in the Installation section
2. Copy the xml and txt files into the Files directory in your appplication's PSADT folder
3. copy the application detection script into the custom script window in the MECM/SCCM Application's Deployment Type properties Detection tab
