
<cfscript>
	
	loginFail = false;
	builderHelper = application.builderHelper;
	projectPath = builderHelper.getProjectPath();
	projectName = builderHelper.getProjectName();
	ideVersion = builderHelper.getCFBuilderVersion();

	
	
	if (builderHelper.getCFBuilderVersion() < 2){
	
		if (structKeyExists(application, "rds") AND structKeyExists(application.rds, "rememberme") and application.rds.rememberme){
			rds = application.rds;
		}
		else{
			rds.username = form.username;
			rds.password = form.password;
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
	}
	else{
		datasourceArray = builderHelper.getDatasources();
	
	}	
	

</cfscript>

<cfif loginFail>
	<cflocation url="login.cfm?message=loginFail" addtoken="false" />

	<cfabort>
</cfif>


<cf_pageWrapper showToolBar="false">
<cfoutput>
	<div id="content">
		<p>Pick the datasource you'd like to use to create your application</p>
		<table>
		<form action="../handlerGenerate.cfm" method="post">
			<input type="hidden" name="operation" value="createProject" />
			<tr>
			<th><label for="datasource">Datasource:</label></th>
			<td>
				<select name="dsName">
					<option></option>
					<cfloop array="#datasourceArray#" index="ds">
						<cfif IsStruct(ds)>
							<option value="#ds.name#">#ds.name# (#ds.server#)</option>
						<cfelse>			
							<option value="#ds#">#ds#</option>
						</cfif>
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


