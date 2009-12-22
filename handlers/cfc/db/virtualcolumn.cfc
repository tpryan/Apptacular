component accessors="true" extends="dbItem"  
{
	property name="name" hint="The code name of the property to represent this column.";
	property name="displayName" hint="A pretty name, not at all like 'varchar_author_is_active'";
	property name="uiType" hint="The type to generate ui's for." ;
	property name="Type" hint="The ColdFusion datatype" ;
	property name="getterCode" hint="The code that goes in the getVirtualColumn method.";
	
	public string function toXML(){
		return objectToXML("virtualcolumn");
	} 
	

}