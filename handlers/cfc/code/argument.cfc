component accessors="true" {
	
	property name="name";
	property name="type";
	property name="required";
	property name="defaultvalue";
	property name="hint";
	
	public function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		return This;
	}
	
	public string function getCFML(){
		var argCFML = '<cfargument';
		
		argCFML = ListAppend(argCFML, 'name="#This.getName()#"', ' ');
		
		if (len(This.getType())){
			argCFML = ListAppend(argCFML, 'type="#This.getType()#"', ' ');
		}
		
		if (len(This.getRequired()) gt 0 and IsBoolean(This.getRequired()) and This.getRequired()){
			argCFML = ListAppend(argCFML, 'required="#This.getRequired()#"', ' ');
		}
		
		if (len(This.getDefaultvalue()) gt 0 and IsBoolean(This.getRequired()) and not This.getRequired()){
			argCFML = ListAppend(argCFML, 'default="#This.getDefaultvalue()#"', ' ');
		}
		
		if (len(This.getHint())){
			argCFML = ListAppend(argCFML, 'hint="#This.getHint()#"', ' ');
		}
		
		argCFML = ListAppend(argCFML, ' />' & variables.lineBreak, ' ');
		
		return argCFML;
	
	}
	
	public string function getCFScript(){
		var argCFML = '';
		
		argCFML = ListAppend(argCFML, '#This.getName()#', ' ');
		
		if (len(This.getType())){
			argCFML = ListPrepend(argCFML, '#This.getType()#', ' ');
		}
		
		if (len(This.getRequired()) gt 0 and IsBoolean(This.getRequired()) and This.getRequired()){
			argCFML = ListPrepend(argCFML, 'required', ' ');
		}
		
		if (len(This.getDefaultvalue()) gt 0){
			argCFML = ListAppend(argCFML, '="#This.getDefaultvalue()#"', ' ');
		}
		
		
		return argCFML;
	
	}


}