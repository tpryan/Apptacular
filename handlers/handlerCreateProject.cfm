
<cfscript>

	cgiUtils = New cfc.utils.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	builderHelper = new cfc.utils.builderHelper(ideeventInfo);
	application.builderHelper = builderHelper;

	if (application.rds.rememberMe){
		handlerPath = getDirectoryFromPath(cgi.script_name) & "createProject/presentdatasources.cfm";
	}
	else{
		handlerPath = getDirectoryFromPath(cgi.script_name) & "createProject/login.cfm";
	}
	
	
	
	ideVersion = builderHelper.getCFBuilderVersion(); 
	
	
	handlerURL = baseURL & handlerPath;
</cfscript>




<cf_ideWrapper messageURL="#handlerURL#" ideVersion="#ideVersion#" />


