<cfsetting showdebugoutput="FALSE" />

<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sample.xml')#" variable="ideeventInfo" />
</cfif>

<cfscript>
	utils = New cfc.utils();
	xmldoc = XMLParse(ideeventInfo);  
	
	//handle input from the rds view
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
		dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
		rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value & "/";
		dbConfigPath = rootFilePath & ".apptacular/schema";  
	}
	//handle input from the project view
	else if (structKeyExists(XMLDoc.event.ide, "projectview")){
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		rootFilePath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
		dbConfigPath = rootFilePath & FS & ".apptacular/schema/";
		dsName = DirectoryList(dbConfigPath, false, "name")[1];
		
	}

	StartTimer = getTickCount();
	
	rootCFCPath = utils.findCFCPathFromFilePath(rootFilePath);

	//process both DB and file version of schema
	db = New cfc.db.datasource(dsName);
	dbConfig = New cfc.db.dbConfig(dbConfigPath);
	datamodel= dbConfig.overwriteConfig(db);
	
	dbConfig.writeConfig(datamodel);
	
	
	//process both default and file version of config
	config = New generators.cfapp.Config(rootFilePath, rootCFCPath);
	config.overwriteFromDisk();
	config.writeToDisk();
	
	
	// Fire up the generator 
	generator = New generators.cfapp.generator(datamodel, config);
	generator.generate();
	generator.writeFiles();
	
	EndTimer = getTickCount();
	TickCount = EndTimer - StartTimer;
	TickCount = TickCount / 1000;
	
	
	

</cfscript>

<!--- reset application --->
<cfset script_path = "http://" & cgi.script_name & "/" & ReplaceNoCase(rootFilePath,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<cfhttp url="#script_Path#" timeout="0" />

<cfheader name="Content-Type" value="text/xml">
<cfoutput> 
<response showresponse="true"> 
	<ide > 
		<dialog width="600" height="400" />
			<body> 
				<![CDATA[ 
				<cf_pageWrapper>
					<cfoutput><p>#generator.fileCount()# Files Generated in #TickCount# seconds, even using Evaluate()</p></cfoutput>				
				</cf_pageWrapper>
			 	]]> 
			</body>
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
