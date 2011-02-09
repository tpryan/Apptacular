<cfparam name="url.message" type="string" default="" />

<!--- TODO: Go back and figure out why two ideVersions are added. For now fix. --->
<cfset url.ideVersion = ListFirst(url.ideVersion) />

<cf_pageWrapper showToolBar="false">
<cfoutput>
	<cfif FindNoCase("loginFail", url.message)>
		<p class="alert">Login Failed. Please retry.</p>
	<cfelse>
		<p>Please enter your RDS username and password.</p>
	</cfif>
	
	<table>
	<form action="presentdatasources.cfm" method="post">
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