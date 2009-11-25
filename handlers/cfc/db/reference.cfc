component accessors="true" extends="dbItem"  
{
	property name="foreignKeyTable";
	property name="foreignKey";
	
	public string function toXML(){
		return objectToXML("foreignkey");
	} 
}