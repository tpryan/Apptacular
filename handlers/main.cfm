	<cfif not structKeyExists(form, "ideeventInfo")>
	<cffile action="read" file="#ExpandPath('./sample.xml')#" variable="ideeventInfo" />
</cfif>

<cfset xmldoc = XMLParse(ideeventInfo) />   
<cfset dsName=XMLDoc.event.ide.rdsview.database[1].XMLAttributes.name />


<cfscript>
	db = New cfc.db.datasource(dsName);

	
	rootFilePath = "/Users/terryr/Sites/centaur.dev/CentaurKeynoteDemo/";
	rootCFCPath = "centaurkeynotedemo";

	dbConfig = New cfc.db.dbConfig(rootFilePath);
	
	datamodel= dbConfig.overwriteConfig(db);
	dbConfig.writeConfig(datamodel);
	
	config = New generators.trorm.Config(rootFilePath, rootCFCPath);
	config.setCreateServices(false);
	config.setentityFolder("entity");
	config.calculatePaths();
	
	generator = New generators.trorm.generator();
	generator.generate(datamodel, config);
	
	

</cfscript>
