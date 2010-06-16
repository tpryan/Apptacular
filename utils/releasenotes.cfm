<h1>Release Notes</h1>
<cfinclude template="doc_hg_releasenotes.cfm" />


<cfif not FileExists(ExpandPath('.') & "doc_cg_changes.cfm")>
	<cfinclude template="createChanges.cfm"/>
</cfif>

<cfinclude template="doc_cg_changes.cfm" />