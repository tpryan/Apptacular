<cfsetting showdebugoutput="FALSE" />
<cfparam name="form.ideVersion" default="1.0" type="any" />


<cfif structKeyExists(form, "ideeventinfo")>
	<cfset builderHelper = new cfc.utils.builderHelper(form.ideEventInfo) />
	<cfset application.BuilderHelper = builderHelper />
<cfelse>
	<cfset BuilderHelper = application.builderHelper />	 
</cfif>	



<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editDB/editDatasource.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath />

<cfscript>
	utils = New cfc.utils.utils();
	cgiUtils = New cfc.utils.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	projectPath = BuilderHelper.getProjectPath();
	resourcePath = BuilderHelper.getResourcePath();
	configPath = utils.findConfig(projectPath,resourcePath);
	schemaPath = utils.findConfig(projectPath,resourcePath, "schema");
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

<cfscript>
	configXML = xmlParse(FileRead(configPath));
	configXML.config.OverwriteDataModel.XMLText = TRUE;
	FileWrite(configPath, configXML);
</cfscript>

<cf_ideWrapper messageURL="#handlerURL#" ideVersion="#builderHelper.getCFBuilderVersion()#" /> 
