component accessors="true" extends="dbItem"  
{
	property name="name";
	property name="displayName";
	property name="entityName";
	property name="identity";
	property name="isReferencedAsFK" type="boolean";
	property name="isJoinTable" type="boolean";
	property name="softDelete" type="boolean";   
	property name="hasJoinTable" type="boolean";   
	property name="hasForeignKeys" type="boolean";   
	property name="isView" type="boolean";
	property name="columns" type="column[]"; 
	property name="columnsStruct" type="struct"; 
	
	
	public function init(required string name, required string datasource){
		variables.mappings = New mappings();
		variables.dbinfo = New dbinfo();
		dbinfo.setDatasource(arguments.datasource);
		dbinfo.setTable(arguments.name);
		
		setName(arguments.name);
		setDisplayName(capitalize(arguments.name));
		setEntityName(Lcase(arguments.name));
		
		populateTable();
		
		populateColumns();
	
	
		return This;
	}
	
	public array function getArray(){
		return columns;
	}
	
	private void function populateTable(){
		dbinfo.setType("foreignkeys");
		var	foreignkeys = dbinfo.send().getResult();
		
		This.setHasForeignKeys(foreignKeys.recordCount > 0 );
	
	} 
	
	private void function populateColumns(){
		dbinfo.setType("columns");
		
		var	columns = dbinfo.send().getResult();
		var i = 0;
		var columnArray = arrayNew(1);
		var columnStruct = structNew();
		
		for (i=1; i <= columns.recordCount; i++){
			var column = New column();
			column.setName(LCase(columns.column_name[i]));
			column.setDisplayName(capitalize(columns.column_name[i]));
			column.setColumn(columns.column_name[i]);
			column.setOrmType(mappings.getOrmType(columns.type_name[i]));
			column.setUIType(mappings.getUIType(columns.type_name[i]));
			column.setDataType(columns.type_name[i]);
			column.setisForeignKey(columns.is_ForeignKey[i]);
			column.setisPrimaryKey(columns.is_PrimaryKey[i]);
			column.setForeignKey(columns.referenced_primarykey[i]);
			column.setForeignKeyTable(columns.referenced_primarykey_table[i]);
			column.setLength(columns.column_size[i]);
			
			columnArray[columns.ordinal_position[i]] = column;
			columnStruct[column.getName()] = column;
			
			if (column.getisPrimaryKey()){
				this.setIdentity(column.getName());
			}
			
		}
		This.setColumns(columnArray);
		This.setColumnsStruct(columnStruct);
	}
	
	public string function toXML(){
		return objectToXML("table");
	} 
	
	public boolean function isEntitySameAsTableName(){
		return (CompareNoCase(This.getName(), This.getEntityName()) eq 0);	
	}
	
}