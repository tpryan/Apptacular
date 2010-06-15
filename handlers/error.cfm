<cfscript>
	writeLog("Apptacular Error");
	error = exception;
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
	messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
	messagesOptions = "?type=error&detail=#error.Detail#&message=#error.Message#";
	messagesURL = baseURL  & messagesPath & messagesOptions;
	writeLog("Message: #error.message#");
	writeLog("Detail: #error.Detail#");
	writeLog("Error URL: #messagesURL#");
</cfscript>

<cflocation url="#messagesURL#" addtoken="false" />
<!---
<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true">
	<ide url="#messagesURL#" > 
		<dialog width="655" height="600" />
	</ide> 
</response> 
</cfoutput>--->
