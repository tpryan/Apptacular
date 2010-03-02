<cfsetting showdebugoutput="FALSE" />
<cfinclude template="inc_CreateListOfExtra.cfm" />



<cfloop list="#form.filesToDelete#" index="fileToDelete">
	<cffile action="delete" file="#fileToDelete#" />
</cfloop>


<!--- Get the empty directories. --->
<cfset emptyDirs = utils.getEmptyDirectories(appRoot) />


<!--- Delete Empty Folders  --->
<cfloop query="emptyDirs">
	<cfdirectory action="delete" directory="#path#" />
</cfloop>

<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(appRoot,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<cfhttp url="#script_Path#" timeout="0" />

<cf_pageWrapper>
	<cfoutput>
    	<h1>Prune Results</h1>
		<p><strong>#ListLen(form.filesToDelete)# extraneous files deleted.</strong></p>
		<h2>#approot#</h2>
		<ul>
		<cfloop list="#form.filesToDelete#" index="fileToDelete">
			<li>..#Replace(fileToDelete, approot, "", "ALL")#</li>
		</cfloop>
		</ul>
		<p><strong>#emptyDirs.recordCount# empty directories deleted.</strong></p>
		<h2>#approot#</h2>
		<ul>
		<cfloop query="emptyDirs">
			<li>..#Replace(emptyDirs.path[emptyDirs.currentRow], approot, "", "ALL")#</li>
		</cfloop>
		</ul>
    </cfoutput>
</cf_pageWrapper>

	
