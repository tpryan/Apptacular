<cfset docPath = expandPath('../docs') />
<cfif not directoryExists(docPath)>
	<cfset directoryCreate(docPath) />
</cfif>


 


<cfdocument filename="#docPath#/documentation.pdf" format="PDF" overwrite="true" fontembed="true">
	<cf_pagewrapper>
		<cfinclude template="docs.cfm" />
	</cf_pagewrapper>
	
	<cfinclude template="inc_cfdocitems.cfm" />
</cfdocument> 

<cfdocument filename="#docPath#/releasenotes.pdf" format="PDF" overwrite="true" fontembed="true">
	<cf_pagewrapper>
		<cfinclude template="releasenotes.cfm" />
	</cf_pagewrapper>
	
	<cfinclude template="inc_cfdocitems.cfm" />
</cfdocument> 

Done.