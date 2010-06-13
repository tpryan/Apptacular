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
	property name="prefix" hint="An prefix on this table in the database.";
	
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
	public function init(required string name, required string datasource, string schema="", boolean isView=FALSE, any stringUtil, any log){
		variables.mappings = New mappings();
		variables.dbinfo = New dbinfo();
		variables.datasource = arguments.datasource;
		variables.stringUtil = arguments.stringUtil;
		variables.log = arguments.log;
		varibales.countQry = new Query(datasource=variables.datasource);
		
		
		
		dbinfo.setDatasource(arguments.datasource);
		
		
		
		
		//Turns out that I need this
		dbinfo.setType("version");
		var version = dbinfo.send().getResult();
		variables.Engine = version.database_productname;
		
		dbinfo.setTable(arguments.name);
		
		This.setName(arguments.name);
		This.setEntityName(Lcase(arguments.name));
		This.setAllNamesBasedOnEntityName();
		
		This.setPrefix("");
		This.setSchema(arguments.schema);
		This.setIsView(arguments.isView);
		
		if (len(This.getSchema()) > 0){
			variables.fullyQualifiedTableName = "#This.getSchema()#.#This.getName()#"; 
		}
		else{
			variables.fullyQualifiedTableName = This.getName(); 	
		}
		
		
		
		log.startEventSeriesItem("popTable");
		populateTable();
		log.endEventSeriesItem("popTable");
		
		log.startEventSeriesItem("popFK");
		populateForeignKeys();
		log.endEventSeriesItem("popFK");
		
		log.startEventSeriesItem("popCol");
		populateColumns();
		log.endEventSeriesItem("popCol");
		
		log.startEventSeriesItem("popRefCount");
		populateReferenceCounts();
		log.endEventSeriesItem("popRefCount");
		
		log.startEventSeriesItem("poprc");
		populateRowCount();
		log.endEventSeriesItem("poprc");
		
		log.startEventSeriesItem("calcFKLabel");
		calculateForeignKeyLabel();
		log.endEventSeriesItem("calcFKLabel");
		
		
		return This;
	}
	
	
	
	
	
	
	/**
	 * @hint Add a jointable relationship
	 */	
	public void function addJoinTable(required string joinTable){
		var joinTables = This.getJoinTables();
		
		if (ArrayFind(joinTables,arguments.joinTable) eq 0){
			ArrayAppend(joinTables, arguments.joinTable);
		}
		This.setJoinTables(joinTables);
	}
	
	/**
	 * @hint Adds a virtual column to the table.
	 */	
	public void function addVirtualColumn(required virtualColumn virtualColumn){
		var virtualColumns = This.getVirtualcolumns();
		ArrayAppend(virtualColumns, virtualColumn);
		This.setVirtualcolumns(virtualColumns);
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
	* @hint Searchs through a table to determine if there is a valid id to use for reads and updates. 
	*/
	public any function discoverValidId(string excludelist="", string format=""){
		
		if (This.hasCompositePrimaryKey()){
			return discoverValidIdCompositeKey(arguments.format);
		}
		else{
			return discoverValidIdSingleKey(excludelist);
		}
		
	}
	
	/**
    * @hint Encapsulates all of the logic to create an display name from an entity name
    */
	public string function formatDisplayName(string name){
		var result = capitalize(name);
		result = Replace(result, "_", " ", "all");
		return result;
	}
	
	/**
	 * @hint Returns a column object from table with that name. 
	 */	
	public column function getColumn(required string columnName){
		return This.getColumnsStruct()[arguments.columnName];
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
    * @hint Gets all of the columns that report to be primary keys. Useful when dealing with compostites. 
    */
	public array function getPrimaryKeyColumns(){
		var columns = This.getColumns();
		var returnArray = [];
		var i = 0;
		
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			if (column.getIsPrimaryKey()){
				ArrayAppend(returnArray, column);
			}
		}
		
		return returnArray; 
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
    * @hint Select one actual value from the database to use in testing. 
    */
	public any function getSampleColumnValue(required string column){
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource, maxrows=1);
		
		qry.setSQL("select #arguments.column# as value from #fullyQualifiedTableName#");
		
		var value = qry.execute().getResult().value;
		return value;
	}
	
	
	
	
	
	/**
	 * @hint Populates all of the details of Foreign keys relationships
	 */
	private void function populateForeignKeys(){
		dbinfo.setType("foreignkeys");
		var	foreignkeys = dbinfo.send().getResult();
		var i = 0;
		
		
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
    * @hint Determines if the table has a composite primary key. 
    */
	public boolean function hasCompositePrimaryKey(){
		var columns = This.getColumns();
		var i = 0;
		var primarykeyCount = 0;
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			if (column.getIsPrimaryKey()){
				primarykeyCount++;
			}
			if(primarykeyCount > 1){
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * @hint Whether or not this table has a primary key
	 */	
	public boolean function hasPrimaryKey(){
		return (Not isNull(This.getIdentity()));
	}

	/**
	* @hint Detects issues with the concept of identity.  Some tables have values for identity that aren't actually identities in the database.  This solves this. 
	*/
	public boolean function hasRealIdentity(){
		return getColumn(This.getIdentity()).getIsIdentity();
	}

	/**
	 * @hint Checks to see if entity name and the table name is the same to cut back on unnecessary code
	 */	
	public boolean function isEntitySameAsTableName(){
		return (CompareNoCase(This.getName(), This.getEntityName()) eq 0);	
	}
	
	/**
	 * @hint Determines whether or not this table can be scaffolded.
	 */	
	public boolean function isProperTable(){
		
		var identity = This.getIdentity();
		var columns = This.getColumns();
		var i = 0;
		
		for (i = 1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			if (FindNoCase(".", column.getColumn())){
				return false;
			}
		}
		
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
	 * @hint Populates the column information of the table.
	 */	
	public void function populateColumns(){
		dbinfo.setType("columns");
		
		var	columns = dbinfo.send().getResult();
		var i = 0;
		var j = 0;
		var columnArray = arrayNew(1);
		var columnStruct = structNew();
		var referencedTables = structNew();
		var PrimaryKeyFound = FALSE;
		var ForeignKeyFound = FALSE;
		
		for (i=1; i <= columns.recordCount; i++){
			var column = New column();
			
			//handle attempts at namespaces in column names
			if (FindNoCase(".", columns.column_name[i])){
				column.setName(Replace(columns.column_name[i], ".", "_", "all"));
			}
			else if (FindNoCase(" ", columns.column_name[i])){
				column.setName(Replace(columns.column_name[i], " ", "_", "all"));
			}
			else{
				column.setName(columns.column_name[i]);
			}
			
			//Deal with Fracking microsoft custom variables.
			if (FindNoCase("Microsoft",variables.Engine) AND variables.stringUtil.isUcase(Left(columns.type_name[i], 1)) ){
				var columnType = findBaseTypeofCustom(columns.type_name[i]);
			}
			else{
				var	columnType = columns.type_name[i];
			}
			
			column.setDisplayName(capitalize(columns.column_name[i]));
			column.setColumn(columns.column_name[i]);
			column.setType(mappings.getType(columnType));
			column.setOrmType(mappings.getOrmType(columnType));
			column.setUIType(mappings.getUIType(columnType));
			column.setTestType(mappings.getTestType(columnType));
			column.setDisplayLength(mappings.getDisplayLength(columnType));
			column.setDataType(columns.type_name[i]);
			column.setisForeignKey(columns.is_ForeignKey[i]);
			column.setisPrimaryKey(columns.is_PrimaryKey[i]);
			column.setForeignKey(columns.referenced_primarykey[i]);
			column.setLength(columns.column_size[i]);
			column.setisMemeberOfCompositeForeignKey(false);
			column.setisComputed(false);
			column.setisIdentity(false);
			
			//dont create blank foriegn keys or they will cause issues.
			if (CompareNoCase(column.getForeignKeyTable(), "N/A") neq 0){
				column.setForeignKeyTable(columns.referenced_primarykey_table[i]);
			}
			
			//Clear number of referenced tables.
			if (CompareNoCase(columns.referenced_primarykey_table[i], "N/A") neq 0){
				referencedTables[columns.referenced_primarykey_table[i]] = "";
			}		
			
			
			
			//Figure out unique identifier information. 
			if (column.getisPrimaryKey()){
				This.setIdentity(column.getName());
				This.setOrderBy(column.getName() & " asc");
				PrimaryKeyFound = TRUE;
			}
			else if(FindNoCase("identity", columns.type_name[i])){
				This.setIdentity(column.getName());
				This.setOrderBy(column.getName() & " asc");
				column.setisIdentity(true);
			}
			
			//Note that the table has foreign keys. 
			if (column.getIsForeignKey()){
				This.setHasForeignKeys(TRUE);
				ForeignKeyFound = TRUE;
			}
			
			columnArray[columns.ordinal_position[i]] = column;
			columnStruct[column.getName()] = column;
			
			//Handle foreign columns in the same loop 
			populateColumnForeignTables(column);
			
			
		}
		
		
		var refArray = structKeyArray(referencedTables);
		//handle join tables if necessary
		if (doReferencesDenoteAJoinTable(refArray))
		{
			This.setIsJoinTable(TRUE);
			This.setCreateInterface(FALSE);
			This.setJoinedTables(structKeyArray(referencedTables));
			
		}
		
		
		//Added this because cfdbinfo doesn't like foreign keys 
		//	and composite primary keys in MSSQL
		columnArray=doubleCheckMSSQL(columnArray);
		
		
		This.setColumns(columnArray);
		This.setColumnsStruct(columnStruct);
		
	}
	
	/**
    * @hint Encapsulates all of the logic to set plurals and displays from an entity name
    */
	public string function setAllNamesBasedOnEntityName(){
		This.setPlural(pluralize(This.getEntityName()));
		This.setDisplayPlural(pluralize(formatDisplayName(This.getEntityName())));
		This.setDisplayName(formatDisplayName(This.getEntityName()));
	}
	
	
	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("table");
	} 
	
	
	/**
    * @hint This will find the type that a custom database type is based on. 
    */
	private string function findBaseTypeofCustom(required string dbtype){
		var result = arguments.dbtype;
		
		//Short Circuit the whole dealio 
		if (not FindNoCase("Microsoft",variables.Engine)){
			return arguments.result;
		}
		
		//Get the columndata in the table.
		var custom = New storedProc();
		var procResult = New storedProcResult();
		custom.setProcedure("sp_help");
		custom.addParam(cfsqltype="cf_sql_varchar", type="in",value="#arguments.dbtype#");
		custom.setDataSource(variables.datasource);
		custom.addProcResult(name="custominfo",resultset=1); 
	
		var custominfo = custom.execute().getprocResultSets().custominfo;
		result = custominfo.storage_type[1];
		
		return result;
		
	}
	
	
	/**
	 * @hint Spins through and sees if there are any foriegn keys that cfdbinfo missed.
	 */	
	private array function doubleCheckMSSQL(required array columnArray){
	
		//Short Circuit the whole dealio 
		if (not FindNoCase("Microsoft",variables.Engine)){
			return arguments.columnArray;
		}
		
		if (Len(This.GetIsView()) neq 0  AND This.GetIsView()){
			return arguments.columnArray;
		}
		
		var columns = arguments.columnArray;
		var i = 0;
		var j = 0;
		var indexKeys = "";
		var results = getspHelpProcObject();
		  
	
		
		// get column data
		var columnsdata = results.columnsdata;
		
		// get fkeys
		var fkeys = results.fkeys;
		
		// get  index
		var index = results.index;
		
		if (index.RecordCount gt 0){
			//Just select out the columns
			var qoq = new Query(); 
			var queryString = "	SELECT  	Index_Keys 
	                          	FROM  		resultSet
								WHERE 		INDEX_DESCRIPTION like '%primary key%'"; 
			qoq.setAttributes(resultSet = index);  
			qoq.SetDBType("query"); 
			
			try{
				indexKeys = qoq.execute(sql=queryString).getResult()['Index_keys']; 
				indexKeys = Replace(indexKeys, ", ", ",", "ALL");
			}
			catch(any e){
			
				if (FindNoCase("The select column reference [Index_Keys]", e.detail)){
					indexKeys = "";
				}
			}
		}
		
		
		
		//loop through the columns and alter any columns that need altering
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			
			//handle fkeys. 
			for (j=1; j <= fkeys.recordCount; j++){
				var keyList = Replace(fkeys['CONSTRAINT_KEYS'][j], " ", "", "ALL");
				var position = ListFindNoCase(keyList,column.getColumn());
				var keyCount = ArrayLen(ListToArray(keyList));
				if (FindNoCase("FOREIGN KEY", fkeys['constraint_type'][j]) AND position > 0 ){
					
					var referencedTable = ListFirst(ListLast(fkeys['CONSTRAINT_KEYS'][j+1], "."), " ");
					var foreignKeyList = Replace(ListLast(fkeys['CONSTRAINT_KEYS'][j+1], "("), ")", "", "ALL");
					var foriegnKeyField = Trim(GetToken(foreignKeyList, position, ","));
					
					if (keyCount > 1){
						columns[i].setisMemeberOfCompositeForeignKey(true);
					}
					
					column.setIsForeignKey(true);
					column.setforeignKeyTable(referencedTable);
					column.setforeignKey(foriegnKeyField);
					columns[i] = column;
					continue;
				}
			
			}
			
			//handle index
			if (ListFindNoCase(indexKeys,column.getColumn())){
				column.setIsPrimaryKey(True);
				This.setIdentity(column.getName());
				This.setOrderBy(column.getName() & " asc");
				columns[i] = column;
			}
			
			//handle columns
			for (j=1; j <= columnsdata.recordCount; j++){
				if(CompareNoCase(Trim(columnsdata['column_name'][j]),Trim(column.getColumn())) eq 0 ){
					
					//set binaries
					if (FindNoCase("binary",columnsdata['type'][j])){
						column.setDataType("binary");
						column.setUIType("binary");
					}
					
					//set isComputeds.
					column.setIscomputed(columnsdata['computed'][j]);
					column[i]= column;
					continue;
				}
			}
			
			//Handle foreign columns in the same loop 
			populateColumnForeignTables(column);
			
		}
	
		return columns;
	}
	
	/**
	 * @hint Returns a stored proc object that can do sp_help in MSSQL
	 */
	private any function getspHelpProcObject(){
		var sptables = New apptacular.handlers.cfc.db.storedProc();
		sptables.setProcedure("sp_help");
		sptables.addParam(cfsqltype="cf_sql_varchar", type="in",value="#variables.fullyQualifiedTableName#"); 	
		sptables.setDataSource(variables.datasource);
		sptables.setDebug(true);
		sptables.addProcResult(name="columnsdata",resultset=2); 
		sptables.addProcResult(name="fkeys",resultset=7);
		sptables.addProcResult(name="index",resultset=6);
		var results = sptables.execute().getprocResultSets();
		
		return results;
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
	
	private void function populateColumnForeignTables(any column){
		var locColumn = arguments.column;
		
		if (len(locColumn.getForeignKeyTable())){
			var ft = This.getForeignTables();
		
			if (not structKeyExists(ft, locColumn.getForeignKeyTable())){
				ft[locColumn.getForeignKeyTable()] = 0;
			}
			
			ft[locColumn.getForeignKeyTable()] = ft[locColumn.getForeignKeyTable()] + 1;
			This.setForeignTables(Duplicate(ft));
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
	 * @hint Counts rows for each table 
	 */	
	private void function populateRowCount(){
		
		var SQL = "SELECT count(*) as countOfRows FROM #fullyQualifiedTableName#";	
		varibales.countQry.setSQL(SQL);
		
		var countOfRows = varibales.countQry.execute().getResult().countOfRows;
		
		This.setrowCount(countOfRows);
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
	* @hint Searchs through a table to determine if there is a valid single id to use for reads and updates. 
	*/
	private any function discoverValidIdSingleKey(string excludelist=""){
		
		var SQL = "";
		
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource, maxrows=1);
		
		//Slight tweak because I was running into case sensitivity issues.
		var idColumn = This.getColumn(This.getIdentity());
		
		
		SQL = "select #idColumn.getColumn()# as id from #fullyQualifiedTableName#";
		
		if (Len(excludelist) > 0){
			var QualifiedList = ListQualify(excludelist, "'");
			SQL = SQL & " WHERE #idColumn.getColumn()# not in (#QualifiedList#)";
		}
		
		qry.setSQL(SQL);
		
		var id = qry.execute().getResult().id;
		return id;		
	}
	
	/**
	* @hint Searchs through a table to determine if there is a valid composite id to use for reads and updates. 
	*/
	private any function discoverValidIdCompositeKey(string format=""){
		
		var SQL = "";
		var keyColumns = "";
		var returnStructString = "";
		
		//Crazy, but use a query to get a valid record to implement in this call.
		var qry = new Query(datasource=variables.datasource, maxrows=1);
		
		var columns = getPrimaryKeyColumns();
		
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			keyColumns = ListAppend(keyColumns,column.getColumn());
		}
		
		
		SQL = "select #keyColumns# from #fullyQualifiedTableName#";
		
		qry.setSQL(SQL);
		
		var resultQuery = qry.execute().getResult();
		
		for (i=1; i <= ArrayLen(columns); i++){
			var column = columns[i];
			returnStructString = ListAppend(returnStructString, "#column.getColumn()#='#resultQuery[column.getColumn()][1]#'");
		}
		
		var returnString =  "{" & returnStructString & "}";
		
		if (FindNoCase("url", arguments.format)){
			returnString =ReplaceList(returnString, "{,},'", ",,");
			returnString =Replace(returnString, ",", "&", "ALL");
		}	
		
		return	returnString;
	}
	
	
	
	/**
    * @hint Determines if the name of a reference table makes it likely that it is a join table.
    */
	private string function doReferencesDenoteAJoinTable(required array a){
		
		//This is the logic that figures out if this is a join table.
		if (ArrayLen(a) eq 2){
			var thisTab = This.getName();
			var	tab1 = a[1];
			var	tab2 = a[2];
			var i = 0;
			
			if(len(this.getPrefix()) gt 1 ){
				var prefix = this.getPrefix();
				thisTab = Replace(thisTab, prefix, "", "one");
				tab1 = Replace(tab1, prefix, "", "one");
				tab2 = Replace(tab2, prefix, "", "one");
			}
			
			
			var patterns = [];
			ArrayAppend(patterns, "#tab1#to#tab2#");
			ArrayAppend(patterns, "#tab2#to#tab1#");
			ArrayAppend(patterns, "#tab1#_#tab2#");
			ArrayAppend(patterns, "#tab2#_#tab1#");
			ArrayAppend(patterns, "#tab1##tab2#");
			ArrayAppend(patterns, "#tab2##tab1#");
			ArrayAppend(patterns, "#Left(tab1, 1)#2#Left(tab2, 1)#");
			ArrayAppend(patterns, "#Left(tab2, 1)#2#Left(tab1, 1)#");
		
		
			for (i=1; i <= arraylen(patterns); i++){
				if (CompareNoCase(thisTab, patterns[i]) eq 0){
					return true;
				}
			
			}
		}
			
		return false;
	}
}