<cfsetting showdebugoutput="FALSE" />
<cfset configPath= url.configPath />
<cfset config = "apptacular.handlers.generators.cfapp.config" />
<cfset docHelper = new apptacular.handlers.cfc.utils.docHelper(config) />


<cf_pageWrapper>
	<cf_XMLForm fileToEdit="#configPath#" message="" helper="#docHelper#" cfcreference="apptacular.handlers.generators.cfapp.config" />
</cf_pageWrapper>