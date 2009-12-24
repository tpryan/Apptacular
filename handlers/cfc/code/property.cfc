component accessors="true" {
	
	property name="name" type="string" hint="See reference for cfproperty";
	property name="column" type="string" hint="See reference for cfproperty";
	property name="type" type="string" hint="See reference for cfproperty";
	property name="ormtype" type="string"  hint="See reference for cfproperty";
	property name="length" type="string"  hint="See reference for cfproperty";
	property name="fieldtype" type="string"  hint="See reference for cfproperty";
	property name="generator" type="string" hint="See reference for cfproperty";
	property name="fkcolumn" type="string"  hint="See reference for cfproperty";
	property name="cfc" type="string"  hint="See reference for cfproperty";
	property name="missingRowIgnored" type="boolean" default="true" hint="See reference for cfproperty";
	property name="inverse" type="boolean" default="true" hint="See reference for cfproperty";
	property name="cascade" type="string" hint="See reference for cfproperty";
	property name="collectiontype" type="string" hint="See reference for cfproperty";
	property name="singularName" type="string" hint="See reference for cfproperty";
	property name="linktable" type="string" hint="See reference for cfproperty";
	property name="InverseJoinColumn" type="string" hint="See reference for cfproperty";
	property name="lazy" type="boolean" hint="See reference for cfproperty";
	property name="orderby" type="string" hint="See reference for cfproperty";
	property name="persistent" type="string" hint="See reference for cfproperty";
	property name="setter" type="string" hint="See reference for cfproperty";
	property name="getter" type="string" hint="See reference for cfproperty";
	property name="insert" type="string" hint="See reference for cfproperty";
	property name="update" type="string" hint="See reference for cfproperty";
	
	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public property function init(){
    		
    	return This;
    }
	
	/**
		* @hint Returns the content of the property in CFML
	*/
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
		
		if (len(This.getLength())){
       		result = ListAppend(result, 'length="#This.getLength()#"', " ") ; 
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
		
		if (len(This.getlinktable())){
       		result = ListAppend(result, 'linktable="#This.getlinktable()#"', " ");
       	}
		
		if (len(This.getInverseJoinColumn())){
       		result = ListAppend(result, 'InverseJoinColumn="#This.getInverseJoinColumn()#"', " ");
       	}
		
		if (len(This.getlazy())){
       		result = ListAppend(result, 'lazy="#This.getlazy()#"', " ");
       	}
		
		if (len(This.getorderby())){
       		result = ListAppend(result, 'orderby="#This.getorderby()#"', " ");
       	}
		
		if (len(This.getpersistent())){
       		result = ListAppend(result, 'persistent="#This.getpersistent()#"', " ");
       	}
		
		if (len(This.getgetter())){
       		result = ListAppend(result, 'getter="#This.getgetter()#"', " ");
       	}
		
		if (len(This.getsetter())){
       		result = ListAppend(result, 'setter="#This.getsetter()#"', " ");
       	}
		
		if (len(This.getInsert())){
       		result = ListAppend(result, 'insert="#This.getInsert()#"', " ");
       	}
		
		if (len(This.getUpdate())){
       		result = ListAppend(result, 'update="#This.getUpdate()#"', " ");
       	}
       	
		result = result & ' />';
		return result;
	
	}
	
	/**
		* @hint Returns the content of the property in CFScript
	*/
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
		
		if (len(This.getLength())){
       		result = ListAppend(result, 'length="#This.getLength()#"', " ") ; 
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
		
		if (len(This.getlinktable())){
       		result = ListAppend(result, 'linktable="#This.getlinktable()#"', " ");
       	}
		
		if (len(This.getInverseJoinColumn())){
       		result = ListAppend(result, 'InverseJoinColumn="#This.getInverseJoinColumn()#"', " ");
       	}
		
		if (len(This.getlazy())){
       		result = ListAppend(result, 'lazy="#This.getlazy()#"', " ");
       	}
		
		if (len(This.getorderby())){
       		result = ListAppend(result, 'orderby="#This.getorderby()#"', " ");
       	}
		
		if (len(This.getpersistent())){
       		result = ListAppend(result, 'persistent="#This.getpersistent()#"', " ");
       	}
		
		if (len(This.getgetter())){
       		result = ListAppend(result, 'getter="#This.getgetter()#"', " ");
       	}
		
		if (len(This.getsetter())){
       		result = ListAppend(result, 'setter="#This.getsetter()#"', " ");
       	}
		
		if (len(This.getInsert())){
       		result = ListAppend(result, 'insert="#This.getInsert()#"', " ");
       	}
		
		if (len(This.getUpdate())){
       		result = ListAppend(result, 'update="#This.getUpdate()#"', " ");
       	}
       	
		result = result & ';';
		
		return result;
	
	}
	
	
}