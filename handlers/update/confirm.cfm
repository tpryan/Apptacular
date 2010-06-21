<cf_pageWrapper>
	
	<cfset isOnline = application.update.isOnline() />
	
	<cfif isOnline>
	
		<cfset shouldUpdate = application.update.shouldUpdate() />
	
		<cfif shouldUpdate>
		
			<cfoutput>
				<table id="updatetable">
					<tr><th>You are running version:</th><td>#application.version#</td></tr>
					<tr><th>The most current version online is:</th><td>#application.update.getLatestVersion()#</td></tr>
				</table>
			</cfoutput>
			<form action="update.cfm">
				<label for="config">Are you sure you want to update?</label>
				<input id="confirm" name="confirm" type="submit" value="Yes, I want to update!" />
			</form>
		<cfelse>
			<cfoutput><p>You are currently running at the latest version of Apptacular.</p></cfoutput>	
		</cfif>
	<cfelse>
		<cfoutput><p>Online updates are not available. Either you are offline, or there is a problem with the update site.</p></cfoutput>	
	</cfif>

</cf_pageWrapper>