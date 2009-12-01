component accessors="true"{
	
	
	property name="rootFilePath";
	property name="rootCFCPath";
	
	property name="customTagFilePath";
	property name="entityFilePath";
	property name="serviceFilePath";
	property name="cssFilePath";
	
	property name="cssRelativePath";
	
	property name="cssFolder";
	property name="customTagFolder";
	property name="entityFolder";
	property name="serviceFolder";
	
	property name="EntityCFCPath";
	
	property name="serviceAccess";
	property name="CreateViews" type="boolean";
	property name="CreateAppCFC" type="boolean";
	property name="CreateServices" type="boolean";
	property name="CreateEntities" type="boolean";
	property name="CFCFormat";
	
	property name="createdOnString";
	property name="updatedOnString";
	
	
	
	public function init(required string rootFilePath, required string rootCFCPath){
	
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
    	
		if (CompareNoCase(right(arguments.rootFilePath, 1),variables.FS) neq 0){
			This.setRootFilePath(arguments.rootFilePath & FS);
		}
		else{
			This.setRootFilePath(arguments.rootFilePath);
		}
		
		This.setRootCFCPath(arguments.rootCFCPath);
		
		This.setcustomTagFolder("customTags");
		This.setEntityFolder("cfc");
		This.setServiceFolder("services");
		This.setCSSFolder("css");
		
		This.setCreatedOnString("createdOn");
		This.setUpdatedOnString("updatedOn");
		
		calculatePaths();
		
		This.setServiceAccess("remote");
		This.setCreateViews(true);
		This.setCreateAppCFC(true);
		This.setCreateServices(true);
		This.setCreateEntities(true);
		This.setCFCFormat("cfscript");
			
    	return This;
    }
	
	public void function calculatePaths(){
		This.setcustomTagFilePath(This.getRootFilePath() & This.getcustomTagFolder());
		This.setEntityFilePath(This.getRootFilePath() & This.getEntityFolder());
		This.setServiceFilePath(This.getRootFilePath() & This.getServiceFolder());
		This.setCSSFilePath(This.getRootFilePath() & This.getCSSFolder());
		
		//Calculate CFC paths
		This.setEntityCFCPath(This.getRootCFCPath() & "." & This.getEntityFolder());

		//Calcualte Relative Paths
		var webroot = expandPath("/");
		This.setCssRelativePath(FS & ReplaceNoCase(This.getCSSFilePath(), webroot, "", "once"));
	}
	
	public boolean function skipUI(required string columnName){
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
		var FileToWrite = This.getRootFilePath() & ".apptacular/config.xml";
		FileWrite(FileToWrite, This.toXML());
	}
	
	public string function overwriteFromDisk(){
		var FileToRead = This.getRootFilePath() & ".apptacular/config.xml";
		var XML = xmlParse(FileRead(FileToRead));
		var keys = StructKeyArray(xml.config);
		var i = 0;
		
		for (i=1; i <= ArrayLen(keys); i++){
			var setter = This['set#keys[i]#'];
			setter(xml.config[keys[i]].xmlText);
		}
		
		

	}
	
}