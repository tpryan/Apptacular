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
	property name="hint" type="string" hint="See reference for cfproperty";
	property name="remotingfetch" type="string" hint="See reference for cfproperty";
	
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
		var result = ArrayNew(1);
		
		ArrayAppend(result, '<cfproperty ');	
		ArrayAppend(result, addPropertyAttributes());
		ArrayAppend(result, ' />');	
		
		return ArrayToList(result, "");
	}
	
	/**
		* @hint Returns the content of the property in CFScript
	*/
	public string function getCfScript(){
		var result = ArrayNew(1);
		
		ArrayAppend(result, 'property ');	
		ArrayAppend(result, addPropertyAttributes());
		ArrayAppend(result, ';');	
		
		return ArrayToList(result, "");
	
	}
	
	/**
    * @hint Builds the string of property attributes.
    */
	private string function addPropertyAttributes(){
	
		var lprops = ArrayNew(1);
		
		if (len(This.getName())){
			ArrayAppend(lprops, 'name="#This.getName()#" ');
       	}
       
       	if (len(This.getColumn()) AND compare(This.getColumn(), This.getName()) neq 0 ){
       		ArrayAppend(lprops, 'column="#This.getColumn()#" ');
       	}
       
      	if (len(This.getormtype()) AND compare(This.getType(), This.getORMType()) neq 0 ){
       		ArrayAppend(lprops, 'ormtype="#This.getormtype()#" ');
       	}
		
		if (len(This.gettype())){
       		ArrayAppend(lprops, 'type="#This.gettype()#" ');
       	}
       	
       	if (len(This.getFieldtype())){
       		ArrayAppend(lprops, 'fieldtype="#This.getFieldtype()#" ');
       	}
       		
       	if (len(This.getGenerator())){
       		ArrayAppend(lprops, 'generator="#This.getGenerator()#" ');
       	}
       
       	if (len(This.getCFC())){
       		ArrayAppend(lprops, 'cfc="#This.getCFC()#" ');
       	}
       
       	if (len(This.getFkColumn())){
       		ArrayAppend(lprops, 'fkColumn="#This.getFkColumn()#" ');
       	}
       	
       	if (len(This.getmissingRowIgnored())){
       		ArrayAppend(lprops, 'missingRowIgnored="#This.getmissingRowIgnored()#" ');
       	}
		
		if (len(This.getLength())){
       		ArrayAppend(lprops, 'length="#This.getLength()#" ');
       	}
       	
       	if (len(This.getinverse())){
       		ArrayAppend(lprops, 'inverse="#This.getinverse()#" ');
       	}
       	
       	if (len(This.getcascade())){
       		ArrayAppend(lprops, 'cascade="#This.getcascade()#" ');
       	}
       	
       	if (len(This.getcollectiontype())){
       		ArrayAppend(lprops, 'collectiontype="#This.getcollectiontype()#" ');
       	}
       	
       	if (len(This.getSingularName())){
       		ArrayAppend(lprops, 'SingularName="#This.getSingularName()#" ');
       	}
		
		if (len(This.getlinktable())){
       		ArrayAppend(lprops, 'linktable="#This.getlinktable()#" ');
       	}
		
		if (len(This.getInverseJoinColumn())){
       		ArrayAppend(lprops, 'InverseJoinColumn="#This.getInverseJoinColumn()#" ');
       	}
		
		if (len(This.getlazy())){
       		ArrayAppend(lprops, 'lazy="#This.getlazy()#" ');
       	}
		
		if (len(This.getorderby())){
       		ArrayAppend(lprops, 'orderby="#This.getorderby()#" ');
       	}
		
		if (len(This.getpersistent())){
       		ArrayAppend(lprops, 'persistent="#This.getpersistent()#" ');
       	}
		
		if (len(This.getgetter())){
       		ArrayAppend(lprops, 'getter="#This.getgetter()#" ');
       	}
		
		if (len(This.getsetter())){
       		ArrayAppend(lprops, 'setter="#This.getsetter()#" ');
       	}
		
		if (len(This.getInsert())){
       		ArrayAppend(lprops, 'insert="#This.getInsert()#" ');
       	}
		
		if (len(This.getUpdate())){
       		ArrayAppend(lprops, 'update="#This.getUpdate()#" ');
       	}
		if (len(This.getRemotingFetch())){
       		ArrayAppend(lprops, 'remotingFetch="#This.getRemotingFetch()#" ');
       	}
		
			
		return Trim(ArrayToList(lprops, ""));
	}
	
	
}