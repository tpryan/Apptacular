<cfscript>
	shouldUpdate = application.update.shouldUpdate();
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
	messagesPath = getDirectoryFromPath(cgi.script_name) & "/update/confirm.cfm";
	confirmURL = baseURL & messagesPath;

</cfscript>



<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true">
	<ide url="#confirmURL#" > 
		<dialog width="655" height="600" />
	</ide> 
</response> 
</cfoutput>
