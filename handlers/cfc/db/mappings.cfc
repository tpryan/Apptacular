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
		
		var defaultinteger = {type="numeric",ormtype="integer",uitype="string", testtype="numeric", displayLength=false};
		var defaultstring = {type="string",ormtype="string",uitype="string", testtype="string", displayLength=true};
		var defaultnumeric = {type="numeric",ormtype="float",uitype="string", testtype="numeric", displayLength=false};
		var defaulttext = {type="string",ormtype="text",uitype="text", testtype="string", displayLength=true};
		var defaultchar = {type="string",ormtype="string",uitype="string", testtype="string", displayLength=true};
		var defaultboolean = {type="boolean",ormtype="boolean",uitype="boolean", testtype="boolean", displayLength=false};
		var defaultvalue = {type="string",ormtype="string",uitype="string", testtype="string", displayLength=true};
		
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
		
		datatypes['tinyint']['type'] = "numeric";
		datatypes['tinyint']['ormType'] = "integer";
		datatypes['tinyint']['uiType'] = "string";
		datatypes['tinyint']['testType'] = "numeric";
		datatypes['tinyint']['displayLength'] = true;
		
		
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
		datatypes['uniqueidentifier']['displayLength'] = true;
		
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
		datatypes['xml']['displayLength'] = true;
	
	
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
		datatypes['bit']['displayLength'] = false;
		
		
		//various ob's
		datatypes['clob']['type'] = "string";
		datatypes['clob']['ormType'] = "text";
		datatypes['clob']['uiType'] = "text";
		datatypes['clob']['testtype'] = "string";
		datatypes['clob']['displayLength'] = false;
		
		datatypes['blob']['type'] = "binary";
		datatypes['blob']['ormType'] = "binary";
		datatypes['blob']['uiType'] = "binary";
		datatypes['blob']['testtype'] = "binary";
		datatypes['blob']['displayLength'] = false;
		
		datatypes['longblob']['type'] = "binary";
		datatypes['longblob']['ormType'] = "binary";
		datatypes['longblob']['uiType'] = "binary";
		datatypes['longblob']['testtype'] = "binary";
		datatypes['longblob']['displayLength'] = false;
		
		datatypes['image']['type'] = "binary";
		datatypes['image']['ormType'] = "binary";
		datatypes['image']['uiType'] = "image";
		datatypes['image']['testtype'] = "binary";
		datatypes['image']['displayLength'] = false;
		
		
		datatypes['binary']['type'] = "binary";
		datatypes['binary']['ormType'] = "binary";
		datatypes['binary']['uiType'] = "binary";
		datatypes['binary']['testtype'] = "binary";
		datatypes['binary']['displayLength'] = false;
		
		datatypes['varbinary']['type'] = "binary";
		datatypes['varbinary']['ormType'] = "binary";
		datatypes['varbinary']['uiType'] = "binary";
		datatypes['varbinary']['testtype'] = "binary";
		datatypes['varbinary']['displayLength'] = false;
		
		//various dates
		datatypes['date']['type'] = "date";
		datatypes['date']['ormType'] = "date";
		datatypes['date']['uiType'] = "date";
		datatypes['date']['testtype'] = "date";
		datatypes['date']['displayLength'] = false;
		
		datatypes['time']['type'] = "date";
		datatypes['time']['ormType'] = "time";
		datatypes['time']['uiType'] = "time";
		datatypes['time']['testtype'] = "date";
		datatypes['time']['displayLength'] = false;
		
		datatypes['timestamp']['type'] = "date";
		datatypes['timestamp']['ormType'] = "timestamp";
		datatypes['timestamp']['uiType'] = "datetime";
		datatypes['timestamp']['testtype'] = "date";
		datatypes['timestamp']['displayLength'] = false;
		
		datatypes['datetime']['type'] = "date";
		datatypes['datetime']['ormType'] = "timestamp";
		datatypes['datetime']['uiType'] = "datetime";
		datatypes['datetime']['testtype'] = "date";
		datatypes['datetime']['displayLength'] = false;
		
		datatypes['year']['type'] = "numeric";
		datatypes['year']['ormType'] = "integer";
		datatypes['year']['uiType'] = "string";
		datatypes['year']['testtype'] = "year";
		datatypes['year']['displayLength'] = false;
			
    	return This;
    }
	
	/**
	 * @hint Gets a list of all of the UITypes in use in apptacular
	 */
	public array function getUITypes(){
		var allArray = structFindKey(datatypes, "uiType", "ALL");
		var i = 0;
		var uniqueStruct = {};
		
		for (i = 1; i <= ArrayLen(allArray); i++){
			uniqueStruct[allArray[i].value] = "";	
		}
		
		var returnArray = StructKeyArray(uniqueStruct);
		ArraySort(returnArray, "textnocase", "asc");
		
		return returnArray;
	}
	
	/**
	 * @hint Gets a list of all of the TestTypes in use in apptacular
	 */
	public array function getTestTypes(){
		var allArray = structFindKey(datatypes, "testType", "ALL");
		var i = 0;
		var uniqueStruct = {};
		
		for (i = 1; i <= ArrayLen(allArray); i++){
			uniqueStruct[allArray[i].value] = "";	
		}
		
		var returnArray = StructKeyArray(uniqueStruct);
		ArraySort(returnArray, "textnocase", "asc");
		
		return returnArray;
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
	
	/**
	 * @hint gets the displayLength for a given datatype
	 */
	public boolean function getDisplayLength(required string datatype){
		
		if (structKeyExists(datatypes, arguments.datatype)){
			var dataTypeInfo = datatypes[arguments.datatype];		
		}
		else{
			var dataTypeInfo = datatypes['default'];
		}
		
		return dataTypeInfo['displayLength'];
	}


}