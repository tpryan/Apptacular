<cfparam name="url.projectPath" type="string" />


<cf_pageWrapper>
<cfoutput>
	<p>Please enter your RDS username and password.</p>
	<table>
	<form action="presentdatasources.cfm" method="post">
		<input type="hidden" name="projectPath" value="#url.projectPath#" />
		<tr>
		<th><label for="username">Username:</label></th>
		<td><input name="username" id="username" type="text" /></td>
		</tr>
		<tr>
		<th><label for="password">Password:</label></th>
		<td><input name="password" id="password" type="password" /></td>
		</tr>
		<tr><th></th><td><input type="submit" name="login" value="Login"></td></tr>
	</form>
	</table>
</cfoutput>


</cf_pageWrapper>