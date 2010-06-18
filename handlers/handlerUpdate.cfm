<cfscript>
	shouldUpdate = application.update.shouldUpdate();
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
	messagesPath = getDirectoryFromPath(cgi.script_name) & "/update/confirm.cfm";
	confirmURL = baseURL & messagesPath;

</cfscript>


<cf_ideWrapper messageURL="#confirmURL#" />
