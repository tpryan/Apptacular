<cfsetting showdebugoutput="FALSE" />

<cfscript>
	utils = New apptacular.handlers.cfc.utils.utils();
	cgiUtils = New apptacular.handlers.cfc.utils.cgiUtils(cgi);
	projectPath = application.builderHelper.getProjectPath();
	resourcePath = application.builderHelper.getResourcePath();
	configPath = utils.findConfig(projectPath,resourcePath);
	message = "";
	config = "apptacular.handlers.cfc.generators.cfapp.config";
	docHelper = new apptacular.handlers.cfc.utils.docHelper(config);
	configFileService = new apptacular.handlers.services.configFileService();
	configFileService.setConfigFile(configPath);	

	if (structKeyExists(form, "submit") && not FindNoCase("references", form.submit)){
		configFileService.setConfigs(form);
		configFileService.save();
		message = "Changes Saved";
	}	


</cfscript>	




<cf_pageWrapper>
	<cf_XMLConfigForm fileToEdit="#configPath#" configFileService = "#configFileService#" message="#message#" helper="#docHelper#" cfcreference="apptacular.handlers.cfc.generators.cfapp.config" />
</cf_pageWrapper>