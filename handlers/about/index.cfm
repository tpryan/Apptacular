<cf_pageWrapper>
<cfoutput>
<h1>About Apptacular</h1>
	<table>
		<tr><th><strong>Version</strong></th><td>#application.version#</td></tr>
		<tr><th><strong>Last Update Check</strong></th><td>#DateFormat(application.updatelastchecked, "mm/dd/yyyy")# #TimeFormat(application.updatelastchecked)#</td></tr>
		<tr><th><strong>Server Name</strong></th><td>#cgi.server_name#</td></tr>
		<tr><th><strong>ColdFusion Version</strong></th><td>#server.ColdFusion.productName# #server.ColdFusion.productLevel# #server.ColdFusion.productVersion#</td></tr>
		<tr><th><strong>OS Version</strong></th><td>#server.OS.name# #server.OS.version#</td></tr>
	</table>
	
</cfoutput>	
</cf_pageWrapper>