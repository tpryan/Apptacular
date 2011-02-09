<cfsetting showdebugoutput="false" />


<cfparam name="form.ideeventInfo" default="<event><ide></ide></event>" />



<cfif left(form.ideeventInfo, 1) neq "<">
    <cfset form.ideeventInfo = URLDecode(form.ideeventInfo) />
</cfif>  

<cfscript>
	
	//Instantiate a bunch of utily objects.
	utils = New cfc.utils.utils();
	stringUtils = New cfc.utils.stringUtil();
	reservedWordHelper = New cfc.utils.reservedWordHelper();
	cgiUtils = New cfc.utils.cgiUtils(cgi);
	builderHelper = new cfc.utils.builderHelper(ideeventInfo);
	
	
	
	//Set a bunch of starting values for app.
	baseURL = cgiUtils.getBaseURL();
	failed = FALSE;
	generateRemoteServices = FALSE;
	variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
	
	xmldoc = XMLParse(ideeventInfo); 
	
	
	
	ideVersion = builderHelper.getCFBuilderVersion(); 
	
	
	//handle input from the rds view (Generate Application)
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
	
		rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value;
		if (right(rootFilePath, 1) neq FS){
			rootFilePath = rootFilePath & FS;
		}
		builderHelper.setProjectPath(rootFilePath);
		builderHelper.setResourcePath(rootFilePath);
		dsName=builderHelper.getRdsDatasource();
		
		
		if (ArrayLen(XMLSearch(xmldoc, "/event/user/input[@name='GenerateRemoteServices']")) gt 0 ){
			generateRemoteServices = XMLSearch(xmldoc, "/event/user/input[@name='GenerateRemoteServices']")[1].XMLAttributes.value;
		}
		
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
		appRoot = rootFilePath;
		projectname = builderHelper.getProjectName(); 
	}
	//handle input from the project view (Regenerate Application)
	else if (
		( structKeyExists(XMLDoc.event.ide, "projectview") ) ||
		( structKeyExists(form, "operation") && compareNoCase(form.operation,"regenerate") ==0  )
	){
	 	builderHelper = application.builderHelper;
	
		rootFilePath = builderHelper.getProjectPath();
		resourcePath = builderHelper.getResourcePath();
		projectname = builderHelper.getProjectName();
		
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
			
			dsArray = DirectoryList(dbConfigPath, true, "path","_datasource.xml");
			dsName = Replace(dsArray[1], "\", "/", "ALL");
			dsName = ListLast(getDirectoryFromPath(dsName), "/");
		}
		
	}
	//handle direct input from a form (Create Application)
	else if (structKeyExists(form, "operation") && compareNoCase(form.operation, "createProject") eq 0){
		builderHelper = application.builderHelper;
			
		dsName = form.dsName;
		rootFilePath = builderHelper.getProjectPath();
		generateRemoteServices = StructKeyExists(form, "generateRemoteServices");
		if (right(rootFilePath, 1) neq FS){
			rootFilePath = rootFilePath & FS;
		}
		
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
		appRoot = rootFilePath;
		projectname = builderHelper.getProjectName();
		ideVersion = builderHelper.getCFBuilderVersion();
	}
	


	if (len(builderHelper.getProjectPath()) > 0){
		application.builderHelper = builderHelper;
	}	 
	else if (structKeyExists(application, "builderHelper")) {
		builderHelper = application.builderHelper;
	}	

</cfscript>	

	
<cfif failed>
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<!--- New test to make sure that you do not build an apptacular project into a populated
		project without asking.  --->

