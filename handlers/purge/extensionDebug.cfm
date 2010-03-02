
<cfprocessingdirective suppresswhitespace="yes">
<cfheader name="Content-Type" value="text/xml">
<cfif thisTag.executionMode is "start">
<response status="success" showresponse="true">
	<ide >
		<dialog  />
			<body>
				<![CDATA[
				<cfoutput>#thisTag.GeneratedContent#</cfoutput>	

<cfelse>

]]>
			</body>
	</ide>
</response>
<cfabort>
</cfif>
</cfprocessingdirective>
