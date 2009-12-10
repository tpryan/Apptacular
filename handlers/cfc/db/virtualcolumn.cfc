component accessors="true" extends="dbItem"  
{
	property name="name";
	property name="displayName";
	property name="uiType";
	property name="Type";
	property name="getterCode";
	
	public string function toXML(){
		return objectToXML("virtualcolumn");
	} 
	

}