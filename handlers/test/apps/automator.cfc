<cfcomponent>

	<cffunction name="init" output="FALSE" access="public"  returntype="any" hint="Psuedo constructor that allows us to play our object games." >
    	<cfargument name="configPath" type="string" required="TRUE" hint="The path to a IDE XML file." />
    	<cfset variables.configPath = arguments.configPath />	
		
		<cfscript>
			variables.XMLContents = XMLParse(FileRead(variables.configPath));
		</cfscript>
		
		<cfreturn This />
    </cffunction>

	<cffunction name="generateApplication" output="FALSE" access="public"  returntype="boolean" hint="" >
		
		
		<cfscript>
			var targeturl = "http://" & cgi.server_name & "/apptacular/handlers/handlerGenerate.cfm";
		</cfscript>
		
		<cfhttp url="#targeturl#" timeout="300" method="post" >
			<cfhttpparam name="ideeventInfo" type="formfield" value="#variables.XMLContents#" />
		</cfhttp>
	
		<cfif FindNoCase('response showresponse="true"', cfhttp.filecontent)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	
	</cffunction>
	
	<cffunction name="clearFiles" output="FALSE" access="public"  returntype="void" hint="" >
	
		<cfscript>
			var location = XMLSearch(XMLContents, "/event/user/input[@name='Location']")[1].XMLAttributes.value & "/";
			var files = directoryList(location, false, "query");
		</cfscript>
		
		<cfquery name="files" dbtype="query">
			SELECT 	*
			FROM 	files
			WHERE 	name != '.project'
			AND		name != '.settings'
		</cfquery>
		
		<cfloop query="files">
			<cfif FindNoCase("dir", type)>
				<cfset DirectoryDelete(directory & "/" & name, true) />
			<cfelse>
				<cfset FileDelete(directory & "/" & name) />
			</cfif>
		</cfloop>
		
	</cffunction>
	
</cfcomponent>