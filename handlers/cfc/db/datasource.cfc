component accessors="true" extends="dbItem"  
{
	property name="name" hint="Name of the ColdFusion Datasource to use.";
	property name="displayName" hint="A pretty name, not at all like 'db_blog1_mysql'";
	property name="engine"  hint="The database engine.";
	property name="version" hint="The database version.";
	property name="tables" type="table[]" hint="An array of all of the tables in the datasource.";
	property name="tablesStruct" type="struct" hint="An structure of all of the tables in the datasource."; 
	
	public function init(required string datasource){
		variables.dbinfo = New dbinfo();
		dbinfo.setDatasource(arguments.datasource);
		
		
		This.setName(arguments.datasource);
		This.setDisplayName(arguments.datasource);
	
		populateTables();
		populateDatasource();
	
		return This;
	}
	
	private void function populateTables(){
		var i = 0;
		var j = 0;
		var tablesArray = ArrayNew(1);
		var tablesStruct = StructNew();
		var tablesStructKey = ArrayNew(1);
		dbinfo.setType("tables");
		var tables = dbinfo.send().getResult();
		
		
		var qoq = new Query(); 
		var queryString = "	SELECT  	*  
                          	FROM  		resultSet
							WHERE table_type != 'SYSTEM TABLE'"; 
		qoq.setAttributes(resultSet = tables);  
		qoq.SetDBType("query"); 
		tables = qoq.execute(sql=queryString).getResult(); 
		
		
		for (i=1; i <= tables.recordCount; i++){
			var table = New table(tables.table_name[i], This.getName());
			
			if (CompareNoCase(tables.table_type[i], "view") eq 0){
				table.setIsView(true);
			}
			else{
				table.setIsView(false);
			}
			tablesStruct[table.getName()] = table;
		}
		
		//check for join tables.
		var tablesStructKeys = StructKeyArray(tablesStruct);
		
		for (i=1; i <= ArrayLen(tablesStructKeys); i++){
			var localTable = tablesStruct[tablesStructKeys[i]];
			var joinedTables = localTable.getJoinedTables();
			
			if (ArrayLen(joinedTables) gt 0 AND localTable.getIsJoinTable()){
				var joinTable = tablesStruct[tablesStructKeys[i]];
				var joinTableName = joinTable.getName();
					
				for (j=1; j <= ArrayLen(joinedTables); j++){
					var tempTable = tablesStruct[joinedTables[j]];
					temptable.setHasJoinTable(TRUE);
					temptable.addJoinTable(joinTableName);
					tablesStruct[joinedTables[j]] = tempTable;
				}
			}
		}
		
		
		// poppulate array
		for (i=1; i <= ArrayLen(tablesStructKeys); i++){
			ArrayAppend(tablesArray, tablesStruct[tablesStructKeys[i]]);
		}
		
		
		This.setTables(tablesArray);
		This.setTablesStruct(tablesStruct);
		
	}
	
	public void function populateDatasource(){
		dbinfo.setType("version");
		var version = dbinfo.send().getResult();
		
		This.setEngine(version.database_productname);
		This.setVersion(version.database_version);
		
	}
	
	public table function getTable(required string tableName){
		return This.getTablesStruct()[arguments.tableName];
	}
	
	public string function toXML(){
		return objectToXML("datasource");
	} 
	
	
}