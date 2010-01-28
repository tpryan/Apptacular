component displayname="argument" hint="A CFC representation of an argument for code creation"  accessors="true" {
	
	property name="name" type="string"  hint="The name of the argument to create ";
	property name="type" type="string"  hint="The argument type.";
	property name="required" type="boolean"  hint="Whether or not this argument is required.";
	property name="defaultvalue" type="string"  hint="The value to set as default for the argument";
	property name="hint" type="string" hint="The hint to add to the argument.";
	
	public argument function init(){
		variables.lineBreak = createObject("java", "java.lang.System").getProperty("line.separator");
		return This;
	}
	
	/**
		* @hint Returns the actual CFML code.
	*/
	public string function getCFML(){
		var argCFML = CreateObject("java","java.lang.StringBuilder").Init();
		argCFML = argCFML.append('<cfargument ');
		
		argCFML = argCFML.append('name="#This.getName()#" ');
		
		if (len(This.getType())){
			argCFML = argCFML.append('type="#This.getType()#" ');
		}
		
		if (len(This.getRequired()) gt 0 and IsBoolean(This.getRequired()) and This.getRequired()){
			argCFML = argCFML.append('required="#This.getRequired()#" ');
		}
		
		if (len(This.getDefaultvalue()) gt 0 and IsBoolean(This.getRequired()) and not This.getRequired()){
			argCFML = argCFML.append('default="#This.getDefaultvalue()#" ');
		}
		
		if (len(This.getHint())){
			argCFML = argCFML.append('hint="#This.getHint()#" ');
		}
		
		argCFML = argCFML.append(' />' & variables.lineBreak);
		
		return argCFML;
	
	}
	
	/**
		* @hint Returns the actual cfscript code.
	*/
	public string function getCFScript(){
		var argCFML = CreateObject("java","java.lang.StringBuilder").Init();
		
		argCFML = argCFML.append('#This.getName()# ');
		
		if (len(This.getType())){
			argCFML = argCFML.insert(0, '#This.getType()# ');
		}
		
		if (len(This.getRequired()) gt 0 and IsBoolean(This.getRequired()) and This.getRequired()){
			argCFML = argCFML.insert(0, 'required ');
		}
		
		if (len(This.getDefaultvalue()) gt 0){
			argCFML = argCFML.append('="#This.getDefaultvalue()#" ');
		}
		
		
		return argCFML;
	
	}

}