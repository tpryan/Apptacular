/**
* @hint Manages the configuration of all of the options of an application.  
*/
component accessors="true"{
	
	property name="rootURL" displayName="Root URL" hint="The url that corresponds to the rootFilePath";		
	property name="rootFilePath" displayName="Root File Path" hint="The root directory under which all Apptacular files will be written.";
	property name="rootCFCPath" displayName="Root CFC Path" hint="The CFC format path that corresponds to the rootFilePath";
	property name="rootRelativePath" displayName="Root Relative" hint="The relative url (server omitted) that corresponds to the rootURL";			
	
	//URLS
	property name="testURL" displayName="Unit Test URL"  hint="The url that corresponds to the testFilePath";		
	
	//File paths
	property name="customTagFilePath" displayName="Custom Tag File Path" hint="The directory under the root where the custom tags will be written. [Computed from rootURL and customTagFolder]";
	property name="entityFilePath" displayName="ORM Entities File Path" hint="The directory under the root where the entity CFCs will be written. [Computed from rootURL and entityTagFolder]";
	property name="serviceFilePath" displayName="Services File Path" hint="The directory under the root where the service CFCs will be written. [Computed from rootURL and serviceFolder]";
	property name="cssFilePath" displayName="CSS File Path" hint="The directory under the root where the css files and accompanying images will be written. [Computed from rootURL and cssFolder]";
	property name="testFilePath" displayName="Unit Test File Path" hint="The directory under the root where the test cases will be written. [Computed from rootURL and testFolder]";
	property name="appFilePath"displayName="Application File Path"  hint="The directory under the root where the application will be written. [Computed from rootURL and testFolder]";
	property name="mxunitFilePath" displayName="MXUnit Framework File Path" hint="The directory where the MXUnit files will be found.";
	
	//Relative Paths
	property name="cssRelativePath" hint="The relative url (server omitted) that corresponds to the cssFilePath. [Computed from cssFilePath]";		
	property name="testRelativePath" hint="The relative url (server omitted) that corresponds to the testFilePath. [Computed from testFilePath]";	
	
	//Folders
	property name="customTagFolder" displayName="Custom Tag Folder" hint="The subfolder under the root where the custom tags will be written.";
	property name="entityFolder" displayName="ORM Entity Folder" hint="The subfolder under the root where the entity CFCs will be written.";
	property name="serviceFolder" displayName="Service Folder" hint="The subfolder under the root where the service CFCs will be written.";
	property name="cssFolder" displayName="CSS Folder" hint="The subfolder under the root where the css files and accompanying images will be written.";
	property name="testFolder" displayName="Unit Test Folder" hint="The subfolder under the root where the test cases will be written.";
	property name="appFolder" displayName="Application Folder" hint="The subfolder under the root where the application files will be written.";
	
	//CFC paths	
	property name="EntityCFCPath" hint="The CFC format path that corresponds to the entityFilePath";	
	property name="serviceCFCPath" hint="The CFC format path that corresponds to the serviceFilePath";	
	property name="testCFCPath" hint="The CFC format path that corresponds to the testFilePath";	
	property name="mxunitCFCPath" hint="The CFC Path where the MXUnit files will be found.";
	
	property name="serviceAccess" displayName="Service Access"  hint="Whether or not your services to be accessible or not. [Options: public, remote]";
	property name="CreateViews" displayName="Create Views" type="boolean" hint="Whether or not Apptacular should create view files (index.cfm, plus tabname.cfm, and custom tags.)";
	property name="CreateAppCFC" displayName="Create Application.cfc" type="boolean" hint="Whether or not Apptacular should create a Application.cfc";
	property name="CreateServices" displayName="Create Services" type="boolean" hint="Whether or not Apptacular should create services";
	property name="CreateEntities" displayName="Create ORM Entities"  type="boolean"  hint="Whether or not Apptacular should create entity files";
	property name="CreateLogin" displayName="Create Login Protection" type="boolean" hint="Whether or not Apptacular should wire up login framework.";
	property name="CreateTests" displayname="Create Unit Tests" type="boolean" hint="Whether or not Apptacular should write default unit tests.";
	property name="WireOneToManyinViews" displayName="Wire One to Many relationships in views "  type="boolean" hint="Whether or not Apptacular should write out oneToMany interfaces in view. Good to turn off if you have tables with 1000's of records wired to a oneToMany.";
	property name="LogSQL" displayName="Log SQL" type="boolean" hint="Whether or not generated application should log Hibernate SQL operations to the console.";
	property name="ReturnQueriesFromService" displayName="Return Queries from Services instead of ORM Arrays"  type="boolean" hint="Whether or not generated application return queries instead of arrays of ORM objects.";
	property name="MakeSuperSerivces" displayName="Generate Super Service that are extendable by services that you can edit." type="boolean" hint="Whether or not to generate dynamic super services that are extended by a static, editable, base class.";
	property name="MakeSuperEntities" displayName="Generate Super Entities that can be edited but are extended by static entities." type="boolean" hint="Whether or not to generate editable static super services that are extended by a dynamic, non-editable, base class.";  
	
	property name="CFCFormat" hint="Whether or not your CFCs are all CFML or all CFScript. [Options: CFML, CFSCRIPT]";
	
	property name="depluralize" displayName="Depluralize"   hint="Whether or not Apptacular should depluralize your entity names. Experimental, may not yeild perfect results.";
	
	
	property name="createdOnString" displayName="Created on String"  hint="The magic string for DateTime of object creation";
	property name="updatedOnString" displayName="Updated on String" hint="The magic string for DateTime of object last update";
	
	property name="dateformat" displayName="Date Format"  hint="The format in which to display dates in views.";
	property name="timeformat" displayName="Time Format"  hint="The format in which to display times in views.";
	
	property name="OverwriteDataModel" type="boolean" hint="Setting this to true will allow config XML to become authoritative. Don't do this until you are mostly done messing around with model.";
	property name="LockApplication" displayName="Lock Application"   type="boolean" hint="Setting this to true will prevent any new files from being written or modified by the Apptacular extension";
	property name="selectorThreshold" displayName="Number of related items that will block relationship building in views"   type="numeric" hint="The number of items in a related table past which we don't want to create drop down menus that will cause the system to slow down like crazy.";
	
	//Service method names, allows changed list to GetAll, if that's your preferred syntax'
	property name="serviceGetMethod" displayName="Get method name"  type="string" hint="The name of the method in a serivice that retrieves a single record.";
	property name="serviceUpdateMethod" displayName="Update method name"  type="string" hint="The name of the method in a serivice that updates a single record.";
	property name="serviceDeleteMethod" displayName="Delete method name"  type="string" hint="The name of the method in a serivice that deletes a single record.";
	property name="serviceListMethod" displayName="List method name"  type="string" hint="The name of the method in a serivice that retrieves a all records.";
	property name="serviceListPagedMethod" displayName="List Paged method name"  type="string" hint="The name of the method in a serivice that retrieves a all records, in pages.";
	property name="serviceSearchMethod" displayName="Search method name"  type="string" hint="The name of the method in a serivice searches for records.";
	property name="serviceSearchPagedMethod" displayName="Search Paged method name"  type="string" hint="The name of the method in a serivice searches for records, in pages.";
	property name="serviceInitMethod" displayName="Init method name"  type="string" hint="The name of the method in a serivice that acts as the constructor.";
	property name="serviceCountMethod" displayName="Count method name"  type="string" hint="The name of the method in a serivice that returns a count of records in the underlying table.";
	property name="ServiceSearchCountMethod" displayName="Search Count method name"  type="string" hint="The name of the method in a service that returns the count of records in a search result.";
	
	property name="DBCreate" displayName="Ormsettings DBCreate"  type="string" hint="How should ORM react to new CFC's, should it create new tables, or ignore them. Valid options: none, update (apptacular default), dropcreate";
	
	
	property name="CSSFileName" displayname="CSS File Name" type="string" hint="The name of the CSS file to use. Helpful to replace Apptacular regenerated CSS with your own.";
	
	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public function init(required string rootFilePath, required string rootCFCPath){
	
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
    	
		if (CompareNoCase(right(arguments.rootFilePath, 1),variables.FS) neq 0){
			This.setRootFilePath(arguments.rootFilePath & FS);
		}
		else{
			This.setRootFilePath(arguments.rootFilePath);
		}
		
		This.setRootUrl(calculateURL(This.getRootFilePath(), ExpandPath("/")));
		
		This.setRootCFCPath(arguments.rootCFCPath);
		This.setMXunitCFCPath("mxunit");
		This.setMXUnitFilePath(calculateMXUnitFilePath());
		
		This.setcustomTagFolder("customTags");
		This.setEntityFolder("cfc");
		This.setServiceFolder("services");
		This.setCSSFolder("css");
		This.setTestFolder("test");
		This.setAppFolder("");
		
		This.setCreatedOnString("createdOn");
		This.setUpdatedOnString("updatedOn");
		
		calculatePaths();
	
		//Settings defaults for these settings
		setConfigDefaults();
			
    	return This;
    }
	
	private void function setConfigDefaults(){
		This.setServiceAccess("public");
		This.setCreateViews(true);
		This.setCreateAppCFC(true);
		This.setCreateServices(true);
		This.setCreateEntities(true);
		This.setCreateLogin(false);
		This.setCreateTests(false);
		This.setCFCFormat("cfscript");
		
		This.setOverwriteDataModel(false);
		This.setLockApplication(false);
		This.setWireOneToManyinViews(true);
		This.setLogSQL(true);
		This.setSelectorThreshold(50);
		This.setDepluralize(false);
		This.setDateFormat("mm/dd/yyyy");
		This.setTimeFormat("h:mm tt");
		This.setCSSFileName("screen.css");
	
		This.setServiceDeleteMethod("destroy");
		This.setServiceGetMethod("get");
		This.setServiceInitMethod("init");
		This.setServiceListMethod("list");
		This.setServiceListPagedMethod("listPaged");
		This.setServiceSearchMethod("search");
		This.setServiceSearchPagedMethod("searchPaged");
		This.setServiceUpdateMethod("update");
		This.setServiceCountMethod("count");
		This.setServiceSearchCountMethod("searchCount");
		This.setReturnQueriesFromService("false");			
		This.setMakeSuperSerivces("false");
		This.setMakeSuperEntities("false");
		This.setDBCreate("update");
	}
	
	/**
	* @hint Calculates the url of file paths that are passed in. 
	*/
	private string function calculateURL(required string path, required string webroot){
		var rootRelativePath = ReplaceNoCase(arguments.path, arguments.webroot, "", "one");
		
		if (compare(Right(rootRelativePath, 1), "/") eq 0 OR 
			compare(Right(rootRelativePath, 1), "\") eq 0 ){
			rootRelativePath = Left(rootRelativePath, Len(rootRelativePath)-1);
		}
			
		var result = cgi.server_name & "/" & rootRelativePath;
		result = Replace(result, "\","/", "all");
		result = Replace(result, "//","/", "all");
		result = "http://" & result;

		return result;
	}
	
	/**
	* @hint Computes the file path from the CFC path
	*/
	private string function calculateMXUnitFilePath(){
		var webroot = ExpandPath("/");
		var mxunitRelativePath = Replace( This.getMXunitCFCPath(), ".", variables.FS, "all" );
		var result = webroot & mxunitRelativePath;
		
		if (compare(Right(result, 1), "/") eq 0 OR 
			compare(Right(result, 1), "\") eq 0 ){
			result = Left(result, Len(result)-1);
		}
		
		
		return result;
	}
	
	/**
	* @hint Generates all of the paths that are not user configurable
	*/
	public void function calculatePaths(){
		This.setcustomTagFilePath(This.getRootFilePath() & This.getcustomTagFolder());
		This.setEntityFilePath(This.getRootFilePath() & This.getEntityFolder());
		This.setServiceFilePath(This.getRootFilePath() & This.getServiceFolder());
		This.setCSSFilePath(This.getRootFilePath() & This.getCSSFolder());
		This.setTestFilePath(This.getRootFilePath() & This.getTestFolder());
		This.setAppFilePath(This.getRootFilePath() & This.getAppFolder());
		
		//Calculate CFC paths
		This.setEntityCFCPath(This.getRootCFCPath() & "." & This.getEntityFolder());
		This.setServiceCFCPath(This.getRootCFCPath() & "." & This.getServiceFolder());
		This.setTestCFCPath(This.getRootCFCPath() & "." & This.getTestFolder());

		//Calcualte Relative Paths
		var webroot = expandPath("/");
		
		This.setRootRelativePath("/" & Replace(ReplaceNoCase(This.getRootFilePath(), webroot, "", "once"),"\", "/", "all" ));
		This.setCssRelativePath("/" & Replace(ReplaceNoCase(This.getCSSFilePath(), webroot, "", "once"),"\", "/", "all" ));
		This.setTestRelativePath("/" & Replace(ReplaceNoCase(This.getTestFilePath(), webroot, "", "once"),"\", "/", "all" ));
		
		//Calculate urls
		This.setTestURL(calculateURL(This.getTestFilePath(), ExpandPath("/")));
		
	}
	
	/**
	* @hint If the field name passed in is one of the magic column names. 
	*/
	public boolean function isMagicField(required string columnName){
		if ((CompareNoCase(arguments.columnName, This.getCreatedOnString()) eq 0) OR
			(CompareNoCase(arguments.columnName, This.getUpdatedOnString()) eq 0)){
			return TRUE;
		}
		else{
			return FALSE;
		}
	}
	
	/**
	* @hint Creates an XML representation of the configuration
	*/
	public string function toXML(){
		var str = createObject("java", "java.lang.StringBuilder").init();
		var NL = CreateObject("java", "java.lang.System").getProperty("line.separator");
		var props = Duplicate(variables);
		var i = 0;

		StructDelete(props, "This");
		StructDelete(props, "FS");
		StructDelete(props, "NL");
		
		var keys = StructKeyArray(props);
		ArraySort(keys, "textnocase");
		
		str.append('<?xml version="1.0" encoding="iso-8859-1"?>');
		str.append(NL);
		
		str.append('<config>');
		str.append(NL);
		
		for (i=1; i <= ArrayLen(keys); i++){
			if (not IsCustomFunction(props[keys[i]]) ){
				str.append('	');
				str.append('<#keys[i]#>');
				str.append('#props[keys[i]]#');
				str.append('</#keys[i]#>');
				str.append(NL);
			}
		}
		
		str.append('</config>');
		str.append(NL);
		
		return str.toString();
	} 
	
	/**
	* @hint Writes the configuration to an XML file.
	*/
	public string function writeToDisk(){
		var DirToWrite = This.getRootFilePath() & ".apptacular";
		var FileToWrite = DirToWrite & "/config.xml";
		
		conditionallyCreateDirectory(DirToWrite);
		FileWrite(FileToWrite, This.toXML());
	}
	
	/**
	* @hint Overwrites the configuration from the disk configuration
	*/
	public void function overwriteFromDisk(){
		
		var FileToRead = This.getRootFilePath() & ".apptacular/config.xml";
		
		if (FileExists(FileToRead)){
			var XML = xmlParse(FileRead(FileToRead));
			var keys = StructKeyArray(xml.config);
			var i = 0;
			
			for (i=1; i <= ArrayLen(keys); i++){
				var setter = This['set#keys[i]#'];
				setter(xml.config[keys[i]].xmlText);
			}
		}
		

	}
	
	/**
	* @hint Creates a directory if it doesn't exist.
	*/	
	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
}