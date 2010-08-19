component accessors="true" extends="dbItem"  
{
	property name="foreignKeyTable" hint="The table to be related to.";
	property name="foreignKey" hint="The field that does the referencing.";
	property name="includeInEntity" type="boolean" hint="Whether or not to include this refrence in the parent entity";
	property name="isJoinTable" type="boolean" hint="Whether or not this reference denontes a join table, and cane be assume to be a manytomany";
	property name="otherTable" type="string" hint="The other table of a many to many join";
	
	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("reference");
	} 
}