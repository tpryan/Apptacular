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
	
	<cfset message = attributes.message />
	<cfset tooltips = generateToolTips(attributes.cfcreference) />
	
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
	
	
	<cfoutput>
		<h1>Edit #XMLRoot#</h1>
		<p class="helplink"><a href="../doc/fields.cfm?item=#XMLRoot#">#CapFirst(XMLRoot)# Reference</a></p>
		<br />
		<cfif len(message)>
			<p class="alert">#message#</p>
		</cfif>
		<form action="" method="post" target="_top">
			<input type="hidden" name="fileToEdit" value="#fileToEdit#" /> 	
			<table>
			
			<cfloop list="#keys#" index="key" >
				<cfif FindNoCase("<", key)>
					<tr><th>&nbsp;</th></tr>	
					<tr><th /><th><strong>#ReplaceList(key, "<,>,/", ",,")#</strong></th></tr>	
					<cfcontinue />
				
				</cfif>
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
					
				
			</cfloop>
				<tr>
					<th />
					<cfoutput><td><input type="submit" name="submit" value="Save #XMLRoot#" /></cfoutput>
				</tr>
			</table>
			
		</form>
	
    </cfoutput>

<cfelse>
</cfif>
</cfprocessingdirective>

<cfscript>
	
	public struct function generateToolTips(string cfcreference =""){
		var i =  0;
		var result = StructNew();
		if (len(arguments.cfcreference) < 1){
			return result;
		}
		var metaData = GetComponentMetaData(arguments.cfcreference);
		var props = metaData.properties;
		
		
		for(i=1; i <= ArrayLen(props); i++){
			result[props[i]['name']] = props[i]['hint'];
		}
	
		return result;
	}

	

	public string function getToolTip(required string name){
		if(structKeyExists(variables.toolTips, arguments.name)){
			return variables.toolTips[arguments.name];
		}
		else{
			return "";
		}
	}
</cfscript>

<!---
Capitalizes the first letter in each word.
Made udf use strlen, rkc 3/12/02
v2 by Sean Corfield.

@param string      String to be modified. (Required)
@return Returns a string. 
@author Raymond Camden (ray@camdenfamily.com) 
@version 2, March 9, 2007 
--->
<cffunction name="CapFirst" returntype="string" output="false">
    <cfargument name="str" type="string" required="true" />
    
    <cfset var newstr = "" />
    <cfset var word = "" />
    <cfset var separator = "" />
    
    <cfloop index="word" list="#arguments.str#" delimiters=" ">
        <cfset newstr = newstr & separator & UCase(left(word,1)) />
        <cfif len(word) gt 1>
            <cfset newstr = newstr & right(word,len(word)-1) />
        </cfif>
        <cfset separator = " " />
    </cfloop>

    <cfreturn newstr />
</cffunction>