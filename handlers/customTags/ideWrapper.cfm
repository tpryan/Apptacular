<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.messageURL" type="string" />

<cfheader name="Content-Type" value="text/xml">
<response showresponse="true">
	<cfoutput><ide url="#attributes.messageURL#" ></cfoutput>
		<dialog title="Apptacular" image="handlers/logo.png"  width="655" height="600" />


<cfelse>
	<cfoutput>#thisTag.generatedContent#</cfoutput>
	</ide> 
</response> 

</cfif>
</cfprocessingdirective>
