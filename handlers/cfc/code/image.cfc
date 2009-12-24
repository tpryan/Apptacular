component displayname="image" extends="file" hint="A cfc representation of an image for code generation." accessors="true"{

	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public image function init(){
		variables.origfileLocation ="";
		
		return This;
	}
	
	
	/**
	* @hint Inserts the contents of a file into the generated file.
	*/
	public void function insertImage(required string filePath){
		variables.origfileLocation = arguments.filePath;
	
	}
	
	/**
		* @hint Writes the file to disk.
	*/
	public void function write(){
		conditionallyCreateDirectory(This.getFileLocation());
		FileCopy(variables.origfileLocation, This.getFileName());
		
	}
	
	
}