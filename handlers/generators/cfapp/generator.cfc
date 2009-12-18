component{

	public generator function init(required any datasource, required any config, 
			required ormGenerator ormGenerator, required viewGenerator viewGenerator, 
			required serviceGenerator serviceGenerator, required unittestGenerator unittestGenerator){
			
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.datasource = arguments.datasource;
		variables.config = arguments.config;
		variables.files = ArrayNew(1);
		
		variables.ormGenerator = arguments.ormGenerator;
		variables.viewGenerator = arguments.viewGenerator;
		variables.serviceGenerator = arguments.serviceGenerator;
		variables.unittestGenerator = arguments.unittestGenerator;
				
		return This;
	}
	
	public void function generate(){
		var i =0;
		var tables = datasource.getTables();
		
		
		//Create ORM dependent files
		if (config.getCreateAppCFC()){
			var AppCFC = ormGenerator.createAppCFC(datasource, config.getRootFilePath());
			ArrayAppend(files, AppCFC);
			
			var EventHandler = ormGenerator.createEventHandler(config.getEntityFilePath());
			ArrayAppend(files, EventHandler);
		}
		
		//Create global application views.
		if (config.getCreateViews()){
			viewGenerator.copyCSS();
			viewGenerator.copyForeignKeyCustomTag();
			viewGenerator.copyManyToManyCustomTag();
			viewGenerator.copyManyToManyReaderCustomTag();
			viewGenerator.copyGradient();
			
			var index = viewGenerator.createIndex();
			ArrayAppend(files, index);
			
			var pageWrapper = viewGenerator.createPageWrapper();
			ArrayAppend(files, pageWrapper);
		
			//Only generate login view if we are generating view
			if (config.getCreateLogin()){
				
				var login = viewGenerator.createLogin();
				ArrayAppend(files, login);
				viewGenerator.copyLoginCustomTag();
				
			}
			
			//Only generate the unit tests if were are generating the views.
			if (config.getCreateTests()){
				testIndex = unittestGenerator.createIndexTest();
				ArrayAppend(files, testIndex);
			}
			
		}
		
		
		
		//Only generate login service if we are generating services
		if (config.getCreateServices() AND config.getCreateLogin()){
			var authCFC = serviceGenerator.createAuthenticationService();
			ArrayAppend(files, authCFC);
		}
		
		//Roll through the tables creating all per table interfaces here so as to not repeat table loops.
		for (i=1; i <= ArrayLen(tables); i++){
			var table = tables[i];
			
			//Handle ORM Entities for tables.
			if (config.getCreateEntities() and table.getCreateInterface()){
				var ORMCFC = ormGenerator.createORMCFC(table);
				ArrayAppend(files, ORMCFC);
			}

			//Handle Views for tables.
			if (config.getCreateViews() and table.getCreateInterface()){
				var ViewListCustomTag = viewGenerator.createViewListCustomTag(table);
				ArrayAppend(files, ViewListCustomTag);
				
				var ViewReadCustomTag = viewGenerator.createViewReadCustomTag(table);
				ArrayAppend(files, ViewReadCustomTag);
				
				var ViewEditCustomTag = viewGenerator.createViewEditCustomTag(table);
				ArrayAppend(files, ViewEditCustomTag);
				
				var View = viewGenerator.createView(table);
				ArrayAppend(files, View);
			}
			
			//Handles Services for tables.
			if (config.getCreateServices() and table.getCreateInterface()){
				
				var ORMServiceCFC = serviceGenerator.createORMServiceCFC(table);
				ArrayAppend(files, ORMServiceCFC);
			
			}
			
			//Handles unit tests for tables.
			if (config.getCreateTests() and table.getCreateInterface()){
				testview = unittestGenerator.createViewsTest(table);
				ArrayAppend(files, testview);
				
				testEntity = unittestGenerator.createEntityTest(table);
				ArrayAppend(files, testEntity);
			}
		}
		
		//Generate a extended pieces to compensate for Application coupling to ORM 
		if (config.getCreateTests()){
			remoteFacade = unittestGenerator.createRemoteFacade();
			ArrayAppend(files, remoteFacade);
			
			HttpAntRunner = unittestGenerator.createHttpAntRunner();
			ArrayAppend(files, HttpAntRunner);
			
			directoryRunner = unittestGenerator.createDirectoryRunner();
			ArrayAppend(files, directoryRunner);
			
			GlobalTest = unittestGenerator.createGlobalTest();
			ArrayAppend(files, GlobalTest);
			
			
		}
	
	}
	
	public array function getAllGeneratedFilePaths(){
		var i = 0;
		var result = ArrayNew(1);
		for (i=1; i <= ArrayLen(files); i++){
			ArrayAppend(result, files[i].getFileName());
		}
		
		if (config.getCreateViews()){
			ArrayAppend(result,config.getCSSFilePath() & variables.FS & "screen.css");
			ArrayAppend(result,config.getCSSFilePath() & variables.FS & "appgrad.jpg");
			ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "foreignKeySelector.cfm");
			ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "manyToManySelector.cfm");
			ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "manyToManyReader.cfm");
			ArrayAppend(result,config.getCustomTagFilePath() & variables.FS & "loginForm.cfm");
		}
		
		return result;
	}
	
	public void function writeFiles(){
		var i = 0;
		for (i=1; i <= ArrayLen(files); i++){
			files[i].write();
		}
	}
	
	public numeric function fileCount(){
		return ArrayLen(files);
	}
	
	
}