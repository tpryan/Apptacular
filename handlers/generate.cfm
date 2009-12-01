<cfsetting showdebugoutput="FALSE" />

<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sampleEditSchema.xml')#" variable="ideeventInfo" />
</cfif>

<cfscript>

	xmldoc = XMLParse(ideeventInfo);  
	
	if (structKeyExists(XMLDoc.event.ide, "rdsview")){
		dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
		rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value & "/";
	}
	else if (structKeyExists(XMLDoc.event.ide, "projectview")){
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		rootFilePath = XMLDoc.event.ide.projectview.XMLAttributes.projectlocation;
		
		schemaPath = rootFilePath & FS & ".apptacular/schema/";
		dsName = DirectoryList(schemaPath, false, "name")[1];
		
	}
	
	
	dbConfigPath = rootFilePath & "/.apptacular/schema";  

	StartTimer = getTickCount();

	db = New cfc.db.datasource(dsName);

	
	rootCFCPath = findCFCPathFromFilePath(rootFilePath);

	dbConfig = New cfc.db.dbConfig(dbConfigPath);
	
	datamodel= dbConfig.overwriteConfig(db);
	dbConfig.writeConfig(datamodel);
	
	config = New generators.trorm.Config(rootFilePath, rootCFCPath);
	config.calculatePaths();
	
	generator = New generators.trorm.generator(datamodel, config);
	generator.generate();
	
	EndTimer = getTickCount();
	TickCount = EndTimer - StartTimer;
	TickCount = TickCount / 1000;
	filesList = DirectoryList(rootFilePath, true, "query");
	
	public string function findCFCPathFromFilePath(string path){
		var results = "";
		var webroot = ExpandPath("/");
		results = replace(arguments.path, webroot, "", "one");
		results = replace(results, "/", ".", "all");
		return results;
	}	

</cfscript>


<cfheader name="Content-Type" value="text/xml">
<response status="success" showresponse="true">
	<ide>
		<dialog width="600" height="400" />
			<body>
				<![CDATA[
				<cfoutput>#generator.fileCount()# Files Generated in #TickCount# seconds, even using Evaluate()</cfoutput>
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

