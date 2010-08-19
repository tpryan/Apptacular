<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">

	<cfscript>
	
		if (structKeyExists(form, "submit") and FindNoCase("references", form.submit)){
			formInfo = duplicate(form);
			structDelete(formInfo, "submit");
			structDelete(formInfo, "fieldnames");
			
			filesToEdit = structKeyArray(formInfo);
			
			for (i = 1; i <= ArrayLen(filesToEdit); i++){
				filePath = urlDecode(filesToEdit[i]);
				fileXML = XMLParse(FileRead(filePath));
				fileXML.reference.includeInEntity.XMLText = formInfo[filesToEdit[i]];
				fileWrite(filePath,fileXML);
			}
			
		}
		
	</cfscript>


	<cfparam name="attributes.message" type="string" default="" />
	<cfparam name="attributes.tablePathToEdit" type="string" />
	<cfparam name="attributes.fileQuery" type="query" />
	<cfset fileQuery = attributes.fileQuery />
	<cfset path = attributes.tablePathToEdit />
	<cfset message = attributes.message />
	<cfset variables.FS = createObject("java", "java.lang.System").getProperty("file.separator") />
	
	
	<cfoutput>	
		<h2>Edit Referencess</h2>
		<p class="helplink">
			<a href="../doc/fields.cfm?item=reference">Reference Reference</a>
		</p>
		<cfif len(message)>
			<p class="alert">#message#</p>
		</cfif>
	
	<form action="?path=#path#&amp;tab=reference&amp;message=References Updated" method="post">
	</cfoutput>
	<table>
		<tr>
			<th>Column</th>
			<th>Referenced Table</th>
			<th>Should this relationship get wired up?</th>
		</tr>
	<cfloop query="fileQuery">
		<cfset path = directory & FS & name />
		<cfset refXML = XMLParse(fileRead(path)) />
		<cfset safePath = URLEncodedFormat(path) />
		
		<cfoutput>
        	<tr>
				<td>#refXML.reference.foreignKey.xmlText#</td>
				<cfif refXML.reference.isJoinTable.xmlText>
					<td>#refXML.reference.OtherTable.xmlText# (Many to Many through #refXML.reference.foreignKeyTable.xmlText#)</td>
				<cfelse>
					<td>#refXML.reference.foreignKeyTable.xmlText#</td>
				</cfif>
				<td>
					<input id="#safePath#true" type="radio" name="#safePath#"<cfif refXML.reference.includeInEntity.xmlText>checked="checked" </cfif> value="true" />
					<label for ="#safePath#true">True</label>
					<input id="#safePath#false" type="radio" name="#safePath#"<cfif not refXML.reference.includeInEntity.xmlText>checked="checked" </cfif> value="false" />
					<label for ="#safePath#false">False</label>
				</td>
			</tr>
        </cfoutput>
		
	</cfloop>
	</table>
	<input type="submit" name="submit" value="Save References" />
	</form>




<cfelse>
</cfif>
</cfprocessingdirective>

