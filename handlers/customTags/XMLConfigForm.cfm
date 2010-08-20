<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
	
	<cfparam name="attributes.fileToEdit" type="string" />
	<cfparam name="attributes.message" type="string" default="" />
	<cfparam name="attributes.cfcreference" type="string" default="" />
	<cfparam name="attributes.helper" type="any" default="" />
	<cfparam name="attributes.configFileService" type="any" default="" />
	
	<cfset message = attributes.message />
	<cfset helper = attributes.helper />
	<cfset configFileService = attributes.configFileService />
	
	<cfset stringUtil = new apptacular.handlers.cfc.utils.stringUtil() />
	
	<cfset fileToEdit = attributes.fileToEdit />
	<cfset XML = XMLParse(FileRead(fileToEdit)) />
	<cfset XMLRoot = StructKeyArray(XML)[1] />
	
	<cfset editor = new apptacular.handlers.cfc.utils.editor(XMLRoot) />
	<cfset keys = editor.getAllowedList() />
	
	
	<cfset itemQuery = queryNew("category, key") />
	<cfset lastCategory = "" />
	
	<cfloop list="#keys#" index="item">
		<cfif Find("<", item)>
			<cfset lastCategory = ReplaceList(item, "<,>,/", ",,") />
			<cfcontinue />
		</cfif>
	
		<cfset queryAddRow(itemQuery) />
		<cfset querySetCell(itemQuery,"category", lastCategory) />
		<cfset querySetCell(itemQuery,"key", item) />
	</cfloop>
	
	
	<cfoutput>
		<h1>Edit #XMLRoot#</h1>
		<p class="helplink"><a href="../doc/fields.cfm?item=#XMLRoot#">#stringUtil.CapFirst(XMLRoot)# Reference</a></p>
		<br />
		<cfif len(message)>
			<p class="alert">#message#</p>
		</cfif>
		<form action="" method="post" target="_top">
			<input type="hidden" name="fileToEdit" value="#fileToEdit#" /> 	
	</cfoutput>		
	
	<cflayout type="accordion">
	
		<cfoutput query="itemQuery" group="category">
			<cflayoutarea title="#Category#">
			<div class="accpanel">
			<table class="config">
			<cfoutput>
				<cfif editor.isBooleanUI(key)>
					<cfset setting = configFileService.getSetting(key) />
					<tr>	
						<th><label for="#key#">#helper.getDisplayName(key)#</label></th>
						<td>
							<input name="#key#" type="checkbox" id="#key#" value="true" <cfif IsBoolean(setting) AND setting>checked="checked" </cfif>/>
							<input name="#key#" type="hidden" value="false" />
						</td>			
					</tr>
				<cfelseif editor.isTextAreaUI(key)>
					<cfset setting = configFileService.getSetting(key) />
					<tr>	
						<th><label for="#key#">#helper.getDisplayName(key)#</label></th>
						<td>
							<textarea name="#key#" >#setting#</textarea>
						</td>			
					</tr>	
				<cfelse>
					<cfset setting = configFileService.getSetting(key) />
					<tr>	
						<th><label for="#key#">#helper.getDisplayName(key)#</label></th>
						<td>
							<input name="#key#" type="text" id="#key#" value="#setting#" />
						</td>			
					</tr>
				</cfif>
			</cfoutput>
			</table>
			</div>
			</cflayoutarea>
		</cfoutput>
	</cflayout>
				
	<br />
	<cfoutput><td><input type="submit" name="submit" value="Save #XMLRoot#" /></cfoutput>
			
	</form>

<cfelse>
</cfif>
</cfprocessingdirective>


