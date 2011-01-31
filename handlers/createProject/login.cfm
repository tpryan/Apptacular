<cfparam name="url.projectPath" type="string" />
<cfparam name="url.message" type="string" default="" />
<cfparam name="url.ideVersion" type="numeric" default="1.0" />
<cf_pageWrapper>
<cfoutput>
	<cfif FindNoCase("loginFail", url.message)>
		<p class="alert">Login Failed. Please retry.</p>
	<cfelse>
		<p>Please enter your RDS username and password.</p>
	</cfif>
	
	<table>
	<form action="presentdatasources.cfm" method="post">
		<input type="hidden" name="projectPath" value="#url.projectPath#" />
		<input type="hidden" name="projectName" value="#url.projectName#" />
		<input type="hidden" name="ideVersion" value="#url.ideVersion#" />
		<tr>
		<th><label for="username">Username:</label></th>
		<td><input name="username" id="username" type="text" /></td>
		</tr>
		<tr>
		<th><label for="password">Password:</label></th>
		<td><input name="password" id="password" type="password" /></td>
		</tr>
		<tr>
		<th><label for="rememberme">Remember me on this machine:</label></th>
		<td><input name="rememberme" id="rememberme" type="checkbox" value="true" /></td>
		</tr>
		<tr><th></th><td><input type="submit" name="login" value="Login"></td></tr>
	</form>
	</table>
</cfoutput>


</cf_pageWrapper>