component displayname="function" hint="A CFC representation of an function for code creation" accessors="true" {

	property name="name" type="string" hint="The name of the function";
	property name="output" type="boolean" default="false" hint="Whether or not this function should leak output.";
	property name="access" type="string"  hint="Private, Package, Public, or Remote";
	property name="hint"  type="string" hint="This hint to provide for this function";
	property name="returntype"  type="string" hint="The type of the return value.";
	property name="ReturnResult"  type="string" hint="The code to return from the function";
	
	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public func function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.arguments = ArrayNew(1);
		variables.localvariables = ArrayNew(1);
		variables.operation = ArrayNew(1);
		variables.operationScript = ArrayNew(1);
		variables.tabs = structNew();
			
		return This;
	}

	/**
		* @hint Appends an argument to the function.
	*/
	public void function addArgument(required argument argument){
		ArrayAppend(variables.arguments, arguments.argument);
	}
	
	/**
		* @hint Appends the initialization of a local variable to the function.
	*/
	public void function AddLocalVariable(required string LocalVariable, string type="string", string value="", boolean quote=true){
		ArrayAppend(variables.localVariables, Duplicate(arguments));
	}
	
	private string function getTabs(numeric tabs=0){
		
		if (not structKeyExists(variables.tabs, arguments.tabs)){
			var tab = "	";
			var tabString = ArrayNew(1);
			var i=0;
		
			for (i = 1;i <= arguments.tabs; i++){
				ArrayAppend(tabString,tab);
			}
			
			variables.tabs[arguments.tabs] = ArraytoList(tabString, "");
		}
			
		return variables.tabs[arguments.tabs];
	}	
	
	/**
		* @hint Adds a simple variable set to both the CFML and script of the function.
	*/
	public void function AddSimpleSet(required string Operation, numeric tabs=0 ){
		var tabString = getTabs(arguments.tabs);
		
		AddOperation(tabString & "<cfset " & trim(arguments.Operation)  & " />");
		AddOperationScript(tabString & trim(arguments.Operation)  & ";");
	}
	
	/**
	* @hint Begins a simple if statement in both CFML and CFScript 
	*/
	public void function StartSimpleIF(required string conditional, numeric tabs=0){
		var tabString = getTabs(arguments.tabs);
		
		AddOperation(tabString & "<cfif " & trim(arguments.conditional)  & ">");
		AddOperationScript(tabString & "if (" & trim(arguments.conditional)  & "){");
	}
	
	/**
	* @hint Adds a simple else statement in both CFML and CFScript 
	*/
	public void function StartSimpleElse(numeric tabs=0 ){
		var tabString = getTabs(arguments.tabs);
		
		AddOperation(tabString & "<cfelse>");
		AddOperationScript(tabString & "else{");
	}
	
	/**
	* @hint Ends a simple if statement in both CFML and CFScript 
	*/
	public void function EndSimpleIF(numeric tabs=0 , boolean nextIsElse = false ){
		var tabString = getTabs(arguments.tabs);
		
		// So I screwed up and didn't think this the whole way through.  This should fix that for now.'
		if(not arguments.nextIsElse){
			AddOperation(tabString & "</cfif>");
		}
		AddOperationScript(tabString & "}");
	}
	
	
	/**
		* @hint Adds a simple comment to both the CFML and script of the function.
	*/
	public void function AddSimpleComment(required string comment, numeric tabs=0 ){
		var tabString = getTabs(arguments.tabs);
		
		AddOperation(tabString & "<!--- " & trim(arguments.comment)  & " --->");
		AddOperationScript(tabString & "// " & trim(arguments.comment));
	}
	
	/**
		* @hint Adds a line break to both the CFML and script of the function.
	*/
	public void function AddLineBreak(){
		AddOperation('');
		AddOperationScript('');
	}
	
	/**
		* @hint Adds a line of CFML to the function.
	*/
	public void function AddOperation(required string Operation){
		
		
		ArrayAppend(variables.operation, arguments.operation);
		ArrayAppend(variables.operation, lineBreak);
	}
	
	/**
		* @hint Adds a line of CFScript to the function.
	*/
	public void function AddOperationScript(required string Operation){
		ArrayAppend(variables.operationScript, arguments.operation);
		ArrayAppend(variables.operationScript, lineBreak);
	}

	/**
		* @hint Returns the content of the function declaration in CFML
	*/
	private string function generateCFMLHeader(){
		var header = '<cffunction';
		
		if (len(This.getName()) gt 0){
			header = ListAppend(header, 'name="#This.getName()#"', ' ');
		}
		
		if (len(This.getAccess()) gt 0){
			header = ListAppend(header, 'access="#This.getAccess()#"', ' ');
		}
		
		if (len(This.getOutput())){
			header = ListAppend(header, 'output="#This.getOutput()#"', ' ');
		}
		
		if (len(This.getReturntype()) gt 0){
			header = ListAppend(header, 'returnType="#This.getReturntype()#"', ' ');
		}
		
		if (len(This.getHint()) gt 0){
			header = ListAppend(header, 'hint="#This.getHint()#"', ' ');
		}
		
		header = ListAppend(header, '>' & variables.lineBreak, ' ');
		
		return header ;
	}

	/**
		* @hint Returns the content of the function declaration in CFScript
	*/
	private string function generateCFScriptHeader(){
		var header = '';
		var IsPreFunction = false;
		
		if (len(This.getAccess()) gt 0){
			var IsPreFunction = true;
			header = '#This.getAccess()#';
		}
		
		if (len(This.getReturntype()) gt 0){
			var IsPreFunction = true;
			if(IsPreFunction){
				header = ListAppend(header, '#This.getReturntype()#', ' ');
			}
			else{
				header = '#This.getReturntype()#';
			}
			
		}
		
		if(IsPreFunction){
			header = ListAppend(header, 'function', ' ');
		}
		else{
			header =	'	function';
		}
		
		header = ListAppend(header, '#This.getName()#(' & generateCfscriptArguments()  & ')', ' ');
		
		if (len(This.getOutput()) gt 0){
			header = ListAppend(header, 'output="#getOutput()#"', ' ');
		}
		
		header = ListAppend(header, '{' & variables.lineBreak, ' ');
		
		return header;
	}
	
	/**
		* @hint Returns the content of the function footer in CFML
	*/
	private string function generateCFMLFooter(){
		return '	</cffunction>' & variables.lineBreak;
	}
	
	/**
		* @hint Returns the content of the function footer in CFScript
	*/
	private string function generateCFScriptFooter(){
		return '	}' & variables.lineBreak ;
	}
	
	/**
		* @hint Returns the content of the arguments collection in CFML
	*/
	private string function generateCFMLArguments(){
		var results ="";
		var i = 0;
		
		for (i= 1; i lte arraylen(variables.arguments); i++){
			results = results & "		" & variables.arguments[i].getCFML();
		}
		
		return results;
	}
	
	/**
		* @hint Returns the content of the arguments collection in CFScript
	*/
	private string function generateCFScriptArguments(){
		var results ="";
		var i = 0;
		
		for (i= 1; i lte arraylen(variables.arguments); i++){
			results = ListAppend(results,variables.arguments[i].getCFScript());
		}
		
		results = Replace(results, ",", ", ","ALL");
		
		return results;
	}
	
	/**
		* @hint Returns the instatiation of local varaibles in CFML
	*/
	private string function generateCFMLLocalVariables(){
		var results ="";
		var temp="";
		var i = 0;
		var localVar=StructNew();
		
		if (ArrayLen(variables.localVariables) gt 0){
			results = variables.linebreak;
		}
		
		for (i= 1; i lte arraylen(variables.localVariables); i++){
			localVar = variables.localVariables[i];	
		
			if (len(localVar.value) gt 0){
				if(localVar.quote){
					temp = '		<cfset var #localVar.localvariable# = "#localVar.value#" />' & variables.lineBreak;
				}
				else{
					temp = '		<cfset var #localVar.localvariable# = #localVar.value# />' & variables.lineBreak;
				}
			}	
			else if (CompareNoCase(localVar.type, "struct") eq 0){
				temp = "		<cfset var #localVar.localvariable# = StructNew() />" & variables.lineBreak;
			}
			else{	
				temp = "		<cfset var #localVar.localvariable# = """" />" & variables.lineBreak;
			}
			
			results = results & temp;
		
		}
		
		
		return results;
	}
	
	/**
		* @hint Returns the instatiation of local varaibles in CFScript
	*/
	private string function generateCFScriptLocalVariables(){
		var results ="";
		var temp="";
		var i = 0;
		var localVar=StructNew();
		
		if (ArrayLen(variables.localVariables) gt 0){
			results = variables.linebreak;
		}
		
		for (i= 1; i lte arraylen(variables.localVariables); i++){
			localVar = variables.localVariables[i];	
		
			if (len(localVar.value) gt 0){
				if(localVar.quote){
					temp = '		var #localVar.localvariable# = "#localVar.value#";' & variables.lineBreak;
				}
				else{
					temp = '		var #localVar.localvariable# = #localVar.value#;' & variables.lineBreak;
				}
			}	
			else if (CompareNoCase(localVar.type, "struct") eq 0){
				temp = "		var #localVar.localvariable# = StructNew();" & variables.lineBreak;
			}
			else{	
				temp = "		var #localVar.localvariable# = """";" & variables.lineBreak;
			}
			
			results = results & temp;
		
		}
		
		return results;
	}
	
	/**
		* @hint Returns the content of the function in CFML
	*/
	public string function getCFML(){
		var results = ArrayNew(1);

		ArrayAppend(results, generateCFMLHeader());
		ArrayAppend(results, generateCFMLArguments());
		ArrayAppend(results, generateCFMLLocalVariables());
		ArrayAppend(results, ArrayToList(operation, ""));
		
		if (len(This.getReturnResult()) gt 0 AND compareNoCase(This.getReturnType(), "void") neq 0){
			ArrayAppend(results, '		<cfreturn #This.getReturnResult()# />' & variables.lineBreak);
		}
		
		ArrayAppend(results, generateCFMLFooter()) ;

		return ArrayToList(results, "");
	}
	
	/**
		* @hint Returns the content of the function in CFScript
	*/
	public string function getCFScript(){
		var results = ArrayNew(1);
		
		if (len(This.getHint())){
			ArrayAppend(results, '/**' & linebreak);
			ArrayAppend(results, '	* @hint #This.getHint()#' & linebreak);
			ArrayAppend(results, '	*/' & linebreak & "	");
		}

		ArrayAppend(results, generateCFScriptHeader());
		ArrayAppend(results, generateCFScriptLocalVariables());
		ArrayAppend(results, ArrayToList(operationScript, ""));
		
		if (len(This.getReturnResult()) gt 0 AND compareNoCase(This.getReturnType(), "void") neq 0){
			ArrayAppend(results, '		return #This.getReturnResult()#;' & variables.lineBreak);
		}
		
		ArrayAppend(results, generateCFScriptFooter()) ;

		return ArrayToList(results, "");
	}
	

}