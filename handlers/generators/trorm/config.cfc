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
	
	public function init(required string rootFilePath, required string rootCFCPath){
	
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");	
    	
		if (CompareNoCase(right(arguments.rootFilePath, 1),variables.FS) neq 0){
			This.setRootFilePath(arguments.rootFilePath & FS);
		}
		else{
			This.setRootFilePath(arguments.rootFilePath);
		}
		
		This.setRootFilePath(arguments.rootFilePath);
		This.setRootCFCPath(arguments.rootCFCPath);
		
		This.setcustomTagFolder("customTags");
		This.setEntityFolder("cfc");
		This.setServiceFolder("services");
		This.setCSSFolder("css");
		
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
	
	
}