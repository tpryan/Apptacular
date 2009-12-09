component displayname="CFC" extends="CFPage" hint="A cfc representation of a cfc for code creation." accessors="true" {
	
	property name="extends" type="string" hint="The cfc that the CFC created here extends.";
	property name="implements" type="string" hint="The interface that the CFC created here implements.";
	property name="table" type="string" hint="The table that this CFC models for ORM usage.";
	property name="entityName" type="string" hint="The entityname that this CFC models for ORM usage.";
	property name="output" type="boolean" default="false" hint="Whether or not this CFC should leak output.";
	property name="persistent" type="boolean" default="false" hint="Whether or not this CFC should use ORM tools.";
	property name="format" type="string" hint="CFML or CFScript";

	public function init(){
		
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		This.setExtension('cfc');
		This.setOutput(FALSE);
		This.setFormat('cfscript'); 
		
		variables.constructorArray = ArrayNew(1);
		variables.functionArray = ArrayNew(1);
		variables.propertyArray = ArrayNew(1);
		
	}
	
	/**
		* @hint Returns the CFC header in CFML.
	*/		
	private string function generateCFMLHeader(){
		var header = '<cfcomponent';
		
		if (len(This.getExtends()) gt 0){
			header = ListAppend(header, 'extends="#This.getExtends()#"', ' ') ;
		}
		
		if (len(This.getImplements()) gt 0){
			header = ListAppend(header, 'implements="#This.getImplements()#"', ' ') ;
		}
		
		if (len(This.getPersistent())){
			header = ListAppend(header, 'persistent="#This.getPersistent()#"', ' ') ;
		}
		
		if (len(This.getTable()) gt 0){
			header = ListAppend(header, 'table="#This.getTable()#"', ' ') ;
		}
		
		if (len(This.getEntityName()) gt 0){
			header = ListAppend(header, 'entityName="#This.getEntityName()#"', ' ') ;
		}
		
		if (This.getOutput()){
			header = ListAppend(header, 'output="#This.getOutput()#"', ' ') ;
		}
		
		header = ListAppend(header, '>' & variables.lineBreak, ' ') ;
		
		return header;
	
	}
	
	/**
		* @hint Returns the CFC header in CFscript.
	*/	
	private string function generateCFScriptHeader(){
		var header = 'component';
		
		if (len(This.getExtends()) gt 0){
			header = ListAppend(header, 'extends="#This.getExtends()#"', ' ') ;
		}
		
		if (len(This.getImplements()) gt 0){
			header = ListAppend(header, 'implements="#This.getImplements()#"', ' ') ;
		}
		
		if (len(This.getPersistent())){
			header = ListAppend(header, 'persistent="#This.getPersistent()#"', ' ') ;
		}
		
		if (len(This.getTable()) gt 0){
			header = ListAppend(header, 'table="#This.getTable()#"', ' ') ;
		}
		
		if (len(This.getEntityName()) gt 0){
			header = ListAppend(header, 'entityName="#This.getEntityName()#"', ' ') ;
		}
		
		if (This.getOutput()){
			header = ListAppend(header, 'output="#This.getOutput()#"', ' ') ;
		}
		
		header = ListAppend(header, '{' & variables.lineBreak, ' ') ;
		
		return header;
	
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
		
		var props = variables.lineBreak;
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			props = props & "	" & variables.propertyArray[i].getCFML() & variables.lineBreak ;
		}
		
		return props;
	}
	
	/**
		* @hint Returns the CFC properties in CFScript.
	*/
	private string function generateCFScriptProperties(){
		if (ArrayLen(variables.propertyArray) eq 0){
			return "";
		}
		
		var props = variables.lineBreak;
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			props = props & "	" & variables.propertyArray[i].getCFSCript() & variables.lineBreak ;
		}
		
		return props;
	}
	
	/**
		* @hint Returns the CFC functions in CFML.
	*/
	private string function generateCFMLFunctions(){
		var body = "";
		
		body = body & variables.lineBreak;
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body = body & "	" & variables.functionArray[i].getCFML();
			body = body & variables.lineBreak;
		}
		
		return body;
	
	}
	
	/**
		* @hint Returns the CFC functions in CFScript.
	*/
	private string function generateCFScriptFunctions(){
		var body = "";
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body =  body & variables.lineBreak & "	" & variables.functionArray[i].getCFScript();
		}
		
		body = body & variables.lineBreak;
		return body;
	
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
		var results = "";

		results = results & generateCFMLHeader();
		results = results & generateCFMLProperties()  ;
		results = results & generateCFMLFunctions();
		results = results & generateCFMLFooter();

		return results;
	}	
	
	/**
		* @hint Returns the CFC in CFScript.
	*/
	public string function getCFScript(){
		var results = "";

		results = results & generateCFScriptHeader();
		results = results & generateCFScriptProperties()  ;
		results = results & generateCFScriptFunctions();
		results = results & generateCFScriptFooter();

		return results;
	}
		
	/**
		* @hint Appends a function to the cfc.
	*/
	public void function addFunction(required functionObj){
		ArrayAppend(variables.functionArray, arguments.functionObj);
	}

	/**
		* @hint Appends a property to the cfc.
	*/
	public void function addProperty(required property property){
		ArrayAppend(variables.propertyArray, arguments.property);
	}

	


}

	
