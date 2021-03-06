component displayname="CFPage" extends="file" hint="A cfc representation of a cfpage for code generation." accessors="true"{
	property name="format" type="string" hint="CFML or CFScript";

	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public CFPage function init(required string name, required string fileLocation){
	
		This.setExtension('cfm');
		This.setFormat('cfml');
		This.setName(arguments.Name);
		This.setFileLocation(arguments.fileLocation);
		This.setOverwriteable(true);
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.body = ArrayNew(1);
		variables.bodyScript = ArrayNew(1);
		
		return This;
	}

	/**
	* @hint Adds CFML content to the page.
	*/
	public void function appendBody(string bodyContent=""){
		ArrayAppend(variables.body, arguments.bodyContent & variables.NL);
	}
	
	/**
	* @hint Adds CFScript content to the page.
	*/
	public void function appendBodyScript(string bodyContent=""){
		ArrayAppend(variables.bodyScript,arguments.bodyContent & variables.NL);
	}
	
	/**
	* @hint Returns the page content as CFML.
	*/
	public string function getCFML(){
		return ArrayToList(variables.body, "");
	}
	
	
	/**
	* @hint Writes the file to disk.
	*/
	public void function write(){
		conditionallyCreateDirectory(This.getFileLocation());
	

		if (This.getOverwriteable() or not fileExists(This.getFileName())){
			if (CompareNoCase(This.getFormat(), "cfscript") eq 0)
				fileWrite(getFileName(), Trim(getCFScript()));
			else{
				fileWrite(getFileName(), Trim(getCFML()));
			}
		}
	}
	
	
	/**
	* @hint Allows control over tabs in operations that write to script or cfml
	*/
	private string function getTabs(numeric tabs=0){
		
		if (not structKeyExists(variables.tabs, arguments.tabs)){
			var tab = "	";
			var tabString = ArrayNew(1);
			var i=0;
		
			for (i = 1;i <= arguments.tabs; i++){
				ArrayAppend(tabString,tab);
			}
			
			variables.tabs[arguments.tabs] = ArraytoList(tabString, "");
		}
			
		return variables.tabs[arguments.tabs];
	}	

	
	
}