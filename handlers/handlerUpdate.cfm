<cfscript>
	shouldUpdate = application.update.shouldUpdate();
	cgiUtils = New cfc.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	messagesPath = getDirectoryFromPath(cgi.script_name) & "/update/confirm.cfm";
	confirmURL = baseURL & messagesPath;

</cfscript>


<cf_ideWrapper messageURL="#confirmURL#" />
