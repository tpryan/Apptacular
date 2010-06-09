<cfscript>

	if (structKeyExists(application, "rds") AND structKeyExists(application.rds, "rememberme") and application.rds.rememberme){
		rds = application.rds;
		projectPath = url.projectPath;
	}
	else{
		rds.username = form.username;
		rds.password = form.password;
		projectPath = form.projectPath;
	}
	
	
	
	if (structKeyExists(form, "rememberme")){
		application.rds = {};
		application.rds.username = form.username;
		application.rds.password = form.password;
		application.rds.rememberMe = true;
	}
	
	admin= New CFIDE.adminapi.administrator();
	admin.login(rds.password, rds.username);
	datasource = new CFIDE.adminapi.datasource();
	datasources = datasource.getDatasources();
	datasourceArray = StructKeyArray(datasources);
	ArraySort(datasourceArray, "textnocase", "asc");

</cfscript>

<cf_pageWrapper>
<cfoutput>
	<p>Pick the datasource you'd like to use to create your application</p>
	<table>
	<form action="../handlerGenerate.cfm" method="post">
		<input type="hidden" name="projectPath" value="#projectPath#" />
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
		<tr><th></th><td><input type="submit" name="login" value="Generate Application"></td></tr>
	</form>
	</table>
</cfoutput>


