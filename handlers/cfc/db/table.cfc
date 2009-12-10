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
	property name="joinedTables" type="array";
	property name="joinTables" type="array";
	property name="createInterface" type="boolean";
	property name="virtualcolumns" type="virtualcolumn[]";
	property name="orderby";      
	
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
		
		This.setVirtualcolumns(ArrayNew(1));
		
		
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
		This.setJoinTables(ArrayNew(1));
		This.setjoinedTables(ArrayNew(1));
		This.setCreateInterface(TRUE);
	
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
		var referencedTables = structNew();
		
		
		
		
		
		for (i=1; i <= columns.recordCount; i++){
			var column = New column();
			column.setName(LCase(columns.column_name[i]));
			column.setDisplayName(capitalize(columns.column_name[i]));
			column.setColumn(columns.column_name[i]);
			column.setType(mappings.getType(columns.type_name[i]));
			column.setOrmType(mappings.getOrmType(columns.type_name[i]));
			column.setUIType(mappings.getUIType(columns.type_name[i]));
			column.setDataType(columns.type_name[i]);
			column.setisForeignKey(columns.is_ForeignKey[i]);
			column.setisPrimaryKey(columns.is_PrimaryKey[i]);
			column.setForeignKey(columns.referenced_primarykey[i]);
			column.setForeignKeyTable(columns.referenced_primarykey_table[i]);
			column.setLength(columns.column_size[i]);
			
			//Count number of referenced tables.
			if (CompareNoCase(columns.referenced_primarykey_table[i], "N/A")){
				referencedTables[columns.referenced_primarykey_table[i]] = "";
			}		
			columnArray[columns.ordinal_position[i]] = column;
			columnStruct[column.getName()] = column;
			
			if (column.getisPrimaryKey()){
				This.setIdentity(column.getName());
				This.setForeignKeyLabel(LCase(columns.column_name[i+1]));
				This.setOrderBy(column.getName() & " asc");
			}
			
			if (column.getIsForeignKey()){
				This.setHasForeignKeys(TRUE);
			}
			
			
		}
		
		var refArray = structKeyArray(referencedTables);
		if (ArrayLen(refArray) eq 2 AND
			(CompareNoCase(This.getName(), "#refArray[1]#to#refArray[2]#") eq 0 OR 
				CompareNoCase(This.getName(), "#refArray[2]#to#refArray[1]#") eq 0)
			)
		
		{
			This.setIsJoinTable(TRUE);
			This.setCreateInterface(FALSE);
			This.setJoinedTables(structKeyArray(referencedTables));
		}
		
		
		This.setColumns(columnArray);
		This.setColumnsStruct(columnStruct);
	}
	
	public boolean function hasPrimaryKey(){
		return (Not isNull(This.getIdentity()));
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
	
	public void function addJoinTable(required string joinTable){
		var joinTables = This.getJoinTables();
		ArrayAppend(joinTables, arguments.joinTable);
		This.setJoinTables(joinTables);
	}
	
	public string function getOtherJoinTable(required string joinTable){
		var i = 0;
		var joinedTables = This.getJoinedTables();
		
		for (i = 1; i <= arraylen(joinedTables); i++){
			if (CompareNoCase(joinedTables[i], arguments.joinTable) neq 0){
				return joinedTables[i];
			}	
		}
	}
	
	public void function addVirtualColumn(required virtualColumn virtualColumn){
		var virtualColumns = This.getVirtualcolumns();
		ArrayAppend(virtualColumns, virtualColumn);
		This.setVirtualcolumns(virtualColumns);
	}
}