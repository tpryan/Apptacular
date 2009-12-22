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
	property name="referenceCounts" type="struct";
	property name="joinedTables" type="array";
	property name="joinTables" type="array";
	property name="createInterface" type="boolean";
	property name="virtualcolumns" type="virtualcolumn[]";
	property name="foreignTables" type="struct";
	
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
		populateForeignTables(); 
		populateReferenceCounts();
		calculateForeignKeyLabel();
		
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
		This.setVirtualcolumns(ArrayNew(1));
		This.setForeignTables(structNew());
		This.setreferenceCounts(structNew());
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
			
			
			if (CompareNoCase(column.getForeignKeyTable(), "N/A") eq 0){
				column.setForeignKeyTable(JavaCast('null', ''));
			}	
			
				
			
			//Count number of referenced tables.
			if (CompareNoCase(columns.referenced_primarykey_table[i], "N/A")){
				referencedTables[columns.referenced_primarykey_table[i]] = "";
			}		
			columnArray[columns.ordinal_position[i]] = column;
			columnStruct[column.getName()] = column;
			
			if (column.getisPrimaryKey()){
				This.setIdentity(column.getName());
				This.setOrderBy(column.getName() & " asc");
			}
			
			if (column.getIsForeignKey()){
				This.setHasForeignKeys(TRUE);
			}
			
			
		}
		
		//This is the logic that figures out if this is a join table.
		var refArray = structKeyArray(referencedTables);
		if (ArrayLen(refArray) eq 2 AND
			(CompareNoCase(This.getName(), "#refArray[1]#to#refArray[2]#") eq 0 OR 
				CompareNoCase(This.getName(), "#refArray[2]#to#refArray[1]#") eq 0 OR
					CompareNoCase(This.getName(), "#refArray[1]#_#refArray[2]#") eq 0 OR 
						CompareNoCase(This.getName(), "#refArray[2]#_#refArray[1]#") eq 0 OR
							CompareNoCase(This.getName(), "#refArray[1]##refArray[2]#") eq 0 OR 
								CompareNoCase(This.getName(), "#refArray[2]##refArray[1]#") eq 0)
			)
		{
			This.setIsJoinTable(TRUE);
			This.setCreateInterface(FALSE);
			This.setJoinedTables(structKeyArray(referencedTables));
		}
		
		
		This.setColumns(columnArray);
		This.setColumnsStruct(columnStruct);
	}
	
	public void function calculateForeignKeyLabel(){
		var result = "";
		var columns = This.getColumns();
		var i  = 0;
		
		for (i=1; i <= ArrayLen(columns); i++){
			if(columns[i].getisPrimaryKey() and not columns[i+1].getisForeignKey()){
				result = columns[i+1].getName();
				break;
			}
			else{
				result = columns[i].getName();
				break;
			}
		}
		
		This.setForeignKeyLabel(result);
	}
	
	public numeric function getForeignTableCount(required string tablename){
		var ft = This.getForeignTables();
		
		
		if(StructKeyExists(ft, arguments.tablename)){
			return ft[arguments.tablename];
		}
		else{
			return 0;
		}
		
		
		
	}
	
	private void function populateForeignTables(){
		
		var columns = This.getColumns();
		var i = 0;
		
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			if (len(column.getForeignKeyTable())){
				var ft = This.getForeignTables();
			
				if (not structKeyExists(ft, column.getForeignKeyTable())){
					ft[column.getForeignKeyTable()] = 0;
				}
				
				ft[column.getForeignKeyTable()] = ft[column.getForeignKeyTable()] + 1;
				
				
				This.setForeignTables(Duplicate(ft));
			
			
			}
		
		}
	
	}
	
	public numeric function getReferenceCount(required string tablename){
		var refCounts = This.getReferenceCounts();
		
		if(StructKeyExists(refCounts, arguments.tablename)){
			return refCounts[arguments.tablename];
		}
		else{
			return 0;
		}
		
	}
	
	private void function populateReferenceCounts(){
		var refs = This.getReferences();
		var refCounts = This.getReferenceCounts();
		var i = 0;
		
		
		if (isDefined("refs")){
			for (i = 1; i <= ArrayLen(refs); i++){
				var ref = refs[i];
				
				if (not structKeyExists(refCounts, ref.getForeignKeyTable())){
					refCounts[ref.getForeignKeyTable()] = 0;
				}
				
				refCounts[ref.getForeignKeyTable()] = refCounts[ref.getForeignKeyTable()] + 1;
				
			}
		}
		This.setReferenceCounts(Duplicate(refCounts));
	
	
		
	}
	
	public boolean function isProperTable(){
		
		var identity = This.getIdentity();
		
		if (not isDefined("identity")){
			return false;
		}
		
		if (len(This.getIdentity() gt 0)){
			return true;
		}
		else{
			return false;
		}
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