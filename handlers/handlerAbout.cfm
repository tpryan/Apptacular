<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "about/index.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & handlerPath />

<cf_ideWrapper messageURL="#handlerURL#" />