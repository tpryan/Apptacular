
<cfscript>

	if (application.rds.rememberMe){
		handlerPath = getDirectoryFromPath(cgi.script_name) & "createProject/presentdatasources.cfm";
	}
	else{
		handlerPath = getDirectoryFromPath(cgi.script_name) & "createProject/login.cfm";
	}
	
	XMLDoc = xmlParse(ideeventInfo);
	
	if (structKeyExists(XMLDoc.event.ide, "eventinfo")){
		projectPath = XMLDoc.event.ide.eventinfo.XMLAttributes.projectlocation;
	}
	else{
		projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	}
	
	
	handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath;
</cfscript>


<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#handlerURL#?projectPath=#projectPath#" > 
		<dialog width="655" height="600" /> 
	</ide> 
</response> 
</cfoutput>