<cfif not structKeyExists(form, "confirmed")>
	
	
	
	<cfdirectory action="list" directory="#appRoot#" name="projectFiles" listinfo="name" />
	
	
	
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
		AND 	name != 'settings.xml'
		
		
	</cfquery>
	
	<cfif isApptacular.RecordCount eq 0 and otherFiles.RecordCount gt 0>
		<cfset messagesPath = getDirectoryFromPath(cgi.script_name) & "/handlerGenerateWarning.cfm" />
		<cfset messagesOptions = "?rootFilePath=#rootFilePath#&amp;dsName=#dsName#&projectname=#projectname#" />
		<cfset messagesURL = baseURL  & messagesPath & messagesOptions />
		
		<cf_ideWrapper messageURL="#messagesURL#" />
		<cfabort>
	</cfif>

</cfif>



<cfscript>

	if (isNull(appRoot)){
		approot = builderHelper.getProjectPath();
	}
	
	if (isNull(rootfilepath)){
		rootfilepath = builderHelper.getProjectPath();
	}
	
	
	if (isNull(dbconfigpath)){
		dbConfigPath = rootFilePath & ".apptacular/schema"; 
	}

	log = New cfc.utils.log(dsName);
	log.startEvent("app", "Apptacular Process");
	
	appCFCPath = utils.findCFCPathFromFilePath(appRoot);

	//process DB version of schema
	db = New cfc.db.datasource(dsName, stringUtils, log, reservedWordHelper);
	
	
	
	//process config default 
	config = New cfc.generators.cfapp.Config(appRoot, appCFCPath);
	
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
		relativePath = "/" & replace(rootFilePath, expandPath('/'), "","one");
		
		//Adding a pre load event for scripting events before apptacular runs
		if (FileExists(rootFilePath & "/.apptacular/pre.cfm")){
			log.startEvent("preload", "Apptacular Preloader Launched");
				include "#relativePath#/.apptacular/pre.cfm";
			log.endEvent("preload");
		}
	
		ormGenerator = new cfc.generators.cfapp.ormGenerator(datamodel, config);
		viewGenerator = new cfc.generators.cfapp.viewGenerator(datamodel, config);
		serviceGenerator = new cfc.generators.cfapp.serviceGenerator(datamodel, config);
		unittestGenerator = new cfc.generators.cfapp.unittestGenerator(datamodel, config);

		generator = New cfc.generators.cfapp.generator(datamodel, config, ormGenerator, viewGenerator, serviceGenerator, unittestGenerator, log);
		log.startEvent("filegen", "Apptacular File Generation");
		generator.generate();
		log.endEvent("filegen");
		
		log.startEvent("filewrite", "Apptacular File Writing");
		generator.writeFiles();
		log.endEvent("filewrite");
		
		//Adding a post load event for scripting events before apptacular runs
		if (FileExists(rootFilePath & "/.apptacular/post.cfm")){
		
			log.startEvent("postload", "Apptacular Postloader Launched");
				include "#relativePath#/.apptacular/post.cfm";
			log.endEvent("postload");	
		}
		
		
		log.endEvent("app");
		log.logTimes();
		TickCount = log.getEvent("app").totalTime;
		
		
		
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=generated&amp;fileCount=#generator.fileCount()#&amp;seconds=#TickCount#&amp;ideeventInfo=#UrlEncodedFormat(form.ideeventInfo)#";
		messagesURL = baseURL  & messagesPath & messagesOptions;
		
		
		
		
		
		
	}
</cfscript>

<!--- reset application --->
<cfset script_path = "http://" & cgi.server_name  & "/" & ReplaceNoCase(rootFilePath, ExpandPath('/'), "", "one") & "/index.cfm?reset_app" />
<!--- addded to prevent application reset from slowing down the application building.  --->
<cfthread name="#createUUID()#" action="run">
	<cfhttp url="#script_Path#" timeout="0" />
</cfthread>


<cf_ideWrapper messageURL="#messagesURL#" ideVersion="#ideVersion#" projectname="#projectname#" rootFilePath="#rootFilePath#">
<commands>
	<command name="refreshproject">
		<params>
			<param key="projectname" value="<cfoutput>#rootFilePath#</cfoutput>" />
		</params>
	</command>
</commands>	
</cf_ideWrapper>
