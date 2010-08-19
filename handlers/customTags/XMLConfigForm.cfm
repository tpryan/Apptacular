<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
	
	<cfparam name="attributes.fileToEdit" type="string" />
	<cfparam name="attributes.message" type="string" default="" />
	<cfparam name="attributes.cfcreference" type="string" default="" />
	<cfparam name="attributes.helper" type="any" default="" />
	
	<cfif isSimpleValue(attributes.helper)>
		<cfset helper = new apptacular.handlers.cfc.utils.genericHelper() />
	<cfelse>
		<cfset helper = attributes.helper />
	</cfif>
	
	<cfset stringUtil = new apptacular.handlers.cfc.utils.stringUtil() />
	
	<cfset message = attributes.message />
	
	<cfif structKeyExists(form, "submit") and not FindNoCase("references", form.submit)>
	
		<cfset XMLInfo = Duplicate(form) />
		<cfset fileToEdit = XMLInfo.filetoedit />
		<cfset structDelete(XMLInfo, "filetoedit") />
		<cfset structDelete(XMLInfo, "fieldnames") />
		<cfset structDelete(XMLInfo, "submit") />
		<cfset structDelete(XMLInfo, "_CF_CONTAINERID") />
		<cfset structDelete(XMLInfo, "_CF_NOCACHE") />
		<cfset structDelete(XMLInfo, "_CF_NODEBUG") />
		
		<cfset XML = XMLParse(FileRead(fileToEdit)) />
		<cfset XMLRoot = StructKeyArray(XML)[1] />
		<cfset Keys = StructKeyArray(XMLInfo) />
		
		<cfloop array="#keys#" index="key" >
			<cfif FindNoCase("code", key)>
				<cfset XML[XMLRoot][key]['XmlCdata'] = XMLInfo[key] />
			<cfelse>
				<cfset XML[XMLRoot][key]['XMLText'] = Trim(XMLInfo[key]) />
			</cfif>
		</cfloop>
		
		<cfset FileWrite(fileToEdit,XML) />
		<cfset message = "Changes Saved" />
	</cfif>
	
	
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
					<tr>	
						<th><label for="#key#">#helper.getDisplayName(key)#</label></th>
						<td>
							<input name="#key#" type="radio" id="#key#true" value="true" <cfif IsBoolean(XML[XMLRoot][key]['XMLText']) AND XML[XMLRoot][key]['XMLText']>checked="checked" </cfif>/>
							<label for="#key#true">True</label>
							<input name="#key#" type="radio" id="#key#false" value="false" <cfif IsBoolean(XML[XMLRoot][key]['XMLText']) AND NOT XML[XMLRoot][key]['XMLText']>checked="checked" </cfif>/>
							<label for="#key#false">False</label>
						</td>			
					</tr>
				<cfelseif editor.isTextAreaUI(key)>
					<tr>	
						<th><label for="#key#">#helper.getDisplayName(key)#</label></th>
						<td>
							<textarea name="#key#" >#XML[XMLRoot][key]['XMLText']#</textarea>
						</td>			
					</tr>	
				<cfelse>
					<cfif StructKeyExists(XML[XMLRoot], key)>
						<cfset setting = XML[XMLRoot][key]['XMLText'] />
					<cfelse>
						<cfset setting = "" />
					</cfif>
					
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


