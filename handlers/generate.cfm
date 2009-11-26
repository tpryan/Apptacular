<cfsetting showdebugoutput="FALSE" />

<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sample.xml')#" variable="ideeventInfo" />
</cfif>



<cfscript>

	xmldoc = XMLParse(ideeventInfo);  
	dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name;
	rootFilePath = XMLSearch(xmldoc, "/event/user/input[@name='Location']")[1].XMLAttributes.value & "/";


	StartTimer = getTickCount();

	db = New cfc.db.datasource(dsName);

	
	rootCFCPath = findCFCPathFromFilePath(rootFilePath);

	dbConfig = New cfc.db.dbConfig(rootFilePath);
	
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

<cfquery name="filesList" dbtype="query">
	SELECT 		*
	FROM 		filesList
	WHERE 	 	name not like '.git'
	AND 		directory not like '%.git%'
	AND 		name not like '.schema'
	AND 		directory not like '%.schema%'
	AND 		name not like '.project'
	AND 		name not like 'settings.xml'
	AND			type != 'Dir'
</cfquery>



<cfheader name="Content-Type" value="text/xml">
<response status="success" showresponse="true">
	<ide>
		<dialog width="600" height="400" />
			<body>
				<![CDATA[
				<cfoutput>#filesList.recordCount# Files Generated in #TickCount# seconds, even using Evaluate()</cfoutput>
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

