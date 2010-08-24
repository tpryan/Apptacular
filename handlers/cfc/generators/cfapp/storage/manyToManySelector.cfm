<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.name" type="string" />
<cfparam name="attributes.entityName" type="string" />
<cfparam name="attributes.identity" type="string" />
<cfparam name="attributes.foreignKeylabel" type="string" />
<cfparam name="attributes.required" type="boolean" default="false" />
<cfparam name="attributes.selected" type="array" default="#ArrayNew(1)#" />
<cfparam name="attributes.orderby" type="string" default="" />

<cfset name = attributes.name />
<cfset entityName = attributes.entityName />
<cfset identity = attributes.identity />
<cfset foreignKeylabel = attributes.foreignKeylabel />
<cfset required = attributes.required />
<cfset selected = attributes.selected />
<cfset orderby = attributes.orderby />

<cfset selectedStruct = structNew() />
<cfloop array="#selected#" index="selectedEntity">
	<cfinvoke component="#selectedEntity#" method="get#identity#" returnvariable="selectedColumn" />
	<cfset selectedStruct[selectedColumn] = "" />
</cfloop>

<cfif thisTag.executionMode is "start">

	<cfset HQL = "SELECT #identity#, #foreignKeylabel# FROM #entityName# ORDER BY #orderby#" />
	<cfset entityArray = ormExecuteQuery(HQL) />
	
	<cfoutput>
	<select name="#name#" id="#name#" multiple="multiple">
		<cfif not attributes.required><option></option></cfif>
		<cfloop array="#entityArray#" index="item">
			<cfset id = item[1] />
			<cfset fklabel = item[2] />
			<option value="#id#"<cfif structKeyExists(selectedStruct, id)> selected="selected"</cfif>>#fklabel#</option>
		</cfloop>
	</select>
	</cfoutput>

<cfelse>
</cfif>
</cfprocessingdirective>