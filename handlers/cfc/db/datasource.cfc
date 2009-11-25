component accessors="true" extends="dbItem"  
{
	property name="name";
	property name="displayName";
	property name="engine";
	property name="version";
	property name="tables" type="table[]";
	property name="tablesStruct" type="struct";  
	
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
		var tablesArray = ArrayNew(1);
		var tablesStruct = StructNew();
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
			arrayAppend(tablesArray, table);
			tablesStruct[table.getName()] = table;
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