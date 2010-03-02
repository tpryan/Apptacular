<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>



<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editDB/editDatasource.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cfscript>
	utils = New cfc.utils();
	XMLDoc = xmlParse(ideeventInfo);
	
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	resourcePath = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
	configPath = utils.findConfig(projectPath,resourcePath);
	schemaPath = utils.findConfig(projectPath,resourcePath, "schema");
	
	
	//projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	//schemaPath = projectPath & "/.apptacular/schema";
	
	//Ensure that overwrites are respected.
	//configPath = projectPath & "/.apptacular/config.xml";
</cfscript>


<cfif not FileExists(configPath)>

	<cfscript>
		baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notanapplication";
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
	<cfabort> 
</cfif>

<cfscript>
	configXML = xmlParse(FileRead(configPath));
	configXML.config.OverwriteDataModel.XMLText = TRUE;
	FileWrite(configPath, configXML);
</cfscript>


<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#handlerURL#?datasourcePath=#schemaPath#" > 
		<dialog width="655" height="700" /> 
	</ide> 
</response> 
</cfoutput>
