<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.name" type="string" />
<cfparam name="attributes.entityName" type="string" />
<cfparam name="attributes.identity" type="string" />
<cfparam name="attributes.foreignKeylabel" type="string" />
<cfparam name="attributes.fieldValue" type="string" />
<cfparam name="attributes.required" type="boolean" default="false" />

<cfset name = attributes.name />
<cfset entityName = attributes.entityName />
<cfset identity = attributes.identity />
<cfset foreignKeylabel = attributes.foreignKeylabel />
<cfset fieldValue = attributes.fieldValue />

<cfif thisTag.executionMode is "start">

	<cfset HQL = "SELECT #identity#, #foreignKeylabel# FROM #entityname#" />
	<cfset Entities = ORMExecuteQuery(HQL) />
	
	
	<cfoutput>
	<select name="#name#" id="#name#">
		<cfif not attributes.required><option value="0"></option></cfif>
		<cfloop array="#entities#" index="entity">
		<option value="#entity[1]#"<cfif entity[1] eq fieldValue> selected="selected"</cfif>>#entity[2]#</option>
		</cfloop>
	</select>
	</cfoutput>
	

<cfelse>
</cfif>
</cfprocessingdirective>