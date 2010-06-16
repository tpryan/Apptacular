<cfscript>
	gitdir = ExpandPath("../");
	gitpath = "git";
	prettyFormat = "$%an%n%ad%n%s%n^";
	arguments = "--no-pager --git-dir=#gitdir#.git log --stat --pretty=#prettyFormat# --date-order --name-only";
</cfscript>
 
<cfexecute name="#gitpath#" arguments="#arguments#" timeout="60" variable="results" errorvariable="error" />


<cfscript>
	lb = createObject("java", "java.lang.System").getProperty("line.separator");
	resultsArray = ListToArray(results, "$");
	
	for (i=1; i<= ArrayLen(resultsArray); i++){
		commit = {};
		commit.files = ListToArray(getToken(resultsArray[i], 2, "^"), lb);
		commit.author = getToken(resultsArray[i], 1, lb);
		commit.date = ParseDateTime(getToken(resultsArray[i], 2, lb));
		commit.comment = getToken(resultsArray[i], 3, lb);
		resultsArray[i] = commit;
		 
	}

</cfscript>

<cfsavecontent variable="notes">
<cfoutput>
	<h2>List of Changes</h2>
	<cfloop array="#resultsArray#" index="commit">
	<dl>
		<dt><strong>#DateFormat(commit.date, "mmmm d, yyyy")# #TimeFormat(commit.date, "hh:mm tt")#</strong> - #commit.author#</dt>
		<dd>
			<p>#commit.comment#</p>
			<p>Files Changed:</p>
			<ul>
			<cfloop array="#commit.files#" index="changedFile">
				<li>#changedFile#</li>
			</cfloop>
			</ul>
		</dd>
		
	</dl>
	
	</cfloop>
	
</cfoutput>
</cfsavecontent>

<cffile action="write" file="#ExpandPath('.')#/doc_cg_changes.cfm" output="#notes#" />
