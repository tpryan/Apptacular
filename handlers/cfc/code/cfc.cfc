component extends="CFPage" accessors="true" {
	property string extends;
	property string implements;
	property string table;
	property string entityname;
	property name="output" type="boolean" default="false";
	property name="persistent" type="boolean" default="false";

	public function init(){
		
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		This.setExtension('cfc');
		This.setOutput(FALSE); 
		
		variables.constructorArray = ArrayNew(1);
		variables.functionArray = ArrayNew(1);
		variables.propertyArray = ArrayNew(1);
		
	}
			
	public string function generateCFMLHeader(){
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
	
	public string function generateCFScriptHeader(){
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
	
	public string function generateCFMLFooter(){
		var footer = '</cfcomponent>' & variables.lineBreak;
		return footer;
	}
	
	public string function generateCFScriptFooter(){
		var footer = '}' & variables.lineBreak;
		return footer;
	}
	
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
	
	private string function generateCFMLFunctions(){
		var body = "";
		
		body = body & variables.lineBreak;
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body = body & "	" & variables.functionArray[i].getCFML();
			body = body & variables.lineBreak;
		}
		
		return body;
	
	}
	
	private string function generateCFScriptFunctions(){
		var body = "";
		
		for (i = 1; i lte ArrayLen(variables.functionArray); i++){
			body =  body & variables.lineBreak & "	" & variables.functionArray[i].getCFScript();
		}
		
		body = body & variables.lineBreak;
		return body;
	
	}
	
	private string function generateCFMLConstructor(){
		return "";
	
	}
	
	private string function generateCFScriptConstructor(){
		return "";
	
	}
	
	public string function getCFML(){
		var results = "";

		results = results & generateCFMLHeader();
		results = results & generateCFMLProperties()  ;
		results = results & generateCFMLFunctions();
		results = results & generateCFMLFooter();

		return results;
	}	
	
	public string function getCFScript(){
		var results = "";

		results = results & generateCFScriptHeader();
		results = results & generateCFScriptProperties()  ;
		results = results & generateCFScriptFunctions();
		results = results & generateCFScriptFooter();

		return results;
	}	
	
	public void function addFunction(required functionObj){
		ArrayAppend(variables.functionArray, arguments.functionObj);
	}

	public void function addProperty(required property property){
		ArrayAppend(variables.propertyArray, arguments.property);
	}

	


}

	
