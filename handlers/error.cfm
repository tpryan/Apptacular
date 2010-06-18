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

<cfif FindNoCase("Jakarta",cgi.HTTP_USER_AGENT)>
	<cfset messagesURL = baseURL  & messagesPath & XMLFormat(messagesOptions) />
	<cf_ideWrapper messageURL="#messagesURL#" />
<cfelse>
	<cflocation url="#messagesURL#" addtoken="false" />
</cfif>

