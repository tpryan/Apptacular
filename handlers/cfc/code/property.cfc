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
		var result = CreateObject("java","java.lang.StringBuilder").Init();
		
		result = result.append('<cfproperty ');	
		result = addPropertyAttributes(result);
		result = result.append(' />');
		
		return result;
	}
	
	/**
		* @hint Returns the content of the property in CFScript
	*/
	public string function getCfScript(){
		var result = CreateObject("java","java.lang.StringBuilder").Init();
		
		result = result.append('property ');	
		result = addPropertyAttributes(result);
		result = result.append(';');
		
		return result;
	
	}
	private any function addPropertyAttributes(any stringBuilder){
		
		if (len(This.getName())){
			arguments.stringBuilder = arguments.stringBuilder.append('name="#This.getName()#" ');
       	}
       
       	if (len(This.getColumn())){
       		arguments.stringBuilder = arguments.stringBuilder.append('column="#This.getColumn()#" ');
       	}
       
      	if (len(This.getormtype())){
       		arguments.stringBuilder = arguments.stringBuilder.append('ormtype="#This.getormtype()#" ');
       	}
		
		if (len(This.gettype())){
       		arguments.stringBuilder = arguments.stringBuilder.append('type="#This.gettype()#" ');
       	}
       	
       	if (len(This.getFieldtype())){
       		arguments.stringBuilder = arguments.stringBuilder.append('fieldtype="#This.getFieldtype()#" ');
       	}
       		
       	if (len(This.getGenerator())){
       		arguments.stringBuilder = arguments.stringBuilder.append('generator="#This.getGenerator()#" ');
       	}
       
       	if (len(This.getCFC())){
       		arguments.stringBuilder = arguments.stringBuilder.append('cfc="#This.getCFC()#" ');
       	}
       
       	if (len(This.getFkColumn())){
       		arguments.stringBuilder = arguments.stringBuilder.append('fkColumn="#This.getFkColumn()#" ');
       	}
       	
       	if (len(This.getmissingRowIgnored())){
       		arguments.stringBuilder = arguments.stringBuilder.append('missingRowIgnored="#This.getmissingRowIgnored()#" ');
       	}
		
		if (len(This.getLength())){
       		arguments.stringBuilder = arguments.stringBuilder.append('length="#This.getLength()#" ');
       	}
       	
       	if (len(This.getinverse())){
       		arguments.stringBuilder = arguments.stringBuilder.append('inverse="#This.getinverse()#" ');
       	}
       	
       	if (len(This.getcascade())){
       		arguments.stringBuilder = arguments.stringBuilder.append('cascade="#This.getcascade()#" ');
       	}
       	
       	if (len(This.getcollectiontype())){
       		arguments.stringBuilder = arguments.stringBuilder.append('collectiontype="#This.getcollectiontype()#" ');
       	}
       	
       	if (len(This.getSingularName())){
       		arguments.stringBuilder = arguments.stringBuilder.append('SingularName="#This.getSingularName()#" ');
       	}
		
		if (len(This.getlinktable())){
       		arguments.stringBuilder = arguments.stringBuilder.append('linktable="#This.getlinktable()#" ');
       	}
		
		if (len(This.getInverseJoinColumn())){
       		arguments.stringBuilder = arguments.stringBuilder.append('InverseJoinColumn="#This.getInverseJoinColumn()#" ');
       	}
		
		if (len(This.getlazy())){
       		arguments.stringBuilder = arguments.stringBuilder.append('lazy="#This.getlazy()#" ');
       	}
		
		if (len(This.getorderby())){
       		arguments.stringBuilder = arguments.stringBuilder.append('orderby="#This.getorderby()#" ');
       	}
		
		if (len(This.getpersistent())){
       		arguments.stringBuilder = arguments.stringBuilder.append('persistent="#This.getpersistent()#" ');
       	}
		
		if (len(This.getgetter())){
       		arguments.stringBuilder = arguments.stringBuilder.append('getter="#This.getgetter()#" ');
       	}
		
		if (len(This.getsetter())){
       		arguments.stringBuilder = arguments.stringBuilder.append('setter="#This.getsetter()#" ');
       	}
		
		if (len(This.getInsert())){
       		arguments.stringBuilder = arguments.stringBuilder.append('insert="#This.getInsert()#" ');
       	}
		
		if (len(This.getUpdate())){
       		arguments.stringBuilder = arguments.stringBuilder.append('update="#This.getUpdate()#" ');
       	}
			
		return stringBuilder;
	}
	
	
}