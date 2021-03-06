/**
* @hint The main generator file that marshalls all of the other files around. 
*/
component{

	/**
	* @hint Spins up the generator and stores dependecies for generator. 
	*/
	public generator function init(required any datasource, required any config, 
			required ormGenerator ormGenerator, required viewGenerator viewGenerator, 
			required serviceGenerator serviceGenerator, required unittestGenerator unittestGenerator, 
			required any log){
			
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.datasource = arguments.datasource;
		variables.config = arguments.config;
		variables.files = ArrayNew(1);
		
		variables.ormGenerator = arguments.ormGenerator;
		variables.viewGenerator = arguments.viewGenerator;
		variables.serviceGenerator = arguments.serviceGenerator;
		variables.unittestGenerator = arguments.unittestGenerator;
		variables.log = arguments.log;
				
		return This;
	}
	
	/**
	* @hint Runs the entire generate routine. Basically spins up all of the code and writes each file to an array of file objects. Another process handles writing them to disk.   
	*/
	public void function generate(){
		var i =0;
		var tables = datasource.getTables();
		
		
		//Create ORM dependent files
		if (config.getCreateAppCFC()){
		
			variables.log.startEvent("ormDependencies", "ORM Dependent");
		
			var AppCFC = ormGenerator.createAppCFC(datasource, config.getRootFilePath());
			ArrayAppend(files, AppCFC);
			
			var EventHandler = ormGenerator.createEventHandler(config.getEntityFilePath());
			ArrayAppend(files, EventHandler);
			
			variables.log.endEvent("ormDependencies");
			
		}
		
		//Create global application views.
		if (config.getCreateViews()){
			variables.log.startEvent("views", "Global Application Views");
			
			var css = viewGenerator.createCSS();
			ArrayAppend(files, css);
			var kfct = viewGenerator.createForeignKeyCustomTag();
			ArrayAppend(files, kfct);
			var mmct = viewGenerator.createManyToManyCustomTag();
			ArrayAppend(files, mmct);
			var mmrct = viewGenerator.createManyToManyReaderCustomTag();
			ArrayAppend(files, mmrct);
			var grad = viewGenerator.createGradient();
			ArrayAppend(files, grad);
			var idct = viewGenerator.createImageDisplayCustomTag();
			ArrayAppend(files, idct);
			
			var index = viewGenerator.createIndex();
			ArrayAppend(files, index);
			
			var pageWrapper = viewGenerator.createPageWrapper();
			ArrayAppend(files, pageWrapper);
		
			//Only generate login view if we are generating view
			if (config.getCreateLogin()){
				
				var login = viewGenerator.createLogin();
				ArrayAppend(files, login);
				var loginCT = viewGenerator.createLoginCustomTag();
				ArrayAppend(files, loginCT);
				
			}
			
			//Only generate the unit tests if were are generating the views.
			if (config.getCreateTests()){
				var testIndex = unittestGenerator.createIndexTest();
				ArrayAppend(files, testIndex);
			}
			
			variables.log.endEvent("views");
			
		}
		
		
		//Only generate login service if we are generating services
		if (config.getCreateServices() AND config.getCreateLogin()){
		
			variables.log.startEvent("auth", "Authentication Files");
		
			var authCFC = serviceGenerator.createAuthenticationService();
			
			if (config.getMakeSuperSerivces()){
				var AuthEditableServiceCFC = serviceGenerator.createEditableServiceCFC("authentication");
				AuthEditableServiceCFC.setName("authenticationService");
				authCFC.setName("_authenticationSuperService");
				AuthEditableServiceCFC.setExtends("_authenticationSuperService");
				ArrayAppend(files, AuthEditableServiceCFC);
			}
			
			
			ArrayAppend(files, authCFC);
			
			variables.log.endEvent("auth");
		}
		
		
		variables.log.createEventSeries("view", "Table View object creation");
		variables.log.createEventSeries("orm", "Table ORM object creation");
		variables.log.createEventSeries("service", "Table Service object creation");
		variables.log.createEventSeries("test", "Table Test object creation");
		
		//Roll through the tables creating all per table interfaces here so as to not repeat table loops.
		for (i=1; i <= ArrayLen(tables); i++){
			var table = tables[i];
			
			
			
			if (table.isProperTable()){
			
				//Handle ORM Entities for tables.
				if (config.getCreateEntities() and table.getCreateInterface()){
					
					variables.log.startEventSeriesItem("orm");
					
					
					var ORMCFC = ormGenerator.createORMCFC(table);
					
					if (config.getMakeSuperEntities()){
						var ORMEditableEntityCFC = ormGenerator.createORMEditableEntityCFC(table);
						ORMEditableEntityCFC.setName("_" & table.getEntityName()& "SuperEntity");
						ORMCFC.setExtends("_" & table.getEntityName()& "SuperEntity");
						ArrayAppend(files, ORMEditableEntityCFC);
					}
					
					
					
					ArrayAppend(files, ORMCFC);
					
					variables.log.endEventSeriesItem("orm");
				
				}

				//Handle Views for tables.
				if (config.getCreateViews() and table.getCreateInterface()){
					
					variables.log.startEventSeriesItem("view");
					
					var View = viewGenerator.createView(table);
					ArrayAppend(files, View);
					
					var ViewListCustomTag = viewGenerator.createViewListCustomTag(table);
					ArrayAppend(files, ViewListCustomTag);
					
					var ViewSearchCustomTag = viewGenerator.createViewSearchCustomTag(table);
					ArrayAppend(files, ViewSearchCustomTag);
					
					var ViewBreadcrumbCustomTag = viewGenerator.createViewBreadCrumbCustomTag(table);
					ArrayAppend(files, ViewBreadcrumbCustomTag);
					
					var ViewReadCustomTag = viewGenerator.createViewReadCustomTag(table);
					ArrayAppend(files, ViewReadCustomTag);
					
					if (not table.getIsView()){					
						var ViewEditCustomTag = viewGenerator.createViewEditCustomTag(table);
						ArrayAppend(files, ViewEditCustomTag);
					}
					
					variables.log.endEventSeriesItem("view");	
					
				}
				
				//Handles Services for tables.
				if (config.getCreateServices() and table.getCreateInterface()){
					
					variables.log.startEventSeriesItem("service");
					
					
					var ORMServiceCFC = serviceGenerator.createORMServiceCFC(table);
					
					if (config.getMakeSuperSerivces()){
						var ORMEditableServiceCFC = serviceGenerator.createEditableServiceCFC(table.getEntityName());
						ORMEditableServiceCFC.setName(table.getEntityName() & "Service");
						ORMServiceCFC.setName("_" & table.getEntityName() & "SuperService");
						ORMEditableServiceCFC.setExtends("_" & table.getEntityName() & "SuperService");
						ArrayAppend(files, ORMEditableServiceCFC);
					}
					
					ArrayAppend(files, ORMServiceCFC);
					
					variables.log.endEventSeriesItem("service");	
				
				}
			
				//Handles unit tests for tables.
				if (config.getCreateTests() and table.getCreateInterface()){
					
					variables.log.startEventSeriesItem("test");
					
					var testview = unittestGenerator.createViewsTest(table);
					ArrayAppend(files, testview);
					
					var testEntity = unittestGenerator.createEntityTest(table);
					ArrayAppend(files, testEntity);
					
					//Only generate service tests if we are generating services.
					if (config.getCreateServices()){
						var testService = unittestGenerator.createServiceTest(table);
						ArrayAppend(files, testService);
					}
					
					variables.log.endEventSeriesItem("test");
				}
			}//IsProperTable?	
		}//for loop
		
		
		//Generate extended unit testing pieces to compensate for Application coupling to ORM 
		if (config.getCreateTests()){
			var remoteFacade = unittestGenerator.createRemoteFacade();
			ArrayAppend(files, remoteFacade);
			
			var HttpAntRunner = unittestGenerator.createHttpAntRunner();
			ArrayAppend(files, HttpAntRunner);
			
			var directoryRunner = unittestGenerator.createDirectoryRunner();
			ArrayAppend(files, directoryRunner);
			
			var EntityRunner = unittestGenerator.createDirectoryRunner(variables.config.getTestFilePath() & FS & "/entity");
			ArrayAppend(files, EntityRunner);
			
			var ViewRunner = unittestGenerator.createDirectoryRunner(variables.config.getTestFilePath() & FS & "/view");
			ArrayAppend(files, ViewRunner);
			
			if (config.getCreateServices()){
				var ServiceRunner = unittestGenerator.createDirectoryRunner(variables.config.getTestFilePath() & FS & variables.config.getServiceFolder());
				ArrayAppend(files, ServiceRunner);
			}
			
			var GlobalTest = unittestGenerator.createGlobalTest();
			ArrayAppend(files, GlobalTest);
			
			var antRunner = unittestGenerator.createAntRunner();
			ArrayAppend(files, antRunner);
		}
	
	}
	
	/**
	* @hint Gets an array of the path of each file that would be generated by the application.
	*/
	public array function getAllGeneratedFilePaths(){
		var i = 0;
		var result = ArrayNew(1);
		for (i=1; i <= ArrayLen(files); i++){
			ArrayAppend(result, files[i].getFileName());
		}
		
		return result;
	}
	
	/**
	* @hint Writes all of the files to disk. 
	*/
	public void function writeFiles(){
		var i = 0;
		for (i=1; i <= ArrayLen(files); i++){
			files[i].write();
		}
	}

	/**
	* @hint Returns the total count of files that would created by generate 
	*/
	public numeric function fileCount(){
		return ArrayLen(files);
	}
	
	
}