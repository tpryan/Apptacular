<cfcomponent>

	<cfscript>	
	
	public function init(){
    	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
    	return This;
    }
	
	public string function findCFCPathFromFilePath(string path){
		var results = "";
		var webroot = ExpandPath("/");
		results = replace(arguments.path, webroot, "", "one");
		results = replace(results, "/", ".", "all");
		return results;
	}	

	</cfscript>

	

	<cffunction name="getEmptyDirectories" output="FALSE" access="public"  returntype="query" hint="Returns a query of all of the empty directories in a folder." >
		<cfargument name="rootPath" type="string" required="TRUE" hint="The root path to start searching for empty folder." />
		<cfargument name="excludeSourceControl" type="boolean" default="true" hint="whether or not to include source control files in purge." />
	
		<cfset var filesList = DirectoryList(arguments.rootPath, true, "query") />
		<cfset var populatedDirectories = "" />
		<cfset var allDirs = "" />
		<cfset var emptyDirs = "" />
		<cfset var populatedDirectoriesArray = ArrayNew(1) />
	
		<cfquery name="populatedDirectories" dbtype="query">
			SELECT 		distinct directory
			FROM 		filesList
		</cfquery>
		
		
		<cfloop query="populatedDirectories">
			<cfset arrayAppend(populatedDirectoriesArray, directory) />
		</cfloop>
		
		
		<cfquery name="allDirs" dbtype="query">
			SELECT 		directory + '#FS#' + name as path
			FROM 		filesList
			WHERE 		type = 'Dir'
		</cfquery>
		
		<cfquery name="emptyDirs" dbtype="query">
			SELECT 		path
			FROM 		allDirs
			WHERE 		path not in (<cfqueryParam cfsqltype="cf_sql_varchar" list="true" value="#ArrayToList(populatedDirectoriesArray)#" />)
			<cfif arguments.excludeSourceControl>
			AND			path not like '%/.git%'
			AND			path not like '%/.svn%'
			</cfif>
		</cfquery>
	
		<cfreturn emptyDirs />
	</cffunction>


</cfcomponent>