component displayname="Custom Tag" hint="A cfc representation of a Custom tag for code generation." extends="CFPage" accessors="true"
{

	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public customTag function init(required string name, required string fileLocation){
	
		This.setExtension('cfm');
		This.setName(arguments.Name);
		This.setFileLocation(arguments.fileLocation);
		This.setFormat('cfml');
		
		variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");

		variables.header = "<!--- #This.getName()#.cfm --->" & NL & '<cfprocessingdirective suppresswhitespace="yes">' & variables.NL;
		variables.attributes = CreateObject("java","java.lang.StringBuilder").Init();
		variables.body = variables.body = ArrayNew(1);
		variables.footer = "</cfprocessingdirective>" & variables.NL & '<cfexit method="exitTag" />' & variables.NL ;
	
		return This;
	} 
	
	/**
	* @hint Adds a cfparam'ed attribute to the custom tag. 
	*/
	public void function addAttribute(required string name, string type="", boolean required=false, string defaultvalue=""){
		var attributeString = CreateObject("java","java.lang.StringBuilder").Init();
		attributeString.append('<cfparam name="attributes.' & arguments.name & '"');

		if (len(arguments.type gt 1)){
			attributeString.append(' type="' & arguments.type & '"');
		}

		if (not arguments.required AND len(arguments.defaultvalue gt 1)){
			attributeString.append(' default="' & arguments.defaultvalue & '"');
		}

		attributeString.append(" />" & variables.NL);

		variables.attributes.append(attributeString);
	}
	
	/**
	* @hint Returns the actual cf code.
	*/	
	public string function getCFML(){
		var i=0;
		var results = CreateObject("java","java.lang.StringBuilder").Init();

		// Add the header to the custom tag. --->
		results.append(variables.header);
		results.append(variables.attributes);
		results.append(variables.body);

		// Add the footer to the custom tag. --->
		results.append(variables.footer);

		return results;
	}	

}