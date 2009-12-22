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

	//process DB version of schema
	db = New cfc.db.datasource(dsName);

	//process both default and file version of config
	config = New generators.cfapp.Config(rootFilePath, rootCFCPath);
	
	//make sure that large existing apps don't wire one-to-many relationships
	if (db.calculateHighestRowCount() gt 1000){
		config.setWireOneToManyinViews(false);
	}
	
	config.overwriteFromDisk();
	config.calculatePaths();
	config.writeToDisk();

	//process file version of schema
	dbConfig = New cfc.db.dbConfig(dbConfigPath);
	
	if (config.getOverwriteDataModel()){
		datamodel= dbConfig.overwriteConfig(db);
	}
	else{
		datamodel= db;
	}
	
	dbConfig.writeConfig(datamodel);
	
	// Fire up the generator 
	if (config.getLockApplication()){
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=locked";
		messagesURL = "http://" & cgi.server_name & messagesPath & messagesOptions;
	}
	else{
		ormGenerator = new generators.cfapp.ormGenerator(datamodel, config);
		viewGenerator = new generators.cfapp.viewGenerator(datamodel, config);
		serviceGenerator = new generators.cfapp.serviceGenerator(datamodel, config);
		unittestGenerator = new generators.cfapp.unittestGenerator(datamodel, config);

		generator = New generators.cfapp.generator(datamodel, config, ormGenerator, viewGenerator, serviceGenerator, unittestGenerator);
		generator.generate();
		generator.writeFiles();
		
		EndTimer = getTickCount();
		TickCount = EndTimer - StartTimer;
		TickCount = TickCount / 1000;
		
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=generated&amp;fileCount=#generator.fileCount()#&amp;seconds=#TickCount#";
		messagesURL = "http://" & cgi.server_name & messagesPath & messagesOptions;
		
	}
	
	
	
	

</cfscript>

<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(rootFilePath,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<cfhttp url="#script_Path#" timeout="0" />


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
