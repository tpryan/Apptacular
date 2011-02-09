<cfsetting showdebugoutput="FALSE" />

<cfif structKeyExists(form, "ideeventinfo")>
	<cfset builderHelper = new cfc.utils.builderHelper(form.ideEventInfo) />
	<cfset application.BuilderHelper = builderHelper />
<cfelse>
	<cfset BuilderHelper = application.builderHelper />	 
</cfif>	

<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "purge/showlist.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath />
<cfscript>
	utils = New cfc.utils.utils();
	cgiUtils = New cfc.utils.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	
	handlerPath = getDirectoryFromPath(cgi.script_name) & "purge/showlist.cfm" ;
	handlerURL = baseURL & handlerPath;
	
	projectPath = builderHelper.getProjectPath();
	resourcePath = builderHelper.getResourcePath();
	configPath = utils.findConfig(projectPath,resourcePath);
</cfscript>

<cfif not FileExists(configPath)>

	<cfscript>
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notanapplication";
		messagesURL = baseURL  & messagesPath & messagesOptions;
	
	</cfscript>
	
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<cfset appRoot = utils.findAppRoot(projectPath,resourcePath) />

<cf_ideWrapper messageURL="#handlerURL#" ideVersion="#builderHelper.getCFBuilderVersion()#" />
