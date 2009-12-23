/**
* @hint Base component for the code generator cfcs
*/
component 
{
	/**
	* @hint Wires up all of the base things needed by generators.
	*/
	public any function init(required any datasource, required any config){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.datasource = arguments.datasource;
		variables.config = arguments.config;
				
		return This;
	}

	/**
	* @hint If a directory does not already exists create it. 
	*/
	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}

}