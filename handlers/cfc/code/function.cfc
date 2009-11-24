component accessors="true" {

	property name="name";
	property name="output" type="boolean"  default="false";
	property name="access";
	property name="hint";
	property name="returntype";
	property name="ReturnResult";
	
	
	public function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		variables.arguments = ArrayNew(1);
		variables.localvariables = ArrayNew(1);
		variables.operation = CreateObject("java","java.lang.StringBuilder").Init();
		variables.operationScript = CreateObject("java","java.lang.StringBuilder").Init();
			
		return This;
	}

	public void function addArgument(required argument argument){
		ArrayAppend(variables.arguments, arguments.argument);
	}
	
	public void function AddLocalVariable(required string LocalVariable, string type="string", string value="", boolean quote=true){
		ArrayAppend(variables.localVariables, Duplicate(arguments));
	}
	
	public void function AddOperation(required string Operation){
		variables.operation = variables.operation.append(arguments.operation & lineBreak);
	}
	
	public void function AddOperationScript(required string Operation){
		variables.operationScript = variables.operationScript.append(arguments.operation & lineBreak);
	}

	public string function generateCFMLHeader(){
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
		
		header = ListAppend(header, '>' & variables.lineBreak, ' ');
		
		return header ;
	}

	public string function generateCFScriptHeader(){
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
	
	private string function generateCFMLFooter(){
		return '	</cffunction>' & variables.lineBreak;
	}
	
	private string function generateCFScriptFooter(){
		return '	}' & variables.lineBreak ;
	}
	
	private string function generateCFMLArguments(){
		var results ="";
		var i = 0;
		
		for (i= 1; i lte arraylen(variables.arguments); i++){
			results = results & "		" & variables.arguments[i].getCFML();
		}
		
		return results;
	}
	
	private string function generateCFScriptArguments(){
		var results ="";
		var i = 0;
		
		for (i= 1; i lte arraylen(variables.arguments); i++){
			results = ListAppend(results,variables.arguments[i].getCFScript());
		}
		
		results = Replace(results, ",", ", ","ALL");
		
		return results;
	}
	
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
	
	public string function getCFML(){
		var results="";

		results = results & generateCFMLHeader();
		results = results & generateCFMLArguments();
		results = results & generateCFMLLocalVariables();
		results = results & operation;
		
		if (compareNoCase(This.getReturnType(), "void") neq 0){
			results = results.concat('		<cfreturn #This.getReturnResult()# />' & variables.lineBreak);
		}
		
		results = results.concat(generateCFMLFooter()) ;

		return results;
	}
	
	public string function getCFScript(){
		var results="";

		results = results & generateCFScriptHeader();
		results = results & generateCFScriptLocalVariables();
		results = results & operationScript;
		
		if (compareNoCase(This.getReturnType(), "void") neq 0){
			results = results.concat('		return #This.getReturnResult()#;' & variables.lineBreak);
		}
		
		results = results.concat(generateCFScriptFooter()) ;

		return results;
	}
	

}