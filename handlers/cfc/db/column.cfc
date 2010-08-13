/**
 * @hint Represents a column in a table in a database. 
 */	
component accessors="true" extends="dbItem"  
{
	property name="name" hint="The code name of the property to represent this column.";
	property name="displayName" hint="A pretty name, not at all like 'varchar_author_is_active'";
	property name="column" hint="The real name of the column in the database.";
	property name="length" hint="The length of the column";
	property name="isForeignKey" type="boolean" hint="Is this column a foreign key. ";
	property name="isMemeberOfCompositeForeignKey" type="boolean" hint="Is this column a member of a composite foreign key. ";
	property name="isPrimaryKey" type="boolean" hint="Is this column a primary key, um isn't that a little obvious? ";
	property name="isIdentity" type="boolean" hint="Is this column an actual identity.";
	property name="isComputed" type="boolean" hint="Is this column a computed value. ";
	property name="foreignKey" hint="The primary key of the foreign key table." ;
	property name="foreignKeyTable" hint="The foreign key table." ;
	property name="ormType" hint="The ormtype" ;
	property name="dataType" hint="The type as presented by cfdbinfo" ;
	property name="uiType" hint="The type to generate ui's for." ;
	property name="Type" hint="The ColdFusion datatype" ;
	property name="TestType" hint="The type used for unit testing";
	property name="includeInEntity" type="boolean" hint="Whether or not to include this column in an entity";
	property name="displayLength" type="boolean" hint="Whether or not to put the length of the column into the property for it.";
	
	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("column");
	} 
	
	/**
	 * @hint Checks to see if column property name and the column name is the same to cut back on unnecessary code
	 */	
	public boolean function isColumnSameAsColumnName(){
		return (CompareNoCase(This.getName(), This.getColumn()) eq 0);	
	}

}