<cfsetting showdebugoutput="FALSE" />
<cfset configPath= url.configPath />
<cfset config = new apptacular.handlers.generators.cfapp.config(ExpandPath('.'),"apptacular") />
<cfset configHelper = new apptacular.handlers.cfc.utils.configHelper(config) />


<cf_pageWrapper>
	<cf_XMLForm fileToEdit="#configPath#" message="" helper="#configHelper#" cfcreference="apptacular.handlers.generators.cfapp.config" />
</cf_pageWrapper>