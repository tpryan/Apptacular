component displayname="file" hint="A cfc representation of any file" accessors="true"{
	property name="name" type="string" hint="The name of the file";
	property name="fileLocation" type="string" hint="Path of the folder containing the file.";
	property name="extension" type="string" hint="The extension of the file.";

	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public any function init(){
	
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.body = CreateObject("java","java.lang.StringBuilder").Init();
		
		return This;
	}
	
	/**
		* @hint Returns the content.
	*/
	public string function getFileContent(){
		return variables.body;
	}
	
	/**
		* @hint Adds CFML content to the page.
	*/
	public void function appendBody(string bodyContent=""){
		variables.body.append(arguments.bodyContent & variables.NL);
	}
	
	
	/**
		* @hint Adds all of the pieces together to get the fully qualified path of the file.
	*/
	public string function getFileName(){
		var FS = createObject("java", "java.lang.System").getProperty("file.separator");
		
		if (FindNoCase("ram://", This.getFileLocation())){
			FS = "/";
		}
		
		if (CompareNoCase(right(This.getFileLocation(), 1),FS) eq 0){
			return "#This.getFileLocation()##This.getName()#.#This.getExtension()#";
		}
		else{
			return "#This.getFileLocation()##fs##This.getName()#.#This.getExtension()#";
		}

		
	}
	
	/**
		* @hint Actually writes the file.
	*/
	public void function write(){
		conditionallyCreateDirectory(This.getFileLocation());

		fileWrite(This.getFileName(), Trim(This.getFileContent()));
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