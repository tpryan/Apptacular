<cfsetting showdebugoutput="FALSE" />


<cfscript>
	XMLDoc = xmlParse(ideeventInfo);
	
	
	//handle input from the rds view
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
	
		projectPath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value;
		dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
		tableNAme=XMLDoc.event.ide.rdsview.database[1].table[1].XMLAttributes.name;  
	}
	//handle input from the project view
	else if (structKeyExists(XMLDoc.event.ide, "projectview")){
		FS = createObject("java", "java.lang.System").getProperty("file.separator");
		dsName = ""; 
		utils = New cfc.utils();
		
		//get table data from orm cfc
		cfcFile = XMLDoc.event.ide.projectview.resource.XMLAttributes.path;
		cfcPath = utils.findCFCPathFromFilePath(cfcFile);
		
		
		//get table data from services
		if (FindNoCase("service", Right(cfcPath, 7)) and Len(ListLast(cfcPath, ".")) > 7){
			cfc = CreateObject("component", cfcPath).init();
			
			tableName = cfc.table;
		}
		else{
			cfcmetadata = getComponentMetadata(cfcPath);
			if(structKeyExists(cfcmetadata, "table")){
				tableName = cfcmetadata.table;
			} 
			else{
				tableName = ListLast(cfcmetadata.name, ".");
			}
		}
		
		//get database detail
		projectPath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
		appCFCFile = projectPath & FS & "Application.cfc";
		appCFCPath = utils.findCFCPathFromFilePath(appcfcFile);
		try{
			app = CreateObject("component", appCFCPath);
			dsName = app.datasource;
		}
		catch(any e){
			if (not FindNoCase("Could not find the ColdFusion component",e.message)){
				rethrow;
			}
		}
		
	}
	
	
	
	
	
	
	schemaPath = projectPath & "/.apptacular/schema";
	tablepath = schemaPath & "/" & dsName & "/" & tableNAme;
	//Ensure that overwrites are respected.
	configPath = projectPath & "/.apptacular/config.xml";
	
	baseURL = "http://" & cgi.server_name & ":" & cgi.server_port;
	handlerPath = getDirectoryFromPath(cgi.script_name) & "/editDB/editTable.cfm";
	handlerOptions = "?path=" & tablepath;
	handlerURL = baseURL & handlerPath & handlerOptions;
</cfscript>



<cfif not FileExists(configPath) OR not DirectoryExists(tablepath)>

	<cfscript>
		messagesPath = getDirectoryFromPath(cgi.script_name) & "/messages.cfm";
		messagesOptions = "?type=notacfc";
		messagesURL = baseURL  & messagesPath & messagesOptions;
	
	</cfscript>
	
	<cf_ideWrapper messageURL="#messagesURL#" />
	<cfabort> 
</cfif>

<cfscript>
	configXML = xmlParse(FileRead(configPath));
	configXML.config.OverwriteDataModel.XMLText = TRUE;
	FileWrite(configPath, configXML);
</cfscript>

<cf_ideWrapper messageURL="#handlerURL#" />
