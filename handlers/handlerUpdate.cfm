<cfscript>
shouldUpdate = application.update.shouldUpdate();
baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;


</cfscript>
<cfif shouldUpdate>
		<cfscript>
			appFolder = ExpandPath('.');
			application.update.getLatestZip(appFolder);
			resultFile = appFolder & "/Apptacular.zip";
			
			if (FileExists("#appFolder#/Apptacular")){
				FileMove("#appFolder#/Apptacular", resultFile) ;
			}
			 
			apptacularPArentFolder = ExpandPath("../");
			writeLog(apptacularPArentFolder);	
		</cfscript>


		<cfzip action="unzip" destination="#apptacularPArentFolder#" file="#resultFile#" overwrite="true" />
		<cfscript>
		
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=update";
		messagesURL = baseURL & messagesPath & messagesOptions;
		ApplicationStop();
	</cfscript>
<cfelse>
	<cfscript>
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=noupdate";
		messagesURL = baseURL & messagesPath & messagesOptions;
	</cfscript>
</cfif>



<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true">
	<ide url="#messagesURL#" > 
		<dialog width="655" height="600" />
	</ide> 
</response> 
</cfoutput>
