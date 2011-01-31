<cfsetting showdebugoutput="false" />
<cfprocessingdirective suppresswhitespace="yes">
    
<cfparam name="attributes.ideVersion" type="numeric" default="1.0" >
<cfparam name="attributes.projectname" type="string" default="" > 
<cfparam name="attributes.rootFilePath" type="string" default="" >    
    
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.messageURL" type="string" />

<cfif Find("?",attributes.messageURL) gt 0>
	<cfset attributes.messageURL = attributes.messageURL & "&amp;ideVersion=#attributes.ideVersion#" /> 
<cfelse>
   	<cfset attributes.messageURL = attributes.messageURL & "?ideVersion=#attributes.ideVersion#" />  
</cfif>


<cfif structKeyExists(url, "ideeventInfo")>
   	<cfset attributes.messageURL = attributes.messageURL & "&amp;ideeventInfo=#UrlEncodedFormat(url.ideeventInfo)#" />  
</cfif> 

<cfif FindNoCase("Jakarta",cgi.HTTP_USER_AGENT) eq 0>
    <cflog text="Redirecting out of Eclipse Browser - #attributes.messageURL#" >
	<cflocation url="#ReplaceNoCase(attributes.messageURL, "&amp;", "&","ALL")#" addtoken="false" />
</cfif>


<cfheader name="Content-Type" value="text/xml">
<response showresponse="true" >
	<cfoutput><ide url="#attributes.messageURL#" ></cfoutput>
		<cfif attributes.ideVersion lt 2.0>
			<dialog title="Apptacular" image="handlers/logo.png"  width="710" height="690" />
		<cfelse>
		    <view id="ApptacularView" title="Apptacular" />
			<cfif len(attributes.projectname)>
				<commands>
					<command type="refreshProject">
						<params>
							<param key="projectname" value="<cfoutput>#attributes.projectname#</cfoutput>" />
						</params>
					</command>
				</commands>
			</cfif> 
		</cfif>    

<cfelse>
	<cfoutput>#thisTag.generatedContent#</cfoutput>
	</ide> 
</response> 

</cfif>
</cfprocessingdirective>
