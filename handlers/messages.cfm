<cfsetting showdebugoutput="FALSE" />
<cfparam name="url.type" type="string" default="generated" />
<cfparam name="url.fileCount" type="numeric" default="0" />
<cfparam name="url.dirCount" type="numeric" default="0" />
<cfparam name="url.seconds" type="numeric" default="0" />


<cf_pageWrapper>
	<cfif FindNoCase("generated", url.type)>
		<cfoutput><p><strong>#fileCount#</strong> Files Generated in <strong>#seconds#</strong> seconds, even using Evaluate()</p></cfoutput>				
	</cfif>
	<cfif FindNoCase("purge", url.type)>
		<cfoutput>
			<p><strong>#fileCount# extraneous files deleted.</strong></p>
			<p><strong>#dirCount# empty directories deleted.</strong></p>
		</cfoutput>
	
	</cfif>
</cf_pageWrapper>