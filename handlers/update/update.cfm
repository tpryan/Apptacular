<cfscript>
	appFolder = ExpandPath('.');
	application.update.getLatestZip(appFolder);
	resultFile = appFolder & "/Apptacular.zip";
	
	if (FileExists("#appFolder#/Apptacular")){
		FileMove("#appFolder#/Apptacular", resultFile) ;
	}
	 
	apptacularParentFolder = ExpandPath("../../");
</cfscript>


<cfzip action="unzip" destination="#apptacularPArentFolder#" file="#resultFile#" overwrite="true" />
<cfset fileDelete(resultFile) />

<cf_pageWrapper showToolbar="false">
	<cfoutput><p>Apptacular has been updated to version #application.update.getLatestVersion()#</p></cfoutput>
</cf_pageWrapper>
<cfset applicationStop() />