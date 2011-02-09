<cfsetting showdebugoutput="FALSE" />


<cfinclude template="inc_CreateListOfExtra.cfm" />
<cfset approot = builderHelper.getProjectPath() />



<cf_pageWrapper>
	<cfif extrafilesList.recordCount gt 0>

	<h1>Extra Files</h1>
	<cfoutput>
	<h2>#approot#</h2>
	<form action="deleteProcess.cfm?appRoot=#appRoot#" method="post" name="deleteForm">
	<cfif extrafilesList.RecordCount gt 1>
		<input type="button" name="CheckAll" value="Check All" onClick="checkAll(document.deleteForm.filesToDelete)">
		<input type="button" name="UnCheckAll" value="Uncheck All" onClick="uncheckAll(document.deleteForm.filesToDelete)">
	</cfif>
	</cfoutput>
	<ul>
	<cfoutput query="extrafilesList">
		<li><label><input name="filesToDelete" type="checkbox" value="#path#" />
		..#ReplaceNoCase(path, appRoot, "", "all")#</label></li>
	</cfoutput>
	</ul>
	
	<input name="submit" type="submit" value="Delete" /> 
	</form>
	<cfelse>
	<h1>No Extra Files</h1>
	</cfif>
	
</cf_pageWrapper>
	
