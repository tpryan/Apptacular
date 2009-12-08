<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.name" type="string" />
<cfparam name="attributes.entityName" type="string" />
<cfparam name="attributes.identity" type="string" />
<cfparam name="attributes.foreignKeylabel" type="string" />
<cfparam name="attributes.required" type="boolean" default="false" />
<cfparam name="attributes.selected" type="array" default="#ArrayNew(1)#" />

<cfset name = attributes.name />
<cfset entityName = attributes.entityName />
<cfset identity = attributes.identity />
<cfset foreignKeylabel = attributes.foreignKeylabel />
<cfset required = attributes.required />
<cfset selected = attributes.selected />


<cfset selectedStruct = structNew() />
<cfloop array="#selected#" index="selectedEntity">
	<cfinvoke component="#selectedEntity#" method="get#identity#" returnvariable="selectedColumn" />
	<cfset selectedStruct[selectedColumn] = "" />
</cfloop>

<cfif thisTag.executionMode is "start">

	<cfset HQL = "SELECT #identity#, #foreignKeylabel# FROM #entityname#" />
	<cfset Entities = ORMExecuteQuery(HQL) />
	
	
	<cfoutput>
	<select name="#name#" id="#name#" multiple="multiple">
		<cfif not attributes.required><option value="0"></option></cfif>
		<cfloop array="#entities#" index="entity">
		<option value="#entity[1]#"<cfif structKeyExists(selectedStruct, entity[1] )> selected="selected"</cfif>>#entity[2]#</option>
		</cfloop>
	</select>
	</cfoutput>
	

<cfelse>
</cfif>
</cfprocessingdirective>