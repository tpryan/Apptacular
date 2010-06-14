<cfscript>
	error = exception;
		baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=error&amp;detail=#error.Detail#&amp;message=#error.Message#";
		messagesURL = baseURL  & messagesPath & messagesOptions;

</cfscript>


<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true">
	<ide url="#messagesURL#" > 
		<dialog width="655" height="600" />
	</ide> 
</response> 
</cfoutput>
