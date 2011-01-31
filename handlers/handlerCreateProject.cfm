
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
	
	if (StructKeyExists(xmldoc.event.ide.XMLAttributes, "version")){
	    ideVersion = xmldoc.event.ide.XMLAttributes.version;
	}
	else{
		ideVersion = 1.0;
	}    
	
	
	handlerURL = baseURL & handlerPath;
</cfscript>




<cf_ideWrapper messageURL="#handlerURL#?projectPath=#projectPath#&amp;projectname=#projectname#&amp;ideVersion=#ideVersion#" ideVersion="#ideVersion#" />


