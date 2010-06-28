<cfsetting showdebugoutput="false" />


<cfparam name="form.ideeventInfo" default="<event><ide></ide></event>" />
<cfscript>
	failed = FALSE;
	utils = New cfc.utils();
	cgiUtils = New cfc.cgiUtils(cgi);
	baseURL = cgiUtils.getBaseURL();
	xmldoc = XMLParse(ideeventInfo); 
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
	
	generateRemoteServices = false;
	onprojectCreate = false; 
	
	//handle input from the rds view
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
	
		dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
		rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value;
		
		if (ArrayLen(XMLSearch(xmldoc, "/event/user/input[@name='GenerateRemoteServices']")) gt 0 ){
			generateRemoteServices = XMLSearch(xmldoc, "/event/user/input[@name='GenerateRemoteServices']")[1].XMLAttributes.value;
		}
		
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
		generateRemoteServices = StructKeyExists(form, "generateRemoteServices");
		if (right(rootFilePath, 1) neq FS){
			rootFilePath = rootFilePath & FS;
		}
		
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
		appRoot = rootFilePath; 
		onprojectCreate = true; 
	}

</cfscript>	

	
<cfif failed>
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<!--- New test to make sure that you do not build an apptacular project into a populated
		project without asking.  --->

<cfif not structKeyExists(form, "confirmed")>		
	<cfdirectory action="list" directory="#rootFilePath#" name="projectFiles" listinfo="name" />
	
	<cfquery name="isApptacular" dbtype="query">
		SELECT 	*
		FROM	projectFiles
		WHERE 	name = '.apptacular'
	
	</cfquery>
	
	<cfquery name="otherFiles" dbtype="query">
		SELECT 	*
		FROM	projectFiles
		WHERE 	name != '.apptacular'
		AND		name != '.project'
		AND 	name != '.settings'
		AND 	name != '.settings/org.eclipse.core.resources.prefs'
	</cfquery>
	
	<cfif isApptacular.RecordCount eq 0 and otherFiles.RecordCount gt 0>
		<cfset messagesPath = getDirectoryFromPath(cgi.script_name) & "/handlerGenerateWarning.cfm" />
		<cfset messagesOptions = "?rootFilePath=#rootFilePath#&amp;dsName=#dsName#" />
		<cfset messagesURL = baseURL  & messagesPath & messagesOptions />
		<cflog text="messagesURL: #messagesURL#" />
		
		<cfif FindNoCase("Jakarta",cgi.HTTP_USER_AGENT) eq 0>
			<cflocation url="#ReplaceNoCase(messagesURL, "&amp;", "&","ALL")#" addtoken="false" />
		<cfelse>
			<cf_ideWrapper messageURL="#messagesURL#" />
			<cfabort>
		</cfif>
	</cfif>

</cfif>

<cfscript>
	log = New cfc.log(dsName);
	log.startEvent("app", "Apptacular Process");
	
	appCFCPath = utils.findCFCPathFromFilePath(appRoot);

	//process DB version of schema
	stringUtils = New cfc.stringUtil();
	reservedWordHelper = New cfc.utils.reservedWordHelper();
	
	db = New cfc.db.datasource(dsName, stringUtils, log, reservedWordHelper);

	
	//process config default 
	config = New generators.cfapp.Config(appRoot, appCFCPath);
	
	if (generateRemoteServices){
		config.setServiceAccess("remote");
	}
	
	
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
			datamodel.depluralize();
		}
	}
	else{
		datamodel= db;
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

		generator = New generators.cfapp.generator(datamodel, config, ormGenerator, viewGenerator, serviceGenerator, unittestGenerator, log);
		generator.generate();
		generator.writeFiles();
		
		log.endEvent("app");
		log.logTimes();
		TickCount = log.getEvent("app").totalTime;
		
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=generated&amp;fileCount=#generator.fileCount()#&amp;seconds=#TickCount#";
		messagesURL = baseURL  & messagesPath & messagesOptions;
	}
	

</cfscript>

<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(rootFilePath,ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<!--- addded to prevent application reset from slowing down the application building.  --->
<cfthread name="#createUUID()#" action="run">
	<cfhttp url="#script_Path#" timeout="0" />
</cfthread>
<cfif onprojectCreate>
	<cflocation url="#ReplaceNoCase(messagesURL, "&amp;", "&","ALL")#" addtoken="false" />
</cfif>

<cf_ideWrapper messageURL="#messagesURL#">
<commands>
	<command name="refreshproject">
		<params>
			<param key="projectname" value="<cfoutput>#rootFilePath#</cfoutput>" />
		</params>
	</command>
</commands>	
</cf_ideWrapper>
