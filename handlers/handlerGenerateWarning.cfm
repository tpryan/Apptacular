<cfdirectory action="list" directory="#rootFilePath#" name="projectFiles" listinfo="name" recurse="true" />
	
	
<cfquery name="otherFiles" dbtype="query">
	SELECT 	*
	FROM	projectFiles
	WHERE 	name != '.apptacular'
	AND		name != '.project'
	AND 	name != '.settings'
	AND 	name != '.settings/org.eclipse.core.resources.prefs'
	AND 	name != 'settings.xml'
</cfquery>


<cf_pageWrapper>
	<p>The folder you want to build in is already populated and is not an Apptacular app. Is this okay?</p>
	
	<cfoutput>
    	<form action="handlerGenerate.cfm" method="post">
			<input name="projectPath" type="hidden" value="#url.rootFilePath#" />
			<input name="dsName" type="hidden" value="#url.dsName#" />
			<input name="confirmed" type="hidden" value="true" />
			<input name="submit" type="submit" value="Sure go ahead." onclick="toggleLoading();"/>
		</form> 
    </cfoutput>
	
	<div id="loading">
		<p>Processing....</p>
		<img src ="../ajax-loader.gif" height="19" width="220"  />
	</div>
	
	<p>Files:</p>
	<ul>
		<cfoutput query="otherFiles">
			<li>#name#</li>
		</cfoutput>
	</ul>
	
</cf_pageWrapper>