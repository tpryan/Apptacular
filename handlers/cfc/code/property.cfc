component accessors="true" {
	
	property name="name";
	property name="column";
	property name="type";
	property name="ormtype";
	property name="length";
	property name="fieldtype";
	property name="generator";
	property name="fkcolumn";
	property name="cfc";
	property name="missingRowIgnored" type="boolean" default="true";
	property name="inverse" type="boolean" default="true";
	property name="cascade";
	property name="collectiontype";
	property name="singularName";
	
	
	public string function getCFML(){
		var result = "";
		
		result = result & '<cfproperty';	
		
		if (len(This.getName())){
			result = ListAppend(result, 'name="#This.getName()#"', " ") ;
       	}
       
       	if (len(This.getColumn())){
       		result = ListAppend(result, 'column="#This.getColumn()#"', " ") ;
       	}
       
      	if (len(This.getormtype())){
       		result = ListAppend(result, 'ormtype="#This.getormtype()#"', " ") ;
       	}
		
		if (len(This.gettype())){
       		result = ListAppend(result, 'type="#This.gettype()#"', " ") ;
       	}
       	
       	if (len(This.getFieldtype())){
       		result = ListAppend(result, 'fieldtype="#This.getFieldtype()#"', " ") ;
       	}
       		
       	if (len(This.getGenerator())){
       		result = ListAppend(result, 'generator="#This.getGenerator()#"', " ") ;
       	}
       
       	if (len(This.getCFC())){
       		result = ListAppend(result, 'cfc="#This.getCFC()#"', " ") ;
       	}
       
       	if (len(This.getFkColumn())){
       		result = ListAppend(result, 'fkColumn="#This.getFkColumn()#"', " ") ;
       	}
       	
       	if (len(This.getmissingRowIgnored())){
       		result = ListAppend(result, 'missingRowIgnored="#This.getmissingRowIgnored()#"', " ") ; 
       	}
       	
       	if (len(This.getinverse())){
       		result = ListAppend(result, 'inverse="#This.getinverse()#"', " ") ; 
       	}
       	
       	if (len(This.getcascade())){
       		result = ListAppend(result, 'cascade="#This.getcascade()#"', " ") ;
       	}
       	
       	if (len(This.getcollectiontype())){
       		result = ListAppend(result, 'collectiontype="#This.getcollectiontype()#"', " ") ; 
       	}
       	
       	if (len(This.getSingularName())){
       		result = ListAppend(result, 'SingularName="#This.getSingularName()#"', " ");
       	}
       	
		result = result & ' />';
		return result;
	
	}
	
	
	public string function getCfScript(){
		var result = "";
		
		result = result & 'property';	
		
		if (len(This.getName())){
			result = ListAppend(result, 'name="#This.getName()#"', " ") ;
       	}
       
       	if (len(This.getColumn())){
       		result = ListAppend(result, 'column="#This.getColumn()#"', " ") ;
       	}
       
      	if (len(This.getormtype())){
       		result = ListAppend(result, 'ormtype="#This.getormtype()#"', " ") ;
       	}
		
		if (len(This.gettype())){
       		result = ListAppend(result, 'type="#This.gettype()#"', " ") ;
       	}
       	
       	if (len(This.getFieldtype())){
       		result = ListAppend(result, 'fieldtype="#This.getFieldtype()#"', " ") ;
       	}
       		
       	if (len(This.getGenerator())){
       		result = ListAppend(result, 'generator="#This.getGenerator()#"', " ") ;
       	}
       
       	if (len(This.getCFC())){
       		result = ListAppend(result, 'cfc="#This.getCFC()#"', " ") ;
       	}
       
       	if (len(This.getFkColumn())){
       		result = ListAppend(result, 'fkColumn="#This.getFkColumn()#"', " ") ;
       	}
       	
       	if (len(This.getmissingRowIgnored())){
       		result = ListAppend(result, 'missingRowIgnored="#This.getmissingRowIgnored()#"', " ") ; 
       	}
       	
       	if (len(This.getinverse())){
       		result = ListAppend(result, 'inverse="#This.getinverse()#"', " ") ; 
       	}
       	
       	if (len(This.getcascade())){
       		result = ListAppend(result, 'cascade="#This.getcascade()#"', " ") ;
       	}
       	
       	if (len(This.getcollectiontype())){
       		result = ListAppend(result, 'collectiontype="#This.getcollectiontype()#"', " ") ; 
       	}
       	
       	if (len(This.getSingularName())){
       		result = ListAppend(result, 'SingularName="#This.getSingularName()#"', " ");
       	}
       	
		result = result & ';';
		
		return result;
	
	}
	
	
}