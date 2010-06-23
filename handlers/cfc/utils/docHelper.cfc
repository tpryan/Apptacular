component{

	public function init(any config){
		variables.propStruct = buildPropStruct(arguments.config);
    		
    	return This;
    }
    
	public string function getDisplayName(string property){
		
		if (structKeyExists(variables.propStruct, arguments.property)){
			return variables.propStruct[arguments.property]['displayName'];
		}
		else{
			return arguments.property;
		}
		
	}
	
	private struct function buildPropStruct(any config){
		var info = getComponentMetaData(arguments.config).properties;
		var i = 0;
		var results = {};
		
		for (i = 1; i <= ArrayLen(info); i++){
			var item = info[i];
			results[item.name] = {};
			
			if (structKeyExists(item, "displayName")){
				results[item.name]['displayName'] = item['displayName'];
			}
			else{
				results[item.name]['displayName'] = item['name'];
			}
		}
		
		return results;
	}


}
