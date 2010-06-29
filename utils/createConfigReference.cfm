<cfscript>
	gitdir = ExpandPath("../");
	items.config.cfcPath = "apptacular.handlers.cfc.generators.cfapp.config";
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

	typeArray = structKeyArray(items);

</cfscript>


<cfsavecontent variable="notes">
	<h2>Configuration Reference</h2>
	<cfloop array = "#typeArray#" index="item">
	
		<cfscript>
		
		cfcPath = items[item].cfcPath;
		editorItem = items[item].editorItem;
		title = items[item].title;
		helper = new apptacular.handlers.cfc.utils.docHelper(cfcPath);
		
		tooltips = generateToolTips(cfcPath);
		editor = new apptacular.handlers.cfc.utils.editor(editorItem);
		keys = editor.getAllowedList();
		</cfscript>
		
		<cfoutput>
			<h3>#title#</h3>
			<cfloop list="#keys#" index="key">
				<cfif FindNoCase("<", key)>
					<h4>#ReplaceList(key, "<,>,/", ",,")#</h4>	
					<cfcontinue />
				</cfif>
				
				<dl>
				<dt>#helper.getDisplayName(key)#</dt>	
				<dd>#getToolTip(key)#</dd>
				</dl>
			</cfloop>
		</cfoutput>
	</cfloop>
</cfsavecontent>


<cffile action="write" file="#ExpandPath('.')#/doc_cg_ref.cfm" output="#notes#" />

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


