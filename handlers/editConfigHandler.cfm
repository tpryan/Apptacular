<cfsetting showdebugoutput="FALSE" />
<!---<cfif not structKeyExists(form, "ideeventInfo")>
		<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
	</cfif>
--->
<cfscript>
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	configPath = projectPath & "/.apptacular/config.xml";
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="http://#cgi.server_name#/apptacular/handlers/editconfig.cfm?configPath=#configPath#" > 
		<dialog width="455" height="600" /> 
	</ide> 
</response> 
</cfoutput>
