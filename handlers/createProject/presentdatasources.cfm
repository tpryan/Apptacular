<cfscript>

	admin= New CFIDE.adminapi.administrator();
	admin.login(form.password, form.username);
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
		<input type="hidden" name="projectPath" value="#form.projectPath#" />
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


