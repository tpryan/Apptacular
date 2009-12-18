component displayname="build" extends="file" hint="A cfc representation of an ant build file for code generation." accessors="true"{
	property name="projectname" type="string" hint="The name of the project.";
	property name="projectdefault" type="string" hint="The default task to run of the project.";
	

	public build function init(){
		
		This.setProjectname("");
		This.setExtension('xml');
		This.setName('build');
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.body = CreateObject("java","java.lang.StringBuilder").Init();
		variables.header = CreateObject("java","java.lang.StringBuilder").Init();
		variables.footer = CreateObject("java","java.lang.StringBuilder").Init();
		variables.properties = ArrayNew(1);
		
		return This;
	}
	
	public void function appendBody(string bodyContent=""){
		variables.body.append(arguments.bodyContent & variables.NL);
	}
	
	public void function addProperty(required string name, required string value){
		var prop = '<property name="#arguments.name#" value="#arguments.value#" />';
		ArrayAppend(variables.properties, prop);
	}
	
	
	/**
		* @hint Returns the content.
	*/
	public string function getFileContent(){
		var result = CreateObject("java","java.lang.StringBuilder").Init();
		var i = 0;
		
		result.append(getHeader());
		
		for (i = 1; i <= ArrayLen(variables.properties); i++){
			result.append(variables.properties[i] & variables.NL );
		}
		
		
		result.append(variables.body);
		result.append(getFooter());
		return result;
	}
	
	private string function getHeader(){
		variables.header.append('<?xml version="1.0" encoding="UTF-8"?>' & variables.NL);
		variables.header.append('<project name="#This.getProjectName()#"');
		
		if (len(This.getProjectDefault() gt 0)){
			variables.header.append(' default="#This.getProjectDefault()#"');
			
		}
		
		variables.header.append(' basedir=".">' & variables.NL);
		return header;
	}
	
	private string function getFooter(){
		variables.footer.append('</project>' & variables.NL);
		return footer;
	}
	
}