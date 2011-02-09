<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "about/index.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath />

<cfif structKeyExists(form, "ideeventinfo")>
	<cfset builderHelper = new cfc.utils.builderHelper(form.ideEventInfo) />
	
	<cfif not structKeyExists(application, "builderHelper")>
		<cfset application.BuilderHelper = builderHelper />
	</cfif>	 
</cfif>	


<cf_ideWrapper messageURL="#handlerURL#" />