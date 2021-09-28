
		#Copy the code below into your Deploy-Application.ps1 file, in the section labeled "<Perform Installation tasks here>"
		
		
		## <Perform Installation tasks here>

		#populate variables. 
			#CHANGE $domainscriptpath and $xmlDoc.task.registrationinfo.author to use your domain. 
			#$genericscriptname can be changed, but must also be changed in the xml file
		$loggedindomainuser = (Get-Process Explorer -IncludeUsername | Where-Object { $_.Username -notlike "*SYSTEM" }).Username
		$loggedinusername = $loggedindomainuser.split('\')[1]
		$userdocpath = "C:\Users\$loggedinusername\Documents"
		$genericscriptname = "Connect to Servers.bat"
		$domainscriptpath = "\\example.com\SYSVOL\example.com\scripts"
		$userscriptpath = ([adsisearcher]"(samaccountname=$loggedinusername)").FindOne().Properties['scriptpath'] 
		$userxmldocpath = "map drives if connected to vpn.xml"
		$xmldocstring = '/c start /min' + ' "connect-to-servers" ' + '"' + "$userdocpath\$genericscriptname" + '"' + ' ^' + '& exit'

		#copy the logon script from your domain's sysvol folder to the user's docs folder and append gpupdate to it
		If (!(Test-Path -Path "$userdocpath\$userscriptpath" -PathType leaf))
		{
			Copy-Item "$domainscriptpath\$userscriptpath" -Destination "$userdocpath"
			Move-Item -Path "$userdocpath\$userscriptpath" -Destination "$userdocpath\$genericscriptname"
			Add-Content -Path "$userdocpath\$genericscriptname" -Value "`r`n"
			Add-Content -Path "$userdocpath\$genericscriptname" -Value "gpupdate /force"
		}

		#modify the xml file, changing the author and the arguments fields
		If (!(Test-Path -Path "$userdocpath\$userxmldocpath" -PathType leaf))
		{
			[xml]$xmlDoc = Get-Content "$dirFiles\map drives if connected to vpn.xml"
			$xmlDoc.task.registrationinfo.author = "EXAMPLEDOMAIN\$loggedinusername"
			$xmlDoc.task.actions.exec.arguments = $xmldocstring
			$xmlDoc.Save("$userdocpath\$userxmldocpath")
		}

		#register a scheduled task for the logged in user using the xml file
		$userdocpath = "C:\Users\$loggedinusername\Documents"
		$userxmldocpath = "map drives if connected to vpn.xml"

		If (!(Get-ScheduledTask -TaskName "map drives if connected to vpn - $loggedinusername"))
		{
			If ((Test-Path -Path "$userdocpath\$userxmldocpath" -PathType leaf))
			{
				Register-ScheduledTask -Xml (get-content "$userdocpath\$userxmldocpath" | out-string) -TaskName "map drives if connected to vpn - $loggedinusername" -User $loggedinusername
			}
		}

		#copy the text file for SCCM/MECM application detection
		If (!(Test-Path -Path "$userdocpath\VPNDetectionTaskInstalled.txt" -PathType leaf))
		{
			Copy-Item "$dirFiles\VPNDetectionTaskInstalled.txt" -Destination "$userdocpath"
		}