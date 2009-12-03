component 
{

	public function init(){
		variables.datatypes = {};
		
		datatypes['int']['type'] = "numeric";
		datatypes['integer']['type'] = "numeric";
		datatypes['tinyint']['type'] = "numeric";
		datatypes['INT UNSIGNED']['type'] = "numeric";
		datatypes['smallint']['type'] = "numeric";
		datatypes['number']['type'] = "numeric";
		datatypes['decimal']['type'] = "numeric";
	
		datatypes['varchar']['type'] = "string";
		datatypes['varchar2']['type'] = "string";
		datatypes['enum']['type'] = "string";
		datatypes['char']['type'] = "string";
		
		datatypes['text']['type'] = "string";
	
		datatypes['boolean']['type'] = "boolean";
		datatypes['yes_no']['type'] = "boolean";
		datatypes['true_false']['type'] = "boolean";
	
		datatypes['date']['type'] = "date";
		datatypes['time']['type'] = "date";
		datatypes['timestamp']['type'] = "date";
		datatypes['datetime']['type'] = "date";
	
		datatypes['clob']['type'] = "clob";
		datatypes['blob']['type'] = "blob";
		
		
		
		
		datatypes['int']['ormType'] = "integer";
		datatypes['integer']['ormType'] = "integer";
		datatypes['tinyint']['ormType'] = "integer";
		datatypes['INT UNSIGNED']['ormType'] = "integer";
		datatypes['smallint']['ormType'] = "short";
		datatypes['number']['ormType'] = "big_decimal";
		datatypes['decimal']['ormType'] = "long";
	
		datatypes['varchar']['ormType'] = "string";
		datatypes['varchar2']['ormType'] = "string";
		datatypes['enum']['ormType'] = "string";
		datatypes['char']['ormType'] = "character";
		
		datatypes['text']['ormType'] = "text";
	
		datatypes['boolean']['ormType'] = "boolean";
		datatypes['yes_no']['ormType'] = "yes_no";
		datatypes['true_false']['ormType'] = "true_false";
	
		datatypes['date']['ormType'] = "date";
		datatypes['time']['ormType'] = "time";
		datatypes['timestamp']['ormType'] = "timestamp";
		datatypes['datetime']['ormType'] = "timestamp";
	
		datatypes['clob']['ormType'] = "clob";
		datatypes['blob']['ormType'] = "blob";
		
		datatypes['int']['uiType'] = "string";
		datatypes['integer']['uiType'] = "string";
		datatypes['INT UNSIGNED']['uiType'] = "string";
		datatypes['smallint']['uiType'] = "string";
		datatypes['number']['uiType'] = "string";
		datatypes['decimal']['uiType'] = "string";
		datatypes['tinyint']['uiType'] = "string";
	
		datatypes['varchar']['uiType'] = "string";
		datatypes['varchar2']['uiType'] = "string";
		datatypes['char']['uiType'] = "string";
		datatypes['enum']['uitype'] = "string";
		datatypes['text']['uiType'] = "text";
		
	
		datatypes['boolean']['uiType'] = "boolean";
		datatypes['yes_no']['uiType'] = "boolean";
		datatypes['true_false']['uiType'] = "boolean";
	
		datatypes['date']['uiType'] = "date";
		datatypes['time']['uiType'] = "time";
		datatypes['timestamp']['uiType'] = "datetime";
		datatypes['datetime']['uiType'] = "datetime";
	
		datatypes['clob']['uiType'] = "clob";
		datatypes['blob']['uiType'] = "blob";
		
		
			
    	return This;
    }

	public string function getOrmType(required string datatype){
		return datatypes[arguments.datatype]['ormType'];
	}
	
	public string function getType(required string datatype){
		return datatypes[arguments.datatype]['Type'];
	}
	
	public string function getUIType(required string datatype){
		return datatypes[arguments.datatype]['UIType'];
	}


}