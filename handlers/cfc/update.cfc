component{


	public function init(required string currentVersion, required buildURL, required appURL){
	
    	variables.currentVersion = arguments.currentVersion;
		variables.buildURL = arguments.buildURL;
		variables.appURL = arguments.appURL;	
    	return This;
    }
    
	public string function getLatestVersion(){
		var httpObj = New http();
		httpObj.setUrl(variables.buildURL);
		var result = httpObj.send();
		var trans = result.getPrefix().fileContent;
		return trans;	
		
	}

	public boolean function shouldUpdate(){
		if (not isNumeric(variables.currentVersion)){
			return false;
		}
		var latestVersion = getLatestVersion();
	
		if (latestVersion > variables.currentVersion){
			return true;
		}
		else{
			return false;
		}
	}
	
	public void function getLatestZip(required string filepath){
		var directory = arguments.filepath;
		var httpObj = New http();
		httpObj.setUrl(variables.appURL & "?" & createUUID() );
		httpObj.setGetAsBinary("yes");
		httpObj.setPath(directory);
		httpObj.setFile("Apptacular.zip");
		var result = httpObj.send();
	
	
	}

}
