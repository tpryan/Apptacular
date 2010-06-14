<cfsetting showdebugoutput="FALSE" />
<cfparam name="url.type" type="string" default="generated" />
<cfparam name="url.fileCount" type="numeric" default="0" />
<cfparam name="url.dirCount" type="numeric" default="0" />
<cfparam name="url.seconds" type="numeric" default="0" />
<cfparam name="url.detail" type="string" default="" />
<cfparam name="url.message" type="string" default="" />

<cf_pageWrapper>
	<cfif FindNoCase("notanapplication", url.type)>
		<cfoutput><p>Application is not an Apptacular application. Before you can use this function you have to create the application using the RDS vew.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("notacfc", url.type)>
		<cfoutput><p>You can't edit this CFC's Apptacular metadata. This CFC is not an ORM CFC or a Service CFC for an ORM CFC. </p></cfoutput>				
	</cfif>
	<cfif FindNoCase("generated", url.type)>
		<cfoutput><p><strong>#fileCount#</strong> Files Generated in <strong>#seconds#</strong> seconds.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("locked", url.type)>
		<cfoutput><p>Application locked, unlock in the Application config to regenerate.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("purge", url.type)>
		<cfoutput>
			<p><strong>#fileCount# extraneous files deleted.</strong></p>
			<p><strong>#dirCount# empty directories deleted.</strong></p>
		</cfoutput>
	
	</cfif>
	<cfif FindNoCase("error", url.type)>
		<cfoutput>
			<br />
			<div class="alert">
				<h1>An Error has occured.</h1>
				<p><strong>Message:</strong>#url.message#</p>
				<p><strong>Details:</strong>#url.detail#</p>
			</div>
		</cfoutput>				
	</cfif>
</cf_pageWrapper>