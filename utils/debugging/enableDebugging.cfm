<cfparam name="url.username" type="string" default="admin" /> 
<cfparam name="url.password" type="string" default="admin" /> 

<cfscript>
	admin= New CFIDE.adminapi.administrator();
	admin.login(url.password, url.username);
	debugging = new CFIDE.adminapi.debugging();
	debugging.setDebugProperty("enableDebug", true);
	debugging.setDebugProperty("enableRobustExceptions", true);
</cfscript>