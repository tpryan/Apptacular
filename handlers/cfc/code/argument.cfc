component displayname="argument" hint="A CFC representation of an argument for code creation"  accessors="true" {
	
	property name="name" type="string"  hint="The name of the argument to create ";
	property name="type" type="string"  hint="The argument type.";
	property name="required" type="boolean"  hint="Whether or not this argument is required.";
	property name="defaultvalue" type="string"  hint="The value to set as default for the argument";
	property name="hint" type="string" hint="The hint to add to the argument.";
	
	public function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		return This;
	}
	
	/**
		* @hint Returns the actual CFML code.
	*/
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
	
	/**
		* @hint Returns the actual cfscript code.
	*/
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