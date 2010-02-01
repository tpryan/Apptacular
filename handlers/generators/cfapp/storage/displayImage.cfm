<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfparam name="attributes.image" default ="" />
<cfparam name="attributes.maxheight" default="0" type="numeric" />
<cfparam name="attributes.maxwidth" default="0" type="numeric" />

<!--- short curcuit if there is no image --->
<cfif isNull(attributes.image)>
	[No image uploaded]
	<cfexit />
</cfif>

<!--- Convert to image variable --->
<cftry>
	<cfset localImage = ImageNew(attributes.image) />
	<cfcatch>
		<cfif FindNoCase("ColdFusion was unable to create an image",cfcatch.message)>
			[Unsupported image]
		<cfelse>
			<cfrethrow />
		</cfif>
	</cfcatch>
</cftry>


<!--- Resize if need be --->
<cfif attributes.maxWidth gt 0>
	<cfset ImageScaleToFit(localImage, attributes.maxWidth, "") />
<cfelseif attributes.maxHeight gt 0>
	<cfset ImageScaleToFit(localImage, "", attributes.maxHeight) />
</cfif>

<!--- Display --->
<cftry>
	<cfimage action="writeToBrowser" source="#localImage#" />
	<cfcatch>
		<cfif FindNoCase("ColdFusion was unable to create an image",cfcatch.message)>
			[Unsupported image]
		<cfelse>
			<cfrethrow />
		</cfif>
	</cfcatch>
</cftry>

<cfelse>
</cfif>
</cfprocessingdirective>