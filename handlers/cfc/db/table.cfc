/**
 * @hint Represent a table in the database.
 */
component accessors="true" extends="dbItem"  
{
	property name="name" hint="The real name of the table in the database.";
	property name="displayName" hint="A pretty name, not at all like 'tbl_author_active'";
	property name="entityName" hint="A code friendly name of the object usefull when your table is named 'tbl_author_active'";
	property name="identity" hint="The unique identifier of the table.";
	property name="plural"  hint="The plural of the entityname, used in relationships";
	property name="displayPlural" hint="The pretty name of the plural.";
	property name="ForeignKeyLabel" hint="The column to be used as a reference in related object ui.";
	property name="isReferencedAsForeignKey" type="boolean" hint="Whether or not this table is referenced by another table's foreign key.";
	property name="isJoinTable" type="boolean" hint="Whether or not this table is the join table of a many to many relationship";
	property name="softDelete" type="boolean" hint="Whether or not this table should be deactivated instead of deleted [not yet implemented ]";  
	property name="hasJoinTable" type="boolean" hint="Whether or not this table has a join table in a many to many relationship";  
	property name="hasForeignKeys" type="boolean" hint="Whether or not this table has foreign keys";  
	property name="isView" type="boolean" hint="It's not a table, it's a view!";
	property name="orderby" hint="The column to order all refernece to these objects."; 
	property name="createInterface" type="boolean" hint="Whether or not this table should have interfaces built for it. ";  
	property name="schema" hint="The schema that contains the table."; 
	
	property name="columns" type="column[]" hint="An array of all of the columns in the table.";
	property name="columnsStruct" type="struct" hint="An struct of all of the columns in the table.";
	property name="rowcount" type="numeric" hint="The number of records in the table.";
	
	property name="joinedTables" type="array" hint="An array of all of the joined tables that referenced this table if isJoinTable is true";
	property name="joinTables" type="array" hint="An array of all of the join tables that referenced this table if hasJoinTable is true";
	
	property name="references" type="reference[]" hint="An array of references to other tables if isReferencedAsForeignKey is true.";
	property name="referenceCounts" type="struct" hint="A structure of the number of times each referenced table is referenced.";
	property name="virtualcolumns" type="virtualcolumn[]" hint="An array of virtual columns.";
	property name="foreignTables" type="struct"  hint="An structure of all of the foreign tables to this table if has ForeignKeys is true.";
	
	
	/**
	 * @hint You know, an init. 
	 */
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
	
	
	/**
	 * @hint Fills all of the content in the table with defaults.
	 */
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
	
	/**
	 * @hint Populates all of the details of Foreign keys relationships
	 */
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

	/**
	 * @hint Populates the column information of the table.
	 */	
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
			try{
			column.setType(mappings.getType(columns.type_name[i]));
			}
			catch(any e){
				writeDump(this);
				writeDump(e);
				abort;
			}
			
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
			else if(FindNoCase("identity", columns.type_name[i])){
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

	/**
	 * @hint Tries to determine what field should be the foreign key label.
	 */	
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

	/**
	 * @hint Returns the number of times that a reference a foreign count
	 */	
	public numeric function getForeignTableCount(required string tablename){
		var ft = This.getForeignTables();
		
		if(StructKeyExists(ft, arguments.tablename)){
			return ft[arguments.tablename];
		}
		else{
			return 0;
		}
		
	}

	/**
	 * @hint Populates all of the details of Foreign keys relationships
	 */	
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
	
	/**
	 * @hint Returns the number of times that a table is referenced as a foreign key
	 */	
	public numeric function getReferenceCount(required string tablename){
		var refCounts = This.getReferenceCounts();
		
		if(StructKeyExists(refCounts, arguments.tablename)){
			return refCounts[arguments.tablename];
		}
		else{
			return 0;
		}
		
	}
	
	/**
	 * @hint Populates all of the details of tables that reference this table as a foriegn key
	 */	
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
	
	/**
	 * @hint Determines whether or not this table can be scaffolded.
	 */	
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
	
	/**
	 * @hint Whether or not this table has a primary key
	 */	
	public boolean function hasPrimaryKey(){
		return (Not isNull(This.getIdentity()));
	}
	
	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("table");
	} 
	
	/**
	 * @hint Checks to see if entity name and the table name is the same to cut back on unnecessary code
	 */	
	public boolean function isEntitySameAsTableName(){
		return (CompareNoCase(This.getName(), This.getEntityName()) eq 0);	
	}
	
	/**
	 * @hint Returns a column object from table with that name. 
	 */	
	public column function getColumn(required string columnName){
		return This.getColumnsStruct()[arguments.columnName];
	}
	
	/**
	 * @hint Add a jointable relationship
	 */	
	public void function addJoinTable(required string joinTable){
		var joinTables = This.getJoinTables();
		ArrayAppend(joinTables, arguments.joinTable);
		This.setJoinTables(joinTables);
	}
	
	/**
	 * @hint Gets the other table in a many to many join. 
	 */	
	public string function getOtherJoinTable(required string joinTable){
		var i = 0;
		var joinedTables = This.getJoinedTables();
		
		for (i = 1; i <= arraylen(joinedTables); i++){
			if (CompareNoCase(joinedTables[i], arguments.joinTable) neq 0){
				return joinedTables[i];
			}	
		}
	}
	
	/**
	 * @hint Adds a virtual column to the table.
	 */	
	public void function addVirtualColumn(required virtualColumn virtualColumn){
		var virtualColumns = This.getVirtualcolumns();
		ArrayAppend(virtualColumns, virtualColumn);
		This.setVirtualcolumns(virtualColumns);
	}
}