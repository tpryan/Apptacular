<cfsetting showdebugoutput="FALSE" />

<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>

<cfscript>
	utils = New cfc.utils();
	FS = createObject("java", "java.lang.System").getProperty("file.separator");
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port; 
	
	xmldoc = XMLParse(ideeventInfo); 
	
	// get folders needed for these operations. 
	rootFilePath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
	writeLog("Path to Purge: " & rootFilePath, "Apptacular");
	dbConfigPath = rootFilePath & FS & ".apptacular/schema/";
	
	// get the cfc path from the schema files.
	rootCFCPath = utils.findCFCPathFromFilePath(rootFilePath);
	
	
	if (not directoryExists(dbConfigPath)){			
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notanapplication";
		messagesURL = baseURL & messagesPath & messagesOptions;
		failed = true;
	}
	else{
		// get the datasource name from the schema files.
		dsName = DirectoryList(dbConfigPath, false, "name")[1];
	}
	
</cfscript>

<cfif failed>
	<cfheader name="Content-Type" value="text/xml">
	<cfoutput> 
	<response showresponse="true">
		<ide url="#messagesURL#" > 
			<dialog width="655" height="600" />
		</ide> 
	</response>
	
	</cfoutput>
	<cfabort> 
</cfif>


<cfscript>	

	//process both DB and file version of schema
	db = New cfc.db.datasource(dsName);
	dbConfig = New cfc.db.dbConfig(dbConfigPath);
	datamodel= dbConfig.overwriteConfig(db);
	dbConfig.writeConfig(datamodel);
	
	
	//process both default and file version of config
	config = New generators.cfapp.Config(rootFilePath, rootCFCPath);
	config.overwriteFromDisk();
	config.writeToDisk();
	
	
	// Fire up the generator to check what files are generated by the extension
	ormGenerator = new generators.cfapp.ormGenerator(datamodel, config);
	viewGenerator = new generators.cfapp.viewGenerator(datamodel, config);
	serviceGenerator = new generators.cfapp.serviceGenerator(datamodel, config);
	unittestGenerator = new generators.cfapp.unittestGenerator(datamodel, config);

	generator = New generators.cfapp.generator(datamodel, config, ormGenerator, viewGenerator, serviceGenerator, unittestGenerator);
		
	generator.generate();
	filesGenerated = generator.getAllGeneratedFilePaths();
	
	
	filesList = DirectoryList(rootFilePath, true, "query");
	
</cfscript>	


<!--- Get all of the files that don't belong in the file resu.t --->
<cfquery name="filesList" dbtype="query">
	SELECT 	directory + '#FS#' + name as path
	FROM 	filesList
	WHERE 	name like '%.cfm'
	OR	 	name like '%.cfc'
	OR	 	name like '%.css'
</cfquery>

<!--- Lower here serves to ensure that we propertly purge files. --->
<cfquery name="extrafilesList" dbtype="query">
	SELECT 	path
	FROM 	filesList
	WHERE 	LOWER(path) not in (<cfqueryParam cfsqltype="cf_sql_varchar" list="true" value="#Lcase(ArrayToList(filesGenerated))#" />)
</cfquery>

<!--- Delete Extra files --->
<cfloop query="extrafilesList">
	<cffile action="delete" file="#extrafilesList.path[extrafilesList.currentRow]#" />
</cfloop>

<!--- Get the empty directories. --->
<cfset emptyDirs = utils.getEmptyDirectories(rootFilePath) />

<!--- Delete Empty Folders  --->
<cfloop query="emptyDirs">
	<cfdirectory action="delete" directory="#path#" />
</cfloop>

<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(rootFilePath,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<cfhttp url="#script_Path#" timeout="0" />

<cfset baseURL = "http://" & cgi.server_name & ":" & cgi.server_port />
<cfset messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm" />
<cfset messagesOptions = "?type=purge&amp;fileCount=#extrafilesList.recordCount#&amp;dirCount=#emptyDirs.recordCount#" />
<cfset messagesURL = baseURL  & messagesPath & messagesOptions />

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide url="#messagesURL#" > 
		<dialog width="655" height="600" />
		<commands>
			<command name="refreshproject">
				<params>
					<param key="projectname" value="<cfoutput>#rootFilePath#</cfoutput>" />
				</params>
			</command>
		</commands>	 
	</ide> 
</response> 
</cfoutput>
	
