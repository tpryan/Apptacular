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
	
	<cfset HQL = "SELECT #identity#, #foreignKeylabel# FROM #entityName# ORDER BY #orderby#" />
	<cfset entityArray = ormExecuteQuery(HQL) />
	
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