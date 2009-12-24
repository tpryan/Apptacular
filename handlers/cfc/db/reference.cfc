component accessors="true" extends="dbItem"  
{
	property name="foreignKeyTable" hint="The table to be related to.";
	property name="foreignKey" hint="The field that does the referencing.";

	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("foreignkey");
	} 
}