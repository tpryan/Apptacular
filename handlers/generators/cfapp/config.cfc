component accessors="true"{
	
	property name="rootURL";
	property name="rootFilePath";
	property name="rootCFCPath";
	
	//URLS
	property name="testURL";
	
	//File paths
	property name="customTagFilePath";
	property name="entityFilePath";
	property name="serviceFilePath";
	property name="cssFilePath";
	property name="testFilePath";
	property name="mxunitFilePath";
	
	//Relative Paths
	property name="cssRelativePath";
	property name="rootRelativePath";
	property name="testRelativePath";
	
	//Folders
	property name="cssFolder";
	property name="customTagFolder";
	property name="entityFolder";
	property name="serviceFolder";
	property name="testFolder";
	
	//CFC paths	
	property name="mxunitCFCPath";
	property name="serviceCFCPath";
	property name="EntityCFCPath";
	property name="testCFCPath";
	
	property name="serviceAccess";
	property name="CreateViews" type="boolean";
	property name="CreateAppCFC" type="boolean";
	property name="CreateServices" type="boolean";
	property name="UseServices" type="boolean";
	property name="CreateEntities" type="boolean";
	property name="CreateLogin" type="boolean";
	property name="CreateTests" type="boolean";
	property name="CFCFormat";
	
	property name="createdOnString";
	property name="updatedOnString";
	
	property name="dateformat";
	property name="timeformat";
	
	property name="OverwriteDataModel" type="boolean";
	property name="LockApplication" type="boolean";
	
	
	
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
		
		This.setDateFormat("mm/dd/yyyy");
		
		This.setTimeFormat("h:mm tt");
			
    	return This;
    }
	
	private string function calculateURL(required string path, required string webroot){
		var rootRelativePath = Replace(arguments.path, arguments.webroot, "", "one");
		
		if (compare(Right(rootRelativePath, 1), "/") eq 0 OR 
			compare(Right(rootRelativePath, 1), "\") eq 0 ){
			rootRelativePath = Left(rootRelativePath, Len(rootRelativePath)-1);
		}
			
		var result = cgi.server_name & "/" & rootRelativePath;
		result = ReplaceList(result, "//,\","/,");
		result = "http://" & result;

		return result;
	}
	
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
	
	public void function calculatePaths(){
		This.setcustomTagFilePath(This.getRootFilePath() & This.getcustomTagFolder());
		This.setEntityFilePath(This.getRootFilePath() & This.getEntityFolder());
		This.setServiceFilePath(This.getRootFilePath() & This.getServiceFolder());
		This.setCSSFilePath(This.getRootFilePath() & This.getCSSFolder());
		This.setTestFilePath(This.getRootFilePath() & This.getTestFolder());
		
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
	
	public boolean function isMagicField(required string columnName){
		if ((CompareNoCase(arguments.columnName, This.getCreatedOnString()) eq 0) OR
			(CompareNoCase(arguments.columnName, This.getUpdatedOnString()) eq 0)){
			return TRUE;
		}
		else{
			return FALSE;
		}
	
	}
	
	
	
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
	
	public string function writeToDisk(){
		var DirToWrite = This.getRootFilePath() & ".apptacular";
		var FileToWrite = DirToWrite & "/config.xml";
		
		conditionallyCreateDirectory(DirToWrite);
		FileWrite(FileToWrite, This.toXML());
	}
	
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
	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
}