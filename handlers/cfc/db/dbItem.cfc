/**
 * @hint Creates functionality that should be shared among all of the database components.
 */
component 
{
	/**
	 * @hint Creates an XML version of the data in these CFCs
	 */
	public string function serialize(){
		var XML = toXML();
		return XML;
	}
	
	/**
	 * @hint Creates an easy to compare version of the content
	 */
	public string function getCheckSum(){
		return Hash(toXML());
	}
	
	/**
	 * @hint Handles pulling all of the content that doesn't need to be in a CFC out and toXML's the rest
	 */
	public string function objectToXML(required string type){
		var str = createObject("java", "java.lang.StringBuilder").init();
		var NL = CreateObject("java", "java.lang.System").getProperty("line.separator");
		var props = Duplicate(variables);
		var i = 0;
		
		StructDelete(props, "This");
		StructDelete(props, "dbinfo");
		StructDelete(props, "utils");
		StructDelete(props, "mappings");
		StructDelete(props, "references");
		StructDelete(props, "joinedTables");
		StructDelete(props, "joinTables");
		StructDelete(props, "columns");
		StructDelete(props, "columnsStruct");
		StructDelete(props, "tables");
		StructDelete(props, "tablesStruct");
		StructDelete(props, "REF");
		StructDelete(props, "referenceCounts");
		StructDelete(props, "foreignTables");
		StructDelete(props, "excludedtables");
		StructDelete(props, "excludedtablelist");
		StructDelete(props, "virtualcolumns");
		StructDelete(props, "datasource");
		StructDelete(props, "engine");
		StructDelete(props, "LOG");
		StructDelete(props, "stringUtil");
		StructDelete(props, "fullyQualifiedTableName");
		StructDelete(props, "countQry");
		StructDelete(props, "reservedWordHelper");
		
		var keys = StructKeyArray(props);
		ArraySort(keys, "textnocase");
		
		str.append('<?xml version="1.0" encoding="iso-8859-1"?>');
		str.append(NL);
		
		str.append('<#arguments.type#>');
		str.append(NL);
		
		for (i=1; i <= ArrayLen(keys); i++){
			if (not IsCustomFunction(props[keys[i]]) ){
				str.append('	');
				str.append('<#keys[i]#>');
				str.append('#props[keys[i]]#');
				str.append('</#keys[i]#>');
				str.append(NL);
			}
		}
		
		str.append('</#arguments.type#>');
		str.append(NL); 
		
		return str; 
	} 

	/**
	 * @hint Capitalizes a phrase as a title.
	 */
	public string function capitalize(required string str){
	
		var newstr = "";
	   	var word = "";
	    var separator = "";
	    var wordArray = ListtoArray(arguments.str, " ");
		var i = 0;
		
		for (i=1; i <= ArrayLen(wordArray); i++){
	        newstr = newstr & separator & UCase(left(wordArray[i],1)) ;
	        if (len(wordArray[i]) gt 1){
	            newstr = newstr & LCase(right(wordArray[i],len(wordArray[i])-1));
	        }
	        separator = " ";
	    }
		
	    return newstr;
	}

	/**
	 * @hint Plural of a string
	 */
	public string function pluralize(required string str){
		if(compareNoCase(Right(str, 1),"y") eq 0){
			return Left(str, len(str)-1) & "ies"; 
		}
		else if(compareNoCase(Right(str, 1),"s") eq 0){
			return str & "es"; 
		}
		else{
			return str & "s"; 
		}
	}
	

}