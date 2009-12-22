<cfsetting showdebugoutput="FALSE" />
<cfset configPath= url.configPath />

<cf_pageWrapper>
	<cf_XMLForm fileToEdit="#configPath#" message="" cfcreference="apptacular.handlers.generators.cfapp.config" />
</cf_pageWrapper>