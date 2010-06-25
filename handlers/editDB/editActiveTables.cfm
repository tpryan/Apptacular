<cfsetting showdebugoutput="FALSE" />

<cfif StructKeyExists(url, "datasourcePath")>
	<cfset schemaPath= url.datasourcePath />
</cfif>

<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
	tables = getDirectoryInfo(schemaPath);
	message = "";
</cfscript>



<cfif structkeyExists(form, "submit")>
	
	<cfquery name="excludedtables" dbtype="query">
		SELECT 	*
		FROM 	tables
		WHERE	directory not in (#ListQualify(form.file,"'")#)
		AND		LOWER(WIRED) = '#Lcase(true)#'  
	</cfquery>
	
	<cfquery name="includedtables" dbtype="query">
		SELECT 	*
		FROM 	tables
		WHERE	directory in (#ListQualify(form.file,"'")#)
		AND		LOWER(WIRED) != '#Lcase(true)#'  
	</cfquery>
	
	<!--- wire up included tables. --->
	<cfloop query="includedtables">
		<cfset rawFile = fileRead(fullpath) />
		<cfset XML = xmlParse(rawFile) />
		<cfset XML.table.createInterface.XMLText = true />
		<cfset fileWrite(fullpath,XML) />
	</cfloop>
	
	<!--- wire up included tables. --->
	<cfloop query="excludedtables">
		<cfset rawFile = fileRead(fullpath) />
		<cfset XML = xmlParse(rawFile) />
		<cfset XML.table.createInterface.XMLText = false />
		<cfset fileWrite(fullpath,XML) />
	</cfloop>
	
	<cfset message = "Your changes have been made." />
	<cfset tables = getDirectoryInfo(schemaPath) />
</cfif>




<cf_pageWrapper>

<h2>Activate/Deactivate Tables</h2>

<cfif len(message)>
	<cfoutput><p class="alert">#message#</p></cfoutput>
</cfif>

<cfoutput><form action="#cgi.script_name#?datasourcePath=#datasourcePath#" method="post" name="fileForm"></cfoutput>

<input type="button" name="CheckAll" value="Check All" onClick="checkAll(document.fileForm.file)">
<input type="button" name="UnCheckAll" value="Uncheck All" onClick="uncheckAll(document.fileForm.file)">



<ul>
<cfoutput query="tables">
	<li>
		<input type="checkbox" name="file" value="#directory#" <cfif wired>checked="checked"</cfif> <cfif isJoin>disabled="disabled"</cfif> />
		<label for="">#ListLast(directory, FS)# <cfif isJoin>(Join Table)</cfif></label>
	</li>
	
</cfoutput>
</ul>
<input name="submit" type="submit" value="Save" />
</form>

</cf_pageWrapper>

<cffunction name="getDirectoryInfo" output="FALSE" access="public"  returntype="query" hint="" >
	<cfargument name="schemaPath" type="string" required="TRUE" hint="" />

	<cfset var tables = "" />
	<cfset var files = DirectoryList(arguments.schemaPath, true, "query", "*.xml") />

	<cfquery name="tables" dbtype="query">
		SELECT 	*, directory + '#FS#' + name as fullpath
		FROM 	files
		WHERE	name = '_table.xml'
	</cfquery>
	
	<cfset var wireArray = arrayNew(1) />
	<cfset var joinArray = arrayNew(1) />
	<cfloop query="tables">
		<cfset rawFile = fileRead(directory & FS & name) />
		<cfset XML = xmlParse(rawFile) />
		<cfset wireArray[currentRow] = XML.table.createInterface.XMLText />
		<cfset joinArray[currentRow] = XML.table.isJoinTable.XMLText />
	</cfloop>
	<cfset queryAddColumn(tables,"wired","varchar",wireArray) />
	<cfset queryAddColumn(tables,"isJoin","varchar",joinArray) />


	<cfreturn tables />
</cffunction>