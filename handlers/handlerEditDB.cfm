<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
		<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
	</cfif>



<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editDB/editDatasource.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cfscript>
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	schemaPath = projectPath & "/.apptacular/schema";
	
	//Ensure that overwrites are respected.
	configPath = projectPath & "/.apptacular/config.xml";
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
