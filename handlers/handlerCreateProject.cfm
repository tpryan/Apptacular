
<cfscript>

	cgiUtils = New cfc.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();

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
		projectPath = XMLDoc.event.ide.projectview.resource.XmlAttributes['path'];
	}
	
	
	handlerURL = baseURL & handlerPath;
</cfscript>


<cf_ideWrapper messageURL="#handlerURL#?projectPath=#projectPath#" />


