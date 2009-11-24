<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sample.xml')#" variable="ideeventInfo" />
</cfif>

<cfset xmldoc = XMLParse(ideeventInfo) />   
<cfset dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name />


<cfscript>
	db = New cfc.db.datasource(dsName);

	//writeDump(db);
	
	rootPath = "/Users/terryr/Sites/centaur.dev/CentaurKeynoteDemo/";
	cfcpath = rootPath & "cfc";
	ctpath = rootPath & "customTags";
	servicePathpath = rootPath & "services";

	dbConfig = New cfc.db.dbConfig(rootPath);
	
	datamodel= dbConfig.overwriteConfig(db);
	dbConfig.writeConfig(datamodel);
	
	tables = datamodel.getTables();
	
	
	
	
	generator = New generators.trorm.generator();
	
	generator.createAppCFC(datamodel, rootPath).write('cfscript');
	generator.createIndex(datamodel, rootPath).write();
	
	for (i=1; i <= ArrayLen(tables); i++){
		generator.createORMCFC(tables[i], cfcpath).write('cfscript');
		generator.createViewListCustomTag(tables[i], ctpath).write();
		generator.createViewReadCustomTag(tables[i], ctpath).write();
		generator.createViewEditCustomTag(tables[i], ctpath).write();
		generator.createView(tables[i], rootpath).write();
		generator.createORMServiceCFC(tables[i], servicePathpath, "centaurkeynotedemo.cfc", "remote").write('cfscript');
	}
	
	

</cfscript>
