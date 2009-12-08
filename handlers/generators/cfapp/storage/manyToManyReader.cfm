<cfprocessingdirective suppresswhitespace="yes">

<cfparam name="attributes.entityName" type="string" />
<cfparam name="attributes.identity" type="string" />
<cfparam name="attributes.foreignKeylabel" type="string" />
<cfparam name="attributes.selected" type="array" />

<cfset entityName = attributes.entityName />
<cfset identity = attributes.identity />
<cfset foreignKeylabel = attributes.foreignKeylabel />
<cfset selected = attributes.selected />


<cfif thisTag.executionMode is "start">

	<cfoutput>
		<cfloop index="i" from="1" to="#arrayLen(selected)#">
			<cfset entity = selected[i] />
			<cfinvoke component="#entity#" method="get#identity#" returnvariable="entityIdentity" />
			<cfinvoke component="#entity#" method="get#foreignKeylabel#" returnvariable="entityForeignKeylabel" />
			<a href="#entityName#.cfm?method=read&amp;#identity#=#entityIdentity#">#entityForeignKeylabel#</a>
			<cfif i neq arrayLen(selected)>,</cfif>
		</cfloop>
	
	</cfoutput>
	

<cfelse>
</cfif>
</cfprocessingdirective>