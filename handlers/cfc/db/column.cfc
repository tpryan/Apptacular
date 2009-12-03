component accessors="true" extends="dbItem"  
{
	property name="name";
	property name="displayName";
	property name="column";
	property name="length";
	property name="isForeignKey" type="boolean"; 
	property name="isPrimaryKey" type="boolean";
	property name="foreignKey";
	property name="foreignKeyTable";
	property name="ormType";
	property name="dataType";
	property name="uiType";
	property name="Type";
	
	public string function toXML(){
		return objectToXML("column");
	} 
	
	public boolean function isColumnSameAsColumnName(){
		return (CompareNoCase(This.getName(), This.getColumn()) eq 0);	
	}
	
	

}