<cfsetting showdebugoutput="false" />
<cfparam name="url.item" type="string" default="config" />

<cfscript>
	items.config.cfcPath = "apptacular.handlers.generators.cfapp.config";
	items.config.editorItem = "config";
	items.config.title = "Configuration Options";

	items.datasource.cfcPath = "apptacular.handlers.cfc.db.datasource";
	items.datasource.editorItem = "datasource";
	items.datasource.title = "Datasource Options";
	
	items.table.cfcPath = "apptacular.handlers.cfc.db.table";
	items.table.editorItem = "table";
	items.table.title = "Table Options";
	
	items.column.cfcPath = "apptacular.handlers.cfc.db.column";
	items.column.editorItem = "column";
	items.column.title = "Column Options";
	
	items.virtualcolumn.cfcPath = "apptacular.handlers.cfc.db.virtualcolumn";
	items.virtualcolumn.editorItem = "virtualcolumn";
	items.virtualcolumn.title = "Virtual Column Options";

	cfcPath = items[url.item].cfcPath;
	editorItem = items[url.item].editorItem;
	title = items[url.item].title;

</cfscript>




<cfset tooltips = generateToolTips(cfcPath) />
<cfset editor = new apptacular.handlers.cfc.editor(editorItem) />
<cfset helper = new apptacular.handlers.cfc.utils.docHelper(cfcPath) />
<cfset keys = editor.getAllowedList() />

<cf_pageWrapper>
<cfoutput>
<p class="backbuttom"><a href="#cgi.http_referer#" onclick="history.go(-1)">Back</a> </p>
<h1>#title#</h1>
<cfloop list="#keys#" index="key">
	<cfif FindNoCase("<", key)>
		<h2>#ReplaceList(key, "<,>,/", ",,")#</h2>	
		<cfcontinue />
	</cfif>
	
	<dl>
	<dt>#helper.getDisplayName(key)#</dt>	
	<dd>#getToolTip(key)#</dd>
	</dl>
</cfloop>

</cfoutput>
</cf_pageWrapper>


<cfscript>
	
	public struct function generateToolTips(string cfcreference =""){
		var i =  0;
		var result = StructNew();
		if (len(arguments.cfcreference) < 1){
			return result;
		}
		var metaData = GetComponentMetaData(arguments.cfcreference);
		var props = metaData.properties;
		
		
		for(i=1; i <= ArrayLen(props); i++){
			result[props[i]['name']] = props[i]['hint'];
		}
	
		return result;
	}

	

	public string function getToolTip(required string name){
		if(structKeyExists(variables.toolTips, arguments.name)){
			return variables.toolTips[arguments.name];
		}
		else{
			return "";
		}
	}
</cfscript>







