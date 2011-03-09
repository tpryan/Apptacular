<cfsetting showdebugoutput="FALSE" />
<cfparam name="url.type" type="string" default="generated" />
<cfparam name="url.fileCount" type="numeric" default="0" />
<cfparam name="url.dirCount" type="numeric" default="0" />
<cfparam name="url.seconds" type="numeric" default="0" />
<cfparam name="url.detail" type="string" default="" />
<cfparam name="url.message" type="string" default="" />

<cfif FindNoCase("error", url.type) OR  
	FindNoCase("notanapplication", url.type) OR 
	CompareNoCase("corruptconfig", url.type) eq 0>
	<cfset showToolbar = false />
<cfelse>
	<cfset showToolbar = true />
</cfif>

<cf_pageWrapper showToolbar="#showToolbar#">
	<cfif FindNoCase("generated", url.type)>
		<h1>Success</h1>
		<cfoutput><p><strong>#fileCount#</strong> Files Generated in <strong>#seconds#</strong> seconds.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("notanapplication", url.type)>
		<h1>Error</h1>
		<cfoutput><p>Application is not an Apptacular application, or the configuration is corrupt. Before you can use this function you have to create the application using the RDS vew.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("notacfc", url.type)>
		<h1>Error</h1>
		<cfoutput><p>You can't edit this CFC's Apptacular metadata. This CFC is not an ORM CFC or a Service CFC for an ORM CFC. </p></cfoutput>				
	</cfif>
	<cfif FindNoCase("locked", url.type)>
		<h1>Locked</h1>
		<cfoutput><p>Application locked, unlock in the Application config to regenerate.</p></cfoutput>				
	</cfif>
	<cfif CompareNoCase("noupdate", url.type) eq 0>
		<h1>Upgrade not required</h1>
		<cfoutput><p>You are currently running at the latest version of Apptacular.</p></cfoutput>				
	</cfif>
	<cfif CompareNoCase("update", url.type) eq 0>
		<h1>Upgraded</h1>
		<cfoutput><p>Apptacular has been updated to version #application.version#</p></cfoutput>				
	</cfif>
	<cfif CompareNoCase("corruptconfig", url.type) eq 0>
		<h1>Error</h1>
		<cfoutput><p>Configuration files are corrupt. Check that you haven't deleted the contents of the .apptacular folder in your project root. 
			Rerunning "Create Application" might be necessary.
		</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("purge", url.type)>
		<h1>Files deleted</h1>
		<cfoutput>
			<p><strong>#fileCount# extraneous files deleted.</strong></p>
			<p><strong>#dirCount# empty directories deleted.</strong></p>
		</cfoutput>
	
	</cfif>
	<cfif FindNoCase("error", url.type)>
		<cfoutput>
			<h1>Error</h1>
			<div class="alert">
				<h1>An Error has occured.</h1>
				<p><strong>Message:</strong>#url.message#</p>
				<p><strong>Details:</strong>#url.detail#</p>
			</div>
		</cfoutput>				
	</cfif>
</cf_pageWrapper>