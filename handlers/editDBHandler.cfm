<cfsetting showdebugoutput="FALSE" />
<!---<cfif not structKeyExists(form, "ideeventInfo")>
		<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
	</cfif>
--->
<cfscript>
	XMLDoc = xmlParse(ideeventInfo);
	projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	schemaPath = projectPath & "/.apptacular/schema";
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="http://#cgi.server_name#/apptacular/handlers/editDatasource.cfm?datasourcePath=#schemaPath#" > 
		<dialog width="655" height="600" /> 
	</ide> 
</response> 
</cfoutput>
