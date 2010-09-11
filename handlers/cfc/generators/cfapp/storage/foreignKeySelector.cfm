<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.name" type="string" />
<cfparam name="attributes.entityName" type="string" />
<cfparam name="attributes.identity" type="string" />
<cfparam name="attributes.foreignKeylabel" type="string" />
<cfparam name="attributes.fieldValue" type="string" />
<cfparam name="attributes.required" type="boolean" default="false" />
<cfparam name="attributes.orderby" type="string" default="" />

<cfset name = attributes.name />
<cfset entityName = attributes.entityName />
<cfset identity = attributes.identity />
<cfset foreignKeylabel = attributes.foreignKeylabel />
<cfset fieldValue = attributes.fieldValue />
<cfset orderby = attributes.orderby />

<cfif thisTag.executionMode is "start">
	
	<cfif isFKLabelVirtual(entityName, foreignKeylabel)> 
		<cfset entityArray = getVirtualFKLabels(entityName, foreignKeylabel, identity) />
	<cfelse>	
		<cfset HQL = "SELECT #identity#, #foreignKeylabel# FROM #entityName# ORDER BY #orderby#" />
		<cfset entityArray = ormExecuteQuery(HQL) />
	</cfif>
	
	
	
	<cfoutput>
	<select name="#name#" id="#name#">
		<cfif not attributes.required><option></option></cfif>
		<cfloop array="#entityArray#" index="item">
			<cfset id = item[1] />
			<cfset fklabel = item[2] />
			<option value="#id#"<cfif id eq fieldValue> selected="selected"</cfif>>#fklabel#</option>
		</cfloop>
	</select>
	</cfoutput>

<cfelse>
</cfif>
</cfprocessingdirective>

<cfscript>
	public boolean function isFKLabelVirtual(required string entityName, required string foreignKeyLabel){
		var tempObj = EntityNew(arguments.entityName);
		var metaDataInfo = getMetadata(tempObj).properties;
		var i = 0;
		var result = false;
		
		for (i=1;i<=ArrayLen(metaDataInfo);i++){
			if (compareNoCase(metaDataInfo[i]['name'], arguments.foreignKeyLabel) eq 0 ){
				if (structKeyExists(metaDataInfo[i], "hint") && 
					compareNoCase(metaDataInfo[i]['hint'], "Virtual Column")eq  0){
					result = true;
				}
				break;		
			}
		}
		return result;
	}
	
	public array function getVirtualFKLabels(required string entityName, required string foreignKeyLabel, required string identity){
		var items = entityLoad(arguments.entityName);
		
		var i = 0;
		var result = [];
		
		for (i=1;i<=ArrayLen(items);i++){
			var item = items[i];
			var itemArray = [];
			itemArray[1] = Evaluate("item.get#arguments.identity#()");
			itemArray[2] = Evaluate("item.get#arguments.foreignKeyLabel#()");
			ArrayAppend(result, itemArray);
		}
		
		return result;
	}

</cfscript>