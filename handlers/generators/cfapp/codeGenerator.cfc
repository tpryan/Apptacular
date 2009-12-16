component 
{
	
	public any function init(required any datasource, required any config){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.FS = createObject("java", "java.lang.System").getProperty("file.separator");
		variables.datasource = arguments.datasource;
		variables.config = arguments.config;
				
		return This;
	}

	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}

}