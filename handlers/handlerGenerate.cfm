<cfsetting showdebugoutput="false" />

	<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sample.xml')#" variable="ideeventInfo" />
</cfif>

<cfparam name="form.ideeventInfo" default="<event><ide></ide></event>" />
<cfscript>
	failed = FALSE;
	utils = New cfc.utils();
	xmldoc = XMLParse(ideeventInfo); 
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
	generateServices = false;
	onprojectCreate = false; 
	
	//handle input from the rds view
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
	
		dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
		rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value;
		generateServices = XMLSearch(xmldoc, "/event/user/input[@name='GenerateServices']")[1].XMLAttributes.value;
		if (right(rootFilePath, 1) neq FS){
			rootFilePath = rootFilePath & FS;
		}
		
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
		appRoot = rootFilePath; 
	}
	//handle input from the project view
	else if (structKeyExists(XMLDoc.event.ide, "projectview")){
	
	
		rootFilePath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
		resourcePath = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
		dbConfigPath = utils.findConfig(rootFilePath,resourcePath,"schema");
	
		appRoot = utils.findAppRoot(rootFilePath,resourcePath);
		
		writeLog("rootfilePath=#rootFilePath#");
		writeLog("resourcePath=#resourcePath#");
		writeLog("appRoot=#appRoot#");		
		
		//Short circuit non apptacular apps.
		if (not directoryExists(dbConfigPath)){
			messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
			messagesOptions = "?type=notanapplication";
			messagesURL = baseURL & messagesPath & messagesOptions;
			failed = true;
		}
		else{
			dsName = DirectoryList(dbConfigPath, false, "name")[1];
		}
		
		
	}
	else if (structKeyExists(form, "projectPath")){
		dsName = form.dsName;
		rootFilePath = form.projectpath;
		generateServices = StructKeyExists(form, "generateservices");
		if (right(rootFilePath, 1) neq FS){
			rootFilePath = rootFilePath & FS;
		}
		
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
		appRoot = rootFilePath; 
		onprojectCreate = true; 
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
	StartTimer = getTickCount();
	
	appCFCPath = utils.findCFCPathFromFilePath(appRoot);

	//process DB version of schema
	db = New cfc.db.datasource(dsName);

	
	//process config default 
	config = New generators.cfapp.Config(appRoot, appCFCPath);
	config.setCreateServices(generateServices);
	
	//make sure that large existing apps don't wire one-to-many relationships
	if (db.calculateHighestRowCount() gt 1000){
		config.setWireOneToManyinViews(false);
	}
	
	
	
	//sort through any url parameters here, used in automation and testing
	urlkeys = StructKeyArray(url);
	
	for (i=1; i <= arraylen(urlkeys); i++){
		if (structKeyExists(config, "set#urlkeys[i]#")){
			evaluate("config.set#urlkeys[i]#(#url[urlkeys[i]]#)");
		}
	}
	
	//Handle Managing config back to the disk. 
	config.overwriteFromDisk();
	config.calculatePaths();
	config.writeToDisk();

	//process file version of schema
	dbConfig = New cfc.db.dbConfig(dbConfigPath);
	
	
	//Overwrite the datamodel from the xml configs
	if (config.getOverwriteDataModel()){
		datamodel= dbConfig.overwriteConfig(db);
		
		
		datamodel.dePrefixTables();
		datamodel.checkForJoinTables();
		
		
		if (config.getDepluralize()){
			stringUtil = new apptacular.handlers.cfc.stringUtil();
			datamodel.depluralize(stringUtil);
		}
		
		writeLog("overwrite=true");
		writeLog("prefix=#datamodel.getPrefix()#");	
	}
	else{
		datamodel= db;
		writeLog("overwrite=false");	
	}
	
	
	//write back to disk.
	dbConfig.writeConfig(datamodel);
	
	// Fire up the generator 
	if (config.getLockApplication()){
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=locked";
		messagesURL = baseURL & messagesPath & messagesOptions;
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
		
		baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=generated&amp;fileCount=#generator.fileCount()#&amp;seconds=#TickCount#";
		messagesURL = baseURL  & messagesPath & messagesOptions;
		
	}
	
	
	
	

</cfscript>



<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(rootFilePath,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<cfhttp url="#script_Path#" timeout="0" />


<cfif onprojectCreate>
	<cflocation url="#ReplaceNoCase(messagesURL, "&amp;", "&","ALL")#" addtoken="false" />
</cfif>

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
