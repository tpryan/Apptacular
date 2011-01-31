<cfsetting showdebugoutput="FALSE" />
<cfset configPath= url.configPath />
<cfset message = "" />
<cfset config = "apptacular.handlers.cfc.generators.cfapp.config" />
<cfset docHelper = new apptacular.handlers.cfc.utils.docHelper(config) />
<cfset configFileService = new apptacular.handlers.services.configFileService() />
<cfset configFileService.setConfigFile(url.configPath) />

<cfif structKeyExists(form, "submit") and not FindNoCase("references", form.submit)>
		
	<cfset configFileService.setConfigs(form) />
	<cfset configFileService.save() />

	<cfset message = "Changes Saved" />
</cfif>


<cf_pageWrapper>
	<cf_XMLConfigForm fileToEdit="#configPath#" configFileService = "#configFileService#" message="#message#" helper="#docHelper#" cfcreference="apptacular.handlers.cfc.generators.cfapp.config" />
</cf_pageWrapper>