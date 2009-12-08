<cfsetting showdebugoutput="FALSE" />
<cfif not structKeyExists(form, "ideeventInfo")>
		<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
	</cfif>

<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "editConfig/editconfig.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cfscript>
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	configPath = projectPath & "/.apptacular/config.xml";
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#handlerURL#?configPath=#configPath#" > 
		<dialog width="655" height="600" /> 
	</ide> 
</response> 
</cfoutput>
