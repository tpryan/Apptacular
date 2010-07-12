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
	
	errorDir = ExpandPath('./logs');
	errorFile = DateFormat(now(), "yyyy-mm-dd") & "_" & timeFormat(now(), "hh-mm-ss-l") & ".html";
	if (not DirectoryExists(errorDir)){
		DirectoryCreate(errorDir);
	}
	writeDump(var=error,output= errorDir & "/" & errorFile);
	
</cfscript>
<cfif FindNoCase("Jakarta",cgi.HTTP_USER_AGENT)>
	<cfset messagesURL = baseURL  & messagesPath & XMLFormat(messagesOptions) />
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort>
<cfelse>
	<cflocation url="#messagesURL#" addtoken="false" />
</cfif>

