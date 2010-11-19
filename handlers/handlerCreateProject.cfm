
<cfscript>

	cgiUtils = New cfc.utils.cgiUtils(cgi);
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
		projectname = XMLDoc.event.ide.eventinfo.XMLAttributes.projectname; 
	}
	else{
		projectPath = XMLDoc.event.ide.projectview.resource.XmlAttributes['path'];
		projectname = XMLDoc.event.ide.projectview.XMLAttributes.projectname; 
	}
	
	
	handlerURL = baseURL & handlerPath;
</cfscript>


<cf_ideWrapper messageURL="#handlerURL#?projectPath=#projectPath#&amp;projectname=#projectname#" />


