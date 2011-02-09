component {

	variables.data = "";
	
	public function init(string xml) {
		variables.data = xmlParse(arguments.xml);
		//cache the callback url since we may use it a lot
		if(getCFBuilderVersion() >= 2) variables.cburl = getCallbackURL();
		setDefaults();
		return this;
	}
	
	private function setDefaults()
	{
		if (not isNull(variables.data.event.ide.projectview.xmlAttributes.projectlocation)){
			variables.projectLocation = variables.data.event.ide.projectview.xmlAttributes.projectlocation;
		}
		else if (not isNull(variables.data.event.ide.eventinfo.XMLAttributes.projectlocation)){
			variables.projectLocation = variables.data.event.ide.eventinfo.XMLAttributes.projectlocation;
		}
		else{
			variables.projectLocation = "";
		}		
		
		
		if (not isNull(variables.data.event.ide.projectview.XMLAttributes.projectname)){
			variables.projectname = variables.data.event.ide.projectview.XMLAttributes.projectname;
		}
		else if (not isNull(event.ide.eventinfo.XMLAttributes.projectname)){
			variables.projectname = variables.data.event.ide.eventinfo.XMLAttributes.projectname;
		}
		else{
			variables.projectname = "";
		}
		
		
		if (not isNull(variables.data.event.ide.rdsview)){
			variables.rdsDatasource=variables.data.event.ide.rdsview.database[1].XMLAttributes.name;
		}
		else{
			variables.rdsDatasource = "";
		}
		
		if (not isNull(variables.data.event.ide.projectview.resource.XMLAttributes.path)){
			variables.resourcePath=variables.data.event.ide.projectview.resource.XMLAttributes.path;
		}
		else{
			variables.resourcePath = "";
		}			
			
	}

	public function getRdsDatasource(){
		return variables.rdsDatasource;
	}

	public function getProjectPath(){
		return variables.projectLocation;
	}
	
	public function setProjectPath(required string value){
		variables.projectLocation  = value;
	}
	
	public function getProjectName(){
		return variables.projectname;			
	}
	
	public function getResourcePath(){
		return variables.resourcePath;		
	}
	
	public function setResourcePath(required string value){
		variables.ResourcePath  = value;
	}	


	/*
	* Wrapper for callback associated commands - CFB2 only
	*/
	private function execute(string command) {
		if(getCFBuilderVersion() == 1) throw("This command only allowed under CFBuilder 2.0 and higher.");
		var http = new com.adobe.coldfusion.http();
		http.setURL(variables.cburl);
		http.setMethod("post");
		http.addParam(type="body", value="#arguments.command#");
		writelog(file="application", text="sending to #variables.cburl# and contents of #arguments.command#");
		var result = http.send().getPrefix();
		writelog(file="application", text="result=#result.filecontent#");
		return xmlParse(result.filecontent);
	}
	
	public string function getCallbackURL() {
		if(getCFBuilderVersion() == 1) throw("This command only allowed under CFBuilder 2.0 and higher.");
		writelog(file="application", text="cb url is #variables.data.event.ide.callbackurl.xmlText#");
		return variables.data.event.ide.callbackurl.xmlText;
	}
	
	/*
	* Returns the version of CFBuilder. Either 1 or 2
	*/
	public string function getCFBuilderVersion() {
		if(!structKeyExists(variables.data.event.ide.xmlAttributes, "version")) return 1;
		return variables.data.event.ide.xmlAttributes.version;		
	}
	
	/*
	* Returns the current URL for the page.
	* @return Returns a string.
	* @author Topper (topper@cftopper.com)
	* @version 1, September 5, 2008
	*/
	public string function getCurrentURL() {
		var theURL = getPageContext().getRequest().GetRequestUrl().toString();
		if(len( CGI.query_string )) theURL = theURL & "?" & CGI.query_string;
		// Hack by Raymond, remove any CFID CFTOKEN 
		theUrl = reReplaceNoCase(theUrl, "[&?]*cfid=[0-9]+", "");
		theUrl = reReplaceNoCase(theUrl, "[&?]*cftoken=[^&]+", "");
		return theURL;
	}

	public array function getDatasources(string servers="") {
		if(len(arguments.servers)) var req = "<response><ide><commands><command type=""getdatasources""><params><param key=""server"" value=""#arguments.servers#"" /></params></command></commands></ide></response>";
		else req = "<response><ide><commands><command type=""getdatasources""></command></commands></ide></response>";
		var resultOb = execute(req);
		var result = [];
		for(var i=1; i <= arrayLen(resultOb.event.ide.command_results.command_result.datasources.datasource); i++) {
			arrayAppend(result, {name=resultOb.event.ide.command_results.command_result.datasources.datasource[i].xmlAttributes.name, server=resultOb.event.ide.command_results.command_result.datasources.datasource[i].xmlAttributes.server});
		}
		return result;
	}

	public string function getRootURL() {
		var theURL = getCurrentURL();
		theURL = listDeleteAt(theURL, listLen(theURL,"/"), "/") & "/";
		return theURL;
	}
			
	/*
	* Get selected resource will return a struct containing the path of the thing selected in the project view and a 'type' that is either directory or file
	*/
	public struct function getSelectedResource() {
		if(getRunType() != "projectview") throw(message="Invalid run type");
		return variables.data.event.ide.projectview.resource.xmlAttributes;
	}
	
	/*
	* Get the text selected from the editor - or the entire file if nothing was selected. Returns a struct containing text + file
	*/
	public struct function getSelectedText() {
		if(getRunType() != "editor") throw(message="Invalid run type");	
		var result = {};
		result.path = variables.data.event.ide.editor.file.xmlAttributes.location;
		if(len(variables.data.event.ide.editor.selection.text.xmlText) > 0) {
			result.text = variables.data.event.ide.editor.selection.text.xmlText;
		} else {
			result.text = fileRead(result.path);
		}
		return result;
	}

	/*
	* Gets available servers 
	*/
	public array function getServers() {
		var req = "<response><ide><commands><command type=""getservers"" /></commands></ide></response>";
		var resultOb = execute(req);
		var result = [];
		for(var i=1; i<= arrayLen(resultOb.event.ide.command_results.command_result.servers.server); i++) {
			arrayAppend(result, resultOb.event.ide.command_results.command_result.servers.server[i].xmlAttributes.name);
		} 
		return result;
	}
	
	/*
	* Get run type will tell you how your extension is being run. It returns one of: editor,projectview,outlineview,rdsview
	*/
	public string function getRunType() {
		if(structKeyExists(variables.data.event.ide, "editor")) return "editor";
		if(structKeyExists(variables.data.event.ide, "projectview")) return "projectview";
		if(structKeyExists(variables.data.event.ide, "outlineview")) return "outlineview";
		if(structKeyExists(variables.data.event.ide, "rdsview")) return "rdsview";
		
	}

	/*
	* Returns detail for a table
	* TODO: Make server optional
	*/

	public struct function getTable(string server,string dsn,string tableName) {
		var req = "<response><ide><commands><command type=""gettable""><params><param key=""server"" value=""#arguments.server#"" /><param key=""datasource"" value=""#arguments.dsn#"" /><param key=""table"" value=""#arguments.tableName#"" /></params></command></commands></ide></response>";
		var resultOb = execute(req);

		var result = {};

		var tableOb = resultOb.event.ide.command_results.command_result.table;

		result.name = tableOb.xmlAttributes.name;
		result.fields = [];
		for(var x=1; x <= arrayLen(tableOb.field); x++) {
			var fieldOb = tableOb.field[x];
			var field = {};
			for(var key in fieldOb.xmlAttributes) {
				field[key] = fieldOb.xmlAttributes[key];
			}
			arrayAppend(result.fields, field);
		}

		return result;

	}


	/*
	* Returns a list of tables for a DSN
	* TODO: Make server optional
	*/
	public array function getTables(string server,string dsn) {
		var req = "<response><ide><commands><command type=""gettables""><params><param key=""server"" value=""#arguments.server#"" /><param key=""datasource"" value=""#arguments.dsn#"" /></params></command></commands></ide></response>";
		var resultOb = execute(req);
		var result = [];
		for(var i=1; i <= arrayLen(resultOb.event.ide.command_results.command_result.tables.table); i++) {
			var tableOb = resultOb.event.ide.command_results.command_result.tables.table;
			var table = {};
			table.name = tableOb.xmlAttributes.name;
			table.fields = [];
			for(var x=1; x <= arrayLen(tableOb.field); x++) {
				var fieldOb = tableOb.field[x];
				var field = {};
				for(var key in fieldOb.xmlAttributes) {
					field[key] = fieldOb.xmlAttributes[key];
				}
				arrayAppend(table.fields, field);
			}
			arrayAppend(result, table);
		}
		return result;
	}
	
}



	
