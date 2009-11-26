component accessors="true" extends="dbItem"  
{
	property name="name";
	property name="displayName";
	property name="entityName";
	property name="identity";
	property name="plural";
	property name="displayPlural";
	property name="ForeignKeyLabel";
	property name="isReferencedAsForeignKey" type="boolean";
	property name="isJoinTable" type="boolean";
	property name="softDelete" type="boolean";   
	property name="hasJoinTable" type="boolean";   
	property name="hasForeignKeys" type="boolean";   
	property name="isView" type="boolean";
	property name="columns" type="column[]"; 
	property name="columnsStruct" type="struct";
	property name="references" type="reference[]";  
	
	public function init(required string name, required string datasource){
		variables.mappings = New mappings();
		variables.dbinfo = New dbinfo();
		dbinfo.setDatasource(arguments.datasource);
		dbinfo.setTable(arguments.name);
		
		This.setName(arguments.name);
		This.setDisplayName(capitalize(arguments.name));
		This.setEntityName(Lcase(arguments.name));
		This.setPlural(pluralize(This.getEntityName()));
		This.setDisplayPlural(pluralize(capitalize(This.getEntityName())));
		
		populateTable();
		populateForeignKeys();
		populateColumns();
		
		return This;
	}
	
	public array function getArray(){
		return columns;
	}
	
	private void function populateTable(){
		
		This.setHasForeignKeys(FALSE);
		This.setIsJoinTable(FALSE);
		This.setSoftDelete(FALSE);
		This.setHasJoinTable(FALSE);
	
	}
	
	private void function populateForeignKeys(){
		dbinfo.setType("foreignkeys");
		var	foreignkeys = dbinfo.send().getResult();
		
		var i = 0;
		
		dbinfo.setType("index");
		var	indicies = dbinfo.send().getResult();
		
		This.setIsReferencedAsForeignKey(foreignKeys.recordCount > 0 );
		
		if (foreignkeys.recordCount gt 0){
			var refArray = ArrayNew(1);
			for (i = 1; i <= foreignkeys.recordCount; i++){
				var ref = New reference();
				ref.setForeignKeyTable(foreignkeys.fktable_name[i]);
				ref.setForeignKey(foreignkeys.fkcolumn_name[i]);
				arrayAppend(refArray, ref);
			}
			This.setReferences(refArray);
		}
		
		
	
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
				this.setForeignKeyLabel(LCase(columns.column_name[i+1]));
			}
			
			if (column.getIsForeignKey()){
				This.setHasForeignKeys(TRUE);
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
	
	public table function getColumn(required string columnName){
		return This.getColumnsStruct()[arguments.columnName];
	}
	
	
}