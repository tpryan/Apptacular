/**
 * @hint Hard codes all constant values for use in the application. 
 */
component 
{

	/**
	 * @hint You know, an init. 
	 */
	public function init(){
		variables.datatypes = {};
		
		var defaultinteger = {type="numeric",ormtype="integer",uitype="string"};
		var defaultstring = {type="string",ormtype="string",uitype="string"};
		var defaultnumeric = {type="numeric",ormtype="float",uitype="string"};
		var defaulttext = {type="string",ormtype="text",uitype="text"};
		var defaultchar = {type="string",ormtype="string",uitype="string"};
		var defaultvalue = {type="string",ormtype="string",uitype="string"};
		
		//Various Integers
		datatypes['int'] = defaultinteger;
		datatypes['integer'] = defaultinteger;
		datatypes['tinyint'] = defaultinteger;
		datatypes['smallint'] = defaultinteger;
		datatypes['INT UNSIGNED'] = defaultinteger;
		datatypes['SMALLINT UNSIGNED'] = defaultinteger;
		datatypes['TINYINT UNSIGNED'] = defaultinteger;
		datatypes['MEDIUMINT UNSIGNED'] = defaultinteger;
		datatypes['int identity'] = defaultinteger;
		datatypes['tinyint identity'] = defaultinteger;
		datatypes['smallint identity'] = defaultinteger;
		
		//various strings
		datatypes['nvarchar'] = defaultstring;
		datatypes['varchar'] = defaultstring;
		datatypes['varchar2'] = defaultstring;
		datatypes['enum'] = defaultstring;
		datatypes['set'] = defaultstring;
		datatypes['sysname'] = defaultstring;
		datatypes['name'] = defaultstring;
		datatypes['uniqueidentifier'] = defaultstring;
		
		datatypes['default'] = defaultvalue;
		
		//numerics
		datatypes['number'] = defaultnumeric;
		datatypes['decimal'] = defaultnumeric;
		datatypes['numeric'] = defaultnumeric;
		datatypes['money'] = defaultnumeric;
	
	
		//Chars text other strings
		datatypes['char'] = defaultchar;
		datatypes['nchar'] = defaultchar;	
		
		datatypes['text'] = defaulttext;
		datatypes['ntext'] = defaulttext;
		datatypes['xml'] = defaulttext;
	
	
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
		
		datatypes['bit']['type'] = "boolean";
		datatypes['bit']['ormType'] = "boolean";
		datatypes['bit']['uiType'] = "boolean";
		
		datatypes['flag']['type'] = "boolean";
		datatypes['flag']['ormType'] = "boolean";
		datatypes['flag']['uiType'] = "boolean";
		
		//various ob's
		datatypes['clob']['type'] = "clob";
		datatypes['clob']['ormType'] = "clob";
		datatypes['clob']['uiType'] = "text";
		
		datatypes['blob']['type'] = "binary";
		datatypes['blob']['ormType'] = "binary";
		datatypes['blob']['uiType'] = "binary";
		
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

	/**
	 * @hint gets the Ormtype for a given datatype
	 */
	public string function getOrmType(required string datatype){
		
		if (structKeyExists(datatypes, arguments.datatype)){
			var dataTypeInfo = datatypes[arguments.datatype];		
		}
		else{
			var dataTypeInfo = datatypes['default'];
		}
		
		return dataTypeInfo['ormType'];
	}

	/**
	 * @hint gets the type for a given datatype
	 */
	public string function getType(required string datatype){
		
		if (structKeyExists(datatypes, arguments.datatype)){
			var dataTypeInfo = datatypes[arguments.datatype];		
		}
		else{
			var dataTypeInfo = datatypes['default'];
		}
		
		return dataTypeInfo['Type'];
	}

	/**
	 * @hint gets the UItype for a given datatype
	 */
	public string function getUIType(required string datatype){
		
		if (structKeyExists(datatypes, arguments.datatype)){
			var dataTypeInfo = datatypes[arguments.datatype];		
		}
		else{
			var dataTypeInfo = datatypes['default'];
		}
		
		return dataTypeInfo['UIType'];
	}


}