component displayname="CFC" extends="CFPage" hint="A cfc representation of a cfc for code creation." accessors="true" {
	
	property name="extends" type="string" hint="The cfc that the CFC created here extends.";
	property name="implements" type="string" hint="The interface that the CFC created here implements.";
	property name="table" type="string" hint="The table that this CFC models for ORM usage.";
	property name="schema" type="string" hint="The schema in which the table that this CFC models for ORM usage resides.";
	property name="entityName" type="string" hint="The entityname that this CFC models for ORM usage.";
	property name="output" type="boolean" default="false" hint="Whether or not this CFC should leak output.";
	property name="persistent" type="boolean" default="false" hint="Whether or not this CFC should use ORM tools.";
	property name="format" type="string" hint="CFML or CFScript";

	
	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public cfc function init(){
		
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		This.setExtension('cfc');
		This.setOutput(FALSE);
		This.setFormat('cfscript'); 
		
		variables.constructorArray = ArrayNew(1);
		variables.functionArray = ArrayNew(1);
		variables.propertyArray = ArrayNew(1);
		
		return This;
	}
	
	/**
		* @hint Returns the CFC header in CFML.
	*/		
	private string function generateCFMLHeader(){
		var header = arrayNew(1);
		ArrayAppend(header, '<cfcomponent');
		ArrayAppend(header, addHeaderAttributes());
		ArrayAppend(header, '>');
		ArrayAppend(header, variables.lineBreak);
		return ArrayToList(header, "");
	
	}
	
	/**
		* @hint Returns the CFC header in CFscript.
	*/	
	private string function generateCFScriptHeader(){
		var header = arrayNew(1);
		ArrayAppend(header, 'component');
		ArrayAppend(header, addHeaderAttributes());
		ArrayAppend(header, '{');
		ArrayAppend(header, variables.lineBreak);
		return ArrayToList(header, "");
	}
	
	private string function addHeaderAttributes(){
		var results = arrayNew(1);
		var returnString = "";
		
		if (len(This.getExtends()) gt 0){
			arrayAppend(results, ' extends="#This.getExtends()#"');
		}
		
		if (len(This.getImplements()) gt 0){
			arrayAppend(results, ' implements="#This.getImplements()#"');
		}
		
		if (len(This.getPersistent())){
			arrayAppend(results, ' persistent="#This.getPersistent()#"');
		}
		
		if (len(This.getTable()) gt 0 AND compare(This.getTable(), This.getName()) neq 0 ){
			arrayAppend(results, ' table="#This.getTable()#"');
		}
		
		if (len(This.getSchema()) gt 0){
			arrayAppend(results, ' schema="#This.getSchema()#"');
		}
		
		if (len(This.getEntityName()) gt 0 AND compare(This.getEntityName(), This.getName()) neq 0 ){
			arrayAppend(results, ' entityName="#This.getEntityName()#"');
		}
		
		if (This.getOutput()){
			arrayAppend(results, ' output="#This.getOutput()#"');
		}
		
		returnString = ArrayToList(results, "");
			
		return returnString;
	}
	
	/**
		* @hint Returns the CFC footer in CFML.
	*/	
	private string function generateCFMLFooter(){
		var footer = '</cfcomponent>' & variables.lineBreak;
		return footer;
	}
	
	/**
		* @hint Returns the CFC footer in CFScript.
	*/	
	private string function generateCFScriptFooter(){
		var footer = '}' & variables.lineBreak;
		return footer;
	}
	
	/**
		* @hint Returns the CFC properties in CFML.
	*/	
	private string function generateCFMLProperties(){
		if (ArrayLen(variables.propertyArray) eq 0){
			return "";
		}
		
		var props = ArrayNew(1);
		
		ArrayAppend(props, variables.lineBreak);
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			ArrayAppend(props, "	" & variables.propertyArray[i].getCFML());
		}
		
		return ArrayToList(props, variables.lineBreak);
	}
	
	/**
		* @hint Returns the CFC properties in CFScript.
	*/
	private string function generateCFScriptProperties(){
		if (ArrayLen(variables.propertyArray) eq 0){
			return "";
		}
		
		var props = ArrayNew(1);
		
		ArrayAppend(props, variables.lineBreak);
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			ArrayAppend(props, "	" & variables.propertyArray[i].getCFSCript());
		}
		
		return ArrayToList(props, variables.lineBreak);
	}
	
	/**
		* @hint Returns the CFC functions in CFML.
	*/
	private string function generateCFMLFunctions(){
		var body = ArrayNew(1);
		var i = 0;
		
		ArrayAppend(body, variables.lineBreak);
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			ArrayAppend(body, "	" & variables.functionArray[i].getCFML());
		}
		
		return ArrayToList(body, variables.lineBreak);
	
	}
	
	/**
		* @hint Returns the CFC functions in CFScript.
	*/
	private string function generateCFScriptFunctions(){
		var body = ArrayNew(1);
		var i = 0;
		
		ArrayAppend(body, variables.lineBreak);
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			ArrayAppend(body, "	" & variables.functionArray[i].getCFScript());
		}
		
		return ArrayToList(body, variables.lineBreak);
	
	}
	
	/**
		* @hint Does nothing yet.
	*/
	private string function generateCFMLConstructor(){
		return "";
	
	}
	
	/**
		* @hint Does nothing yet.
	*/
	private string function generateCFScriptConstructor(){
		return "";
	
	}
	
	/**
		* @hint Returns the CFC in CFML.
	*/
	public string function getCFML(){
		var results = arrayNew(1);

		ArrayAppend(results, generateCFMLHeader());
		ArrayAppend(results, generateCFMLProperties());
		ArrayAppend(results, generateCFMLFunctions());
		ArrayAppend(results, generateCFMLFooter());

		return ArrayToList(results, "");
	}	
	
	/**
		* @hint Returns the CFC in CFScript.
	*/
	public string function getCFScript(){
		var results = arrayNew(1);

		ArrayAppend(results, generateCFScriptHeader());
		ArrayAppend(results, generateCFScriptProperties());
		ArrayAppend(results, generateCFScriptFunctions());
		ArrayAppend(results, generateCFScriptFooter());

		return ArrayToList(results, "");
	}
		
	/**
		* @hint Appends a function to the cfc.
	*/
	public void function addFunction(required any functionObj){
		//Always add inits at the begining of the list.
		if (compareNoCase(functionObj.getName(), "init") eq 0){
			ArrayPrepend(variables.functionArray, arguments.functionObj);
		}
		else{
			ArrayAppend(variables.functionArray, arguments.functionObj);
		}
	}

	/**
		* @hint Appends a property to the cfc.
	*/
	public void function addProperty(required property property){
		ArrayAppend(variables.propertyArray, arguments.property);
	}

}