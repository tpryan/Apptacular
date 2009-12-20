component 
{

	public function init(){
		variables.datatypes = {};
		
		var defaultinteger = {type="numeric",ormtype="integer",uitype="string"};
		var defaultstring = {type="string",ormtype="string",uitype="string"};
		
		//Various Integers
		datatypes['int'] = defaultinteger;
		datatypes['integer'] = defaultinteger;
		datatypes['tinyint'] = defaultinteger;
		datatypes['smallint'] = defaultinteger;
		datatypes['INT UNSIGNED'] = defaultinteger;
		datatypes['SMALLINT UNSIGNED'] = defaultinteger;
		datatypes['TINYINT UNSIGNED'] = defaultinteger;
		datatypes['MEDIUMINT UNSIGNED'] = defaultinteger;
		
		//various strings
		datatypes['varchar'] = defaultstring;
		datatypes['varchar2'] = defaultstring;
		datatypes['enum'] = defaultstring;
		datatypes['set'] = defaultstring;
		
		
		//numerics
		datatypes['number']['type'] = "numeric";
		datatypes['number']['ormType'] = "big_decimal";
		datatypes['number']['uiType'] = "string";
		
		datatypes['decimal']['type'] = "numeric";
		datatypes['decimal']['ormType'] = "long";
		datatypes['decimal']['uiType'] = "string";
	
	
		//Chars text other strings
		datatypes['char']['type'] = "string";
		datatypes['char']['ormType'] = "character";
		datatypes['char']['uiType'] = "string";		
		
		datatypes['text']['type'] = "string";
		datatypes['text']['ormType'] = "text";
		datatypes['text']['uiType'] = "text";
	
	
		//Various Booleans
		datatypes['boolean']['type'] = "boolean";
		datatypes['boolean']['ormType'] = "boolean";
		datatypes['boolean']['uiType'] = "boolean";

		datatypes['yes_no']['type'] = "boolean";
		datatypes['yes_no']['ormType'] = "yes_no";
		datatypes['yes_no']['uiType'] = "boolean";

		datatypes['true_false']['type'] = "boolean";
		datatypes['true_false']['ormType'] = "true_false";
		datatypes['true_false']['uiType'] = "boolean";
		
		//various ob's
		datatypes['clob']['type'] = "clob";
		datatypes['clob']['ormType'] = "clob";
		datatypes['clob']['uiType'] = "text";
		
		datatypes['blob']['type'] = "blob";
		datatypes['blob']['ormType'] = "blob";
		datatypes['blob']['uiType'] = "blob";
		
		
		//various dates
		datatypes['date']['type'] = "date";
		datatypes['date']['ormType'] = "date";
		datatypes['date']['uiType'] = "date";
		
		datatypes['time']['type'] = "date";
		datatypes['time']['ormType'] = "time";
		datatypes['time']['uiType'] = "time";
		
		datatypes['timestamp']['type'] = "date";
		datatypes['timestamp']['ormType'] = "timestamp";
		datatypes['timestamp']['uiType'] = "datetime";
		
		datatypes['datetime']['type'] = "date";
		datatypes['datetime']['ormType'] = "timestamp";
		datatypes['datetime']['uiType'] = "datetime";
		
		datatypes['year']['type'] = "numeric";
		datatypes['year']['ormType'] = "integer";
		datatypes['year']['uiType'] = "string";
		
		
			
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