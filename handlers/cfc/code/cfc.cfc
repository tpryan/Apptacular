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
		var header = CreateObject("java","java.lang.StringBuilder").Init();
		header.append('<cfcomponent ');
		header = addHeaderAttributes(header);
		//concat here because the trim converts the stringbuilder to a string
		header.concat('>' & variables.lineBreak);
		
		return header;
	
	}
	
	/**
		* @hint Returns the CFC header in CFscript.
	*/	
	private string function generateCFScriptHeader(){
	
		var header = CreateObject("java","java.lang.StringBuilder").Init();
	
		header.append('component ');
		header = addHeaderAttributes(header);
		//concat here because the trim converts the stringbuilder to a string
		header.concat('{' & variables.lineBreak);
		
		return header;
	
	}
	
	private any function addHeaderAttributes(any stringBuilder){
		
		if (len(This.getExtends()) gt 0){
			stringBuilder.append(' extends="#This.getExtends()#"');
		}
		
		if (len(This.getImplements()) gt 0){
			stringBuilder.append(' implements="#This.getImplements()#"');
		}
		
		if (len(This.getPersistent())){
			stringBuilder.append(' persistent="#This.getPersistent()#"');
		}
		
		if (len(This.getTable()) gt 0){
			stringBuilder.append(' table="#This.getTable()#"');
		}
		
		if (len(This.getSchema()) gt 0){
			stringBuilder.append(' schema="#This.getSchema()#"');
		}
		
		if (len(This.getEntityName()) gt 0){
			stringBuilder.append(' entityName="#This.getEntityName()#"');
		}
		
		if (This.getOutput()){
			stringBuilder.append(' output="#This.getOutput()#"');
		}
		
		stringBuilder = trim(stringBuilder);
			
		return stringBuilder;
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
		
		var props = CreateObject("java","java.lang.StringBuilder").Init();
		var props = props.Append(variables.lineBreak);
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			props = props.Append("	");
			props = props.Append(variables.propertyArray[i].getCFML());
			props = props.Append(variables.lineBreak);
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
		
		var props = CreateObject("java","java.lang.StringBuilder").Init();
		props.Append(variables.lineBreak);
		var i = 0;
		
		for (i = 1; i lte ArrayLen(variables.propertyArray); i++){
			props.Append("	");
			props.Append(variables.propertyArray[i].getCFSCript());
			props.Append(variables.lineBreak);
		}
		
		return props;
	}
	
	/**
		* @hint Returns the CFC functions in CFML.
	*/
	private string function generateCFMLFunctions(){
		var body = CreateObject("java","java.lang.StringBuilder").Init();
		
		body = body.append(variables.lineBreak);
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body.append("	" & variables.functionArray[i].getCFML());
			body.append(variables.lineBreak);
		}
		
		return body;
	
	}
	
	/**
		* @hint Returns the CFC functions in CFScript.
	*/
	private string function generateCFScriptFunctions(){
		var body = CreateObject("java","java.lang.StringBuilder").Init();
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body.append(variables.lineBreak & "	");
			body.append( variables.functionArray[i].getCFScript());
		}
		
		body.append(variables.lineBreak);
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
		var results = CreateObject("java","java.lang.StringBuilder").Init();

		results.append(generateCFMLHeader());
		results.append(generateCFMLProperties())  ;
		results.append(generateCFMLFunctions());
		results.append(generateCFMLFooter());

		return results;
	}	
	
	/**
		* @hint Returns the CFC in CFScript.
	*/
	public string function getCFScript(){
		var results = CreateObject("java","java.lang.StringBuilder").Init();

		results.append(generateCFScriptHeader());
		results.append(generateCFScriptProperties());
		results.append(generateCFScriptFunctions());
		results.append(generateCFScriptFooter());

		return results;
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