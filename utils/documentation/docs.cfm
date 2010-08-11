<h1>Apptacular Documentation</h1>
<cfinclude template="doc_hg_documentation.cfm" />


<cfif not FileExists(ExpandPath('.') & "doc_cg_ref.cfm")>
	<cfinclude template="createConfigReference.cfm"/>
</cfif>

<cfinclude template="doc_cg_ref.cfm"/>

