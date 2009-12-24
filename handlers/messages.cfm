<cfsetting showdebugoutput="FALSE" />
<cfparam name="url.type" type="string" default="generated" />
<cfparam name="url.fileCount" type="numeric" default="0" />
<cfparam name="url.dirCount" type="numeric" default="0" />
<cfparam name="url.seconds" type="numeric" default="0" />


<cf_pageWrapper>
	<cfif FindNoCase("notanapplication", url.type)>
		<cfoutput><p>Application is not an Apptacular application. You have to create from the RDS vew first.</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("generated", url.type)>
		<cfoutput><p><strong>#fileCount#</strong> Files Generated in <strong>#seconds#</strong> seconds, even using Evaluate()</p></cfoutput>				
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
</cf_pageWrapper>