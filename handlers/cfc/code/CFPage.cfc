component displayname="CFPage" hint="A cfc representation of a cfpage for code generation." accessors="true"{
	property name="name" type="string" hint="The name of the page";
	property name="fileLocation" type="string" hint="File path of the page";
	property name="extension" type="string" hint="The file extension of the page";
	property name="format" type="string" hint="CFML or CFScript";

	public CFPage function init(required string name, required string fileLocation){
	
		This.setExtension('cfm');
		This.setFormat('cfml');
		This.setName(arguments.Name);
		This.setFileLocation(arguments.fileLocation);
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.body = CreateObject("java","java.lang.StringBuilder").Init();
		variables.bodyScript = CreateObject("java","java.lang.StringBuilder").Init();
		
		return This;
	}

	/**
		* @hint Adds CFML content to the page.
	*/
	public void function appendBody(string bodyContent=""){
		variables.body.append(arguments.bodyContent & variables.NL);
	}
	
	/**
		* @hint Adds CFScript content to the page.
	*/
	public void function appendBodyScript(string bodyContent=""){
		variables.bodyScript.append(arguments.bodyContent & variables.NL);
	}
	
	/**
		* @hint Returns the page content as CFML.
	*/
	public string function getCFML(){
		return variables.body;
	}
	
	/**
		* @hint Adds all of the pieces together to get the fully qualified path of the file.
	*/
	public string function getFileName(){
		var FS = createObject("java", "java.lang.System").getProperty("file.separator");
		if (CompareNoCase(right(This.getFileLocation(), 1),FS) eq 0){
			return "#This.getFileLocation()##This.getName()#.#This.getExtension()#";
		}
		else{
			return "#This.getFileLocation()##fs##This.getName()#.#This.getExtension()#";
		}

		
	}
	
	/**
		* @hint Writes the file to disk.
	*/
	public void function write(){
		conditionallyCreateDirectory(This.getFileLocation());

		if (CompareNoCase(This.getFormat(), "cfscript") eq 0)
			fileWrite(getFileName(), Trim(getCFScript()));
		else{
			fileWrite(getFileName(), Trim(getCFML()));
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