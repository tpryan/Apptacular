<cfcomponent>

	<cfscript>	
	
	public function init(string webroot=""){
    	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		
		if (len(arguments.webroot) gt 0){
			variables.webroot= arguments.webroot;
		
		}
		else{
			variables.webroot= ExpandPath("/");
		}	
    	return This;
    }
	
	public string function findCFCPathFromFilePath(string path){
		
		var localPath = arguments.path;
		
		if (FindNoCase("cfc", listLast(localPath, "."))){
			localPath = left(localPath, Len(localPath) - 4);
		}
		
		var results = "";
		results = replaceNoCase(localPath, webroot, "", "one");
		results = replaceList(results, "/,\", ".,.");
		
		
		
		
		if (compare(right(results, 1), ".") eq 0){
			results = Left(results, len(results) -1);
		}
		
		return results;
	}
	
	public string function findConfig(required string projectlocation, required string resourcepath, string type="config"){
		var lresourcepath = arguments.resourcepath;
		
		if (FindNoCase("config", arguments.type)){
			var configFile = "/.apptacular/config.xml";
			
			var pathToConfig = lresourcepath & configFile;
	
			while (not FileExists(pathToConfig)){
				lresourcepath = listDeleteAt(lresourcepath, ListLen(lresourcepath, variables.FS), variables.FS);
				
				pathToConfig = lresourcepath & configFile;
				
				if (len(lresourcepath) < len(arguments.projectlocation)){
					pathToConfig = "/dev/null";
					break;
				}
			}	
			
			
		}
		else if (FindNoCase("schema", arguments.type)){
			var configFile = "/.apptacular/schema";
			
			var pathToConfig = lresourcepath & configFile;
	
			while (not directoryExists(pathToConfig)){
				lresourcepath = listDeleteAt(lresourcepath, ListLen(lresourcepath, variables.FS), variables.FS);
				
				pathToConfig = lresourcepath & configFile;
				
				if (len(lresourcepath) < len(arguments.projectlocation)){
					pathToConfig = "/dev/null";
					break;
				}
			}	
			
		}
		
		
		
		
		return pathToConfig;
	}
	
	public string function findApprRoot(required string projectlocation, required string resourcepath){	
		var lresourcepath = arguments.resourcepath;
		var configFile = "/.apptacular/config.xml";
			
		var pathToConfig = lresourcepath & configFile;

		while (not FileExists(pathToConfig)){
			lresourcepath = listDeleteAt(lresourcepath, ListLen(lresourcepath, variables.FS), variables.FS);
			
			pathToConfig = lresourcepath & configFile;
			
			if (len(lresourcepath) < len(arguments.projectlocation)){
				lresourcepath = "/dev/null";
				break;
			}
		}	
		return lresourcepath;
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