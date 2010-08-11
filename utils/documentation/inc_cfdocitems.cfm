<!--- Create the header --->
<cfdocumentitem type="header" evalatprint="true">
	<cf_pagewrapper> 
	<cfif (cfdocument.currentpagenumber % 2 eq 0)>
		<p class="header headereven">
	<cfelse>
		<p class="header headerodd">
	</cfif>
	Apptacular Documentation</p>
	</cf_pagewrapper>
</cfdocumentitem> 

<!--- Create the footer. --->
<cfdocumentitem type="footer" evalatprint="true">
	<cf_pagewrapper> 
	<cfif (cfdocument.currentpagenumber % 2 eq 0)>
		<p class="footer footereven">
	<cfelse>
		<p class="footer footerodd">
	</cfif>

	
	<cfoutput>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</p></cfoutput>
	
	</cf_pagewrapper> 
</cfdocumentitem> 