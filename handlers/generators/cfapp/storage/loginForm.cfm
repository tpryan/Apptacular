<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">

<cfparam name="attributes.username" type="string" default="" />
<cfparam name="attributes.message" type="string" default="" />
<form action="" method="post" id="login">
<cfoutput>
		
		<cfif len(attributes.message) gt 0>
			<p id="message" class="alert">#attributes.message#</p>
		<cfelse>
			<p id="message">Please login</p>
		</cfif>
	
		<label for="username">Username:</label>
		<input name="username" id="username" type="text" value="#attributes.username#" /><br />
		
		<label for="password">Password:</label>
		<input name="password" id="password" type="password" value="" /><br />
		
		<input name="login" type="submit" value="Login" />
	
</cfoutput>
</form>

<cfelse>
</cfif>
</cfprocessingdirective>