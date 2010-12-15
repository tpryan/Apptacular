<cfset handlerPath = getDirectoryFromPath(cgi.script_name) & "about/index.cfm" />
<cfset handlerURL = "http://" & cgi.server_name & ":" & cgi.server_port & handlerPath />

<cf_ideWrapper messageURL="#handlerURL#" />