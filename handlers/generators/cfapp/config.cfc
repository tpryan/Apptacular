/**
* @hint Manages the configuration of all of the options of an application.  
*/
component accessors="true"{
	
	property name="rootURL" hint="The url that corresponds to the rootFilePath";		
	property name="rootFilePath" hint="The root directory under which all Apptacular files will be written.";
	property name="rootCFCPath" hint="The CFC format path that corresponds to the rootFilePath";
	property name="rootRelativePath" hint="The relative url (server omitted) that corresponds to the rootURL";			
	
	//URLS
	property name="testURL" hint="The url that corresponds to the testFilePath";		
	
	//File paths
	property name="customTagFilePath" hint="The directory under the root where the custom tags will be written. [Computed from rootURL and customTagFolder]";
	property name="entityFilePath" hint="The directory under the root where the entity CFCs will be written. [Computed from rootURL and entityTagFolder]";
	property name="serviceFilePath" hint="The directory under the root where the service CFCs will be written. [Computed from rootURL and serviceFolder]";
	property name="cssFilePath" hint="The directory under the root where the css files and accompanying images will be written. [Computed from rootURL and cssFolder]";
	property name="testFilePath" hint="The directory under the root where the test cases will be written. [Computed from rootURL and testFolder]";
	property name="appFilePath" hint="The directory under the root where the application will be written. [Computed from rootURL and testFolder]";
	property name="mxunitFilePath" hint="The directory where the MXUnit files will be found.";
	
	//Relative Paths
	property name="cssRelativePath" hint="The relative url (server omitted) that corresponds to the cssFilePath. [Computed from cssFilePath]";		
	property name="testRelativePath" hint="The relative url (server omitted) that corresponds to the testFilePath. [Computed from testFilePath]";	
	
	//Folders
	property name="customTagFolder" hint="The subfolder under the root where the custom tags will be written.";
	property name="entityFolder" hint="The subfolder under the root where the entity CFCs will be written.";
	property name="serviceFolder" hint="The subfolder under the root where the service CFCs will be written.";
	property name="cssFolder" hint="The subfolder under the root where the css files and accompanying images will be written.";
	property name="testFolder" hint="The subfolder under the root where the test cases will be written.";
	property name="appFolder" hint="The subfolder under the root where the application files will be written.";
	
	//CFC paths	
	property name="EntityCFCPath" hint="The CFC format path that corresponds to the entityFilePath";	
	property name="serviceCFCPath" hint="The CFC format path that corresponds to the serviceFilePath";	
	property name="testCFCPath" hint="The CFC format path that corresponds to the testFilePath";	
	property name="mxunitCFCPath" hint="The CFC Path where the MXUnit files will be found.";
	
	property name="serviceAccess" hint="Whether or not your services to be accessible or not. [Options: public, remote]";
	property name="CreateViews" type="boolean" hint="Whether or not Apptacular should create view files (index.cfm, plus tabname.cfm, and custom tags.)";
	property name="CreateAppCFC" type="boolean" hint="Whether or not Apptacular should create a Application.cfc";
	property name="CreateServices" type="boolean" hint="Whether or not Apptacular should create services";
	property name="UseServices" type="boolean" hint="Whether or not Apptacular should use services in lieu of Entity functions [Not implemented yet]";
	property name="CreateEntities" type="boolean"  hint="Whether or not Apptacular should create entity files";
	property name="CreateLogin" type="boolean" hint="Whether or not Apptacular should wire up login framework.";
	property name="CreateTests" type="boolean" hint="Whether or not Apptacular should write default unit tests.";
	property name="WireOneToManyinViews" type="boolean" hint="Whether or not Apptacular should write out oneToMany interfaces in view. Good to turn off if you have tables with 1000's of records wired to a oneToMany.";
	property name="LogSQL" type="boolean" hint="Whether or not generated application should log Hibernate SQL operations to the console.";
	
	property name="CFCFormat" hint="Whether or not your CFCs are all CFML or all CFScript. [Options: CFML, CFSCRIPT]";
	
	property name="createdOnString" hint="The magic string for DateTime of object creation";
	property name="updatedOnString" hint="The magic string for DateTime of object last update";
	
	property name="dateformat" hint="The format in which to display dates in views.";
	property name="timeformat" hint="The format in which to display times in views.";
	
	property name="OverwriteDataModel" type="boolean" hint="Setting this to true will allow config XML to become authoritative. Don't do this until you are mostly done messing around with model.";
	property name="LockApplication" type="boolean" hint="Setting this to true will prevent any new files from being written or modified by the Apptacular extension";
	property name="selectorThreshold" type="numeric" hint="The number of items in a related table past which we don't want to create drop down menus that will cause the system to slow down like crazy.";
	
	
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
		
		This.setServiceAccess("remote");
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
		
		This.setDateFormat("mm/dd/yyyy");
		
		This.setTimeFormat("h:mm tt");
			
    	return This;
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