<cfscript>

	loginFail = false;

	if (structKeyExists(application, "rds") AND structKeyExists(application.rds, "rememberme") and application.rds.rememberme){
		rds = application.rds;
		projectPath = url.projectPath;
		projectName = url.projectName;
	}
	else{
		rds.username = form.username;
		rds.password = form.password;
		projectPath = form.projectPath;
		projectName = form.projectName;

	}
	
	
	
	
	
	try{
		admin= New CFIDE.adminapi.administrator();
		admin.login(rds.password, rds.username);
		datasource = new CFIDE.adminapi.datasource();
		datasources = datasource.getDatasources();
		datasourceArray = StructKeyArray(datasources);
		ArraySort(datasourceArray, "textnocase", "asc");
		
		
		if (structKeyExists(form, "rememberme")){
		application.rds = {};
		application.rds.username = form.username;
		application.rds.password = form.password;
		application.rds.rememberMe = true;
	}
		
	}	
	catch(any e){
		if (FindNoCase("CFACCESSDENIED", e.errorcode)){
			loginFail = true;
			application.rds = {};
			application.rds.username = "";
			application.rds.password = "";
			application.rds.rememberMe = false;
		}
		else{
			writeDump(e);
			rethrow;
		}
	
	}
	

</cfscript>

<cfif loginFail>
	<cflocation url="login.cfm?message=loginFail&projectPath=#projectPath#" addtoken="false" />

	<cfabort>
</cfif>


<cf_pageWrapper>
<cfoutput>
	<div id="content">
		<p>Pick the datasource you'd like to use to create your application</p>
		<table>
		<form action="../handlerGenerate.cfm" method="post">
			<input type="hidden" name="projectPath" value="#projectPath#" />
			<input type="hidden" name="projectname" value="#projectname#" />
			<tr>
			<th><label for="datasource">Datasource:</label></th>
			<td>
				<select name="dsName">
					<option></option>
					<cfloop array="#datasourceArray#" index="ds">
						<option value="#ds#">#ds#</option>
					</cfloop>
				</select>
			</td>
			</tr>
			<tr>
			<th></th>
			<td>
				<input type="checkbox" name="generateremoteservices" value="true">
				<label for="generateservices">Generate Remote Services</label>
			</td>
			</tr>
			<tr><th></th><td><input type="submit" name="login" value="Generate Application" onclick="toggleLoading();"></td></tr>
		</form>
		</table>
	</div>
	<div id="loading">
		<p>Processing....</p>
		<img src ="../ajax-loader.gif" height="19" width="220"  />
	</div>
</cfoutput>


