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
		
		var defaultinteger = {type="numeric",ormtype="integer",uitype="string", testtype="numeric"};
		var defaultstring = {type="string",ormtype="string",uitype="string", testtype="string"};
		var defaultnumeric = {type="numeric",ormtype="float",uitype="string", testtype="numeric"};
		var defaulttext = {type="string",ormtype="text",uitype="text", testtype="string"};
		var defaultchar = {type="string",ormtype="string",uitype="string", testtype="string"};
		var defaultboolean = {type="boolean",ormtype="boolean",uitype="boolean", testtype="boolean"};
		var defaultvalue = {type="string",ormtype="string",uitype="string", testtype="string"};
		
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
		
		datatypes['default'] = defaultvalue;
		
		
		datatypes['uniqueidentifier']['type'] = "string";
		datatypes['uniqueidentifier']['ormType'] = "string";
		datatypes['uniqueidentifier']['uiType'] = "string";
		datatypes['uniqueidentifier']['testType'] = "uniqueidentifier";
		
		//numerics
		datatypes['number'] = defaultnumeric;
		datatypes['decimal'] = defaultnumeric;
		datatypes['numeric'] = defaultnumeric;
		datatypes['money'] = defaultnumeric;
		datatypes['smallmoney'] = defaultnumeric;
	
	
		//Chars text other strings
		datatypes['char'] = defaultchar;
		datatypes['nchar'] = defaultchar;	
		
		datatypes['text'] = defaulttext;
		datatypes['ntext'] = defaulttext;
		
		datatypes['xml']['type'] = "string";
		datatypes['xml']['ormType'] = "string";
		datatypes['xml']['uiType'] = "string";
		datatypes['xml']['testType'] = "xml";
	
	
		//Various Booleans
		
		datatypes['boolean'] = defaultboolean;
		datatypes['yes_no'] = defaultboolean;
		datatypes['true_false'] = defaultboolean;
		datatypes['bit'] = defaultboolean;
		datatypes['flag'] = defaultboolean;
		

		datatypes['yes_no']['ormType'] = "yes_no";

		datatypes['true_false']['ormType'] = "true_false";
		
		
		datatypes['bit']['type'] = "boolean";
		datatypes['bit']['ormType'] = "boolean";
		datatypes['bit']['uiType'] = "boolean";
		datatypes['bit']['testtype'] = "bit";
		
		
		//various ob's
		datatypes['clob']['type'] = "clob";
		datatypes['clob']['ormType'] = "clob";
		datatypes['clob']['uiType'] = "text";
		datatypes['clob']['testtype'] = "string";
		
		datatypes['blob']['type'] = "binary";
		datatypes['blob']['ormType'] = "binary";
		datatypes['blob']['uiType'] = "binary";
		datatypes['blob']['testtype'] = "binary";
		
		datatypes['image']['type'] = "binary";
		datatypes['image']['ormType'] = "binary";
		datatypes['image']['uiType'] = "binary";
		datatypes['image']['testtype'] = "binary";
		
		datatypes['binary']['type'] = "binary";
		datatypes['binary']['ormType'] = "binary";
		datatypes['binary']['uiType'] = "binary";
		datatypes['binary']['testtype'] = "binary";
		
		datatypes['varbinary']['type'] = "binary";
		datatypes['varbinary']['ormType'] = "binary";
		datatypes['varbinary']['uiType'] = "binary";
		datatypes['varbinary']['testtype'] = "binary";
		
		//various dates
		datatypes['date']['type'] = "date";
		datatypes['date']['ormType'] = "date";
		datatypes['date']['uiType'] = "date";
		datatypes['date']['testtype'] = "date";
		
		datatypes['time']['type'] = "date";
		datatypes['time']['ormType'] = "time";
		datatypes['time']['uiType'] = "time";
		datatypes['time']['testtype'] = "date";
		
		datatypes['timestamp']['type'] = "date";
		datatypes['timestamp']['ormType'] = "timestamp";
		datatypes['timestamp']['uiType'] = "datetime";
		datatypes['timestamp']['testtype'] = "date";
		
		datatypes['datetime']['type'] = "date";
		datatypes['datetime']['ormType'] = "timestamp";
		datatypes['datetime']['uiType'] = "datetime";
		datatypes['datetime']['testtype'] = "date";
		
		datatypes['year']['type'] = "numeric";
		datatypes['year']['ormType'] = "integer";
		datatypes['year']['uiType'] = "string";
		datatypes['year']['testtype'] = "numeric";
			
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
	
	/**
	 * @hint gets the TestType for a given datatype
	 */
	public string function getTestType(required string datatype){
		
		if (structKeyExists(datatypes, arguments.datatype)){
			var dataTypeInfo = datatypes[arguments.datatype];		
		}
		else{
			var dataTypeInfo = datatypes['default'];
		}
		
		return dataTypeInfo['testtype'];
	}


}