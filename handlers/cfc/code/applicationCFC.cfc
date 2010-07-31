component displayname="Application CFC" hint="A CFC representation of an Application.cfc" extends="cfc" accessors="true" {
	
	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public applicationCFC function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		
		This.setName("Application"); 
		This.setOutput(FALSE); 
		This.setExtension('cfc');
		This.setFormat('cfscript');
		This.setOverwriteable(true);
		variables.constructorArray = ArrayNew(1);
		variables.functionArray = ArrayNew(1);
		variables.propertyArray = ArrayNew(1);
		variables.commentHeader = ArrayNew(1);
		variables.appPropertyArray = ArrayNew(1);
		
		return This;
	}

	/**
		* @hint Adds the code of a property to the CFC.
	*/
	public function addApplicationProperty(	required string name, 
											required string value, 
											boolean surroundWithQuotes){
		var appProp = structNew();
		appProp.name = arguments.name;
		appProp.value = arguments.value;
		
		if (structKeyExists(arguments, "surroundwithQuotes")){
			appProp.quote = arguments.surroundwithQuotes;
		}
		else{
			appProp.quote = "";
		}
		
		ArrayAppend(variables.appPropertyArray, appProp);
		
	}


	/**
		* @hint Generates the Application properties in CFML.
	*/
	public string function generateCFMLApplicationProperties(){
		var props = variables.lineBreak;
		var i = 0;
		var propStruct = structNew();
		for(i = 1; i lte ArrayLen(variables.appPropertyArray); i++ ){
			propStruct = variables.appPropertyArray[i];
			if ((	isNumeric(propStruct.value) OR 
					isBoolean(propStruct.value)) OR 
					(ISBoolean(propStruct.quote) and not propStruct.quote) )
			{
				props = props & '	<cfset This.' & propStruct.name & ' = ' & propStruct.value & ' />' & variables.lineBreak ;
			}
			else{
				props = props & '	<cfset This.' & propStruct.name & ' = "' & propStruct.value & '" />' & variables.lineBreak ;
			}
		}
			
		return props;
		
	}

	/**
		* @hint Generates the Application properties in CFScript.
	*/
	public string function generateCFScriptApplicationProperties(){
		var props = variables.lineBreak;
		var i = 0;
		var propStruct = structNew();
		
		for(i = 1; i lte ArrayLen(variables.appPropertyArray); i++ ){
			propStruct = variables.appPropertyArray[i];
			if ((	isNumeric(propStruct.value) OR 
					isBoolean(propStruct.value)) OR 
					(ISBoolean(propStruct.quote) and not propStruct.quote) )
			{
				props = props & '	This.' & propStruct.name & ' = ' & propStruct.value & ';' & variables.lineBreak ;
			}
			else{
				props = props & '	This.' & propStruct.name & ' = "' & propStruct.value & '";' & variables.lineBreak ;
			}
		}
			
		return props;
		
	}

	/**
		* @hint Returns the actual cfml cfc code.
	*/
	public string function getCFML(){
		var results = "";

		/* Add the header to the cfc feed. */
		results = results & generateCFMLHeader();
		results = results & generateCFMLProperties()  ;
		results = results & generateCFMLApplicationProperties()  ;
		results = results & generateCFMLConstructor();
		results = results & generateCFMLFunctions();
		/* Add the footer to the cfc feed. */
		results = results & generateCFMLFooter();

		return results;
	}
	
	/**
		* @hint Returns the actual cfscript cfc code.
	*/
	public string function getCFScript(){
		var results = "";

		/* Add the header to the cfc feed. */
		results = results & generateCFScriptHeader();
		results = results & generateCFScriptProperties()  ;
		results = results & generateCFScriptApplicationProperties()  ;
		results = results & generateCFScriptConstructor();
		results = results & generateCFScriptFunctions();
		/* Add the footer to the cfc feed. */
		results = results & generateCFScriptFooter();

		return results;
	}
}
