component{
	
	public function init(){
    		
    	return This;
    }
    
	public void function setConfigFile(required string configFile){
		if (fileExists(arguments.configFile)){
			variables.configFile = arguments.configFile;
			variables.Config = XMLParse(FileRead(variables.configFile)).config;
		}
		else{
			throw "Config File #arguments.configFile# does not Exist";
		}
	}	
	
	public struct function getConfigs(){
		var results = {};
		var keys = structKeyArray(variables.config);
		var i = 0;
		
		for (i = 1; i <= ArrayLen(keys); i++){
			results[keys[i]] = variables.Config[keys[i]].xmlText;
		}
		
		return results;
	}
	
	public void function setConfigs(required struct updatedConfig){
		var keys = structKeyArray(arguments.updatedConfig);
		var i = 0;
		
		var results = {};
		
		
		for (i = 1; i <= ArrayLen(keys); i++){
			if (structKeyExists(variables.Config, keys[i])){
				if (FindNoCase("true", arguments.updatedConfig[keys[i]]) AND
					FindNoCase("false", arguments.updatedConfig[keys[i]])
				){
					arguments.updatedConfig[keys[i]] = true;
				}
				variables.Config[keys[i]].xmlText = Trim(arguments.updatedConfig[keys[i]]);
			} 
		}
		
	}
	
	public string function getSetting(required string setting){
		
		var result = "";
		
		if (structKeyExists(variables.Config, arguments.setting)){
			var	result = variables.Config[arguments.setting].xmlText;
		}
		
		return result;
	}
	
	public void function save(){
		FileWrite(variables.configFile, variables.Config);
	}

}
