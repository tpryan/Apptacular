<cfsetting showdebugoutput="FALSE" />
<cfset path = urlDecode(url.path) />

<cfset message = "" />

<cfscript>
	variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
</cfscript>

<cf_pageWrapper>


<cfset directory = getDirectoryFromPath(path) />
<cfoutput>
	<p class="breadcrumb">&larr;<a href="editTable.cfm?path=#URLEncodedFormat(directory)#">Edit table: <strong>#ListLast(directory, FS)#</strong></a></p>
</cfoutput>
<cf_XMLForm fileToEdit="#path#" message="#message#" />

</cf_pageWrapper>
