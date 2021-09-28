# vpn-detection-folder-reconnection
Installs a Task Scheduler task that, when a VPN connection to your domain is detected, will run the currently logged in user's logon script and run gpupdate.

Details
A script for Powershell App Deploy Toolkit to lookup the currently logged in user and their logon script, dump that into a new script and append gpupdate to the end, save it the user's docs folder, edit an xml file which is also saved to the docs folder, then register a Task Scheduler task with the data from the xml file that will run in the background, scanning the Event logs for a connection to your domain via VPN. when it does detect one, it will launch the logon batch script in the docs folder minimized, and when done will exit.


Installation Instructions

1. Copy the PSADT code into your Deploy-Application.ps1 file, in the Installation section
2. Copy the xml and txt files into the Files directory in your appplication's PSADT folder
3. copy the application detection script into the custom script window in the MECM/SCCM Application's Deployment Type properties Detection tab
