component 
{
	public function init(required string path){
		
		variables.FS = createObject("java","java.lang.System").getProperty("file.separator");
		
		if (CompareNoCase(right(arguments.path, 1),variables.FS) neq 0){
			variables.path = arguments.path & variables.FS;
		}
		else{
			variables.path = arguments.path;
		}
	}

	public void function writeConfig(required datasource datasource){
		var tables = arguments.datasource.getTables();
		var i = 0;
		var j = 0;
		var datasourcePath = variables.path & variables.FS & datasource.getName();
		
		//Write XML to disk
		
		conditionallyCreateDirectory(datasourcePath);
		FileWrite(datasourcePath & variables.FS & "_datasource.xml", datasource.serialize());
		
		for (i=1; i <= arraylen(tables); i++){
			//Write XML to disk
			var tableSchemaPath = datasourcePath & variables.FS & tables[i].getName();
			conditionallyCreateDirectory(tableSchemaPath);
			FileWrite(tableSchemaPath & variables.FS & "_table.xml", tables[i].serialize());
			
			var columns = tables[i].getColumns();
			for (j=1; j <= arraylen(columns); j++){
				//Write XML to disk
				FileWrite(tableSchemaPath & variables.FS & columns[j].getName() & ".xml", columns[j].serialize());
			}
		}
	
	}
	
	public datasource function overwriteConfig(required datasource datasource){

		if (not directoryExists(variables.path)){
			return arguments.datasource;
		}
		
		var i = 0;
		var j = 0;
		var checksums = getChecksumInfoFromDisk();
		var newDataSource = duplicate(arguments.datasource);
		
		
		//check datasource
		var datasourceName = newDataSource.getName(); 
		var DSCSPath = datasourceName; 
		
		var configCS = checksums[DSCSPath]['checksum'];
		var dbCS = newDataSource.getChecksum();
		
		if (CompareNoCase(configCS, dbCS) neq 0 ){
			newDataSource = reWriteObject(newDataSource, checksums[DSCSPath]['filePath'], "datasource");
		}
		
		//check tables
		var tableArray = ArrayNew(1);
		var tableStruct = StructNew();
		var tables = newDataSource.getTables();
		
		for (i=1; i <= arraylen(tables); i++){
			var table = tables[i];
			var tableName = table.getName();
			var tableCSPath = DSCSPath & "/" & tableName;
			var configCS = checksums[tableCSPath]['checksum'];
			var dbCS = table.getChecksum();
			
			if (CompareNoCase(configCS, dbCS) neq 0 ){
				table = reWriteObject(table, checksums[tableCSPath]['filePath'], "table");
			}
			
			//check columns
			var columnsArray = ArrayNew(1);
			var columnsStruct = StructNew();
			var columns = table.getColumns();
			
			
			
			for (j=1; j <= arraylen(columns); j++){
				var column = columns[j];
				var columnName = column.getName();
				var columnCSPath = DSCSPath & "/" & tableName & "/" & columnName;
				
				if (FileExists(checksums[columnCSPath]['filePath'])){
					var configCS = checksums[columnCSPath]['checksum'];
					var dbCS = column.getChecksum();
				
					if (CompareNoCase(configCS, dbCS) neq 0 ){
						var column = reWriteObject(column, checksums[columnCSPath]['filePath'], "column");
					}
				}
				ArrayAppend(columnsArray, column);
				columnsStruct[columnName] = column;
				
			}
			table.setColumns(columnsArray);
			table.setColumnsStruct(columnsStruct);
						
			//add edited or unedited tables back to the datsource
			ArrayAppend(tableArray, table);
			tableStruct[tableName] = table;
			
		
		}
		newDataSource.setTables(tableArray);
		newDataSource.setTablesStruct(tableStruct);
		
		
		return newDataSource;
	}
	
	private any function reWriteObject(required any object, required string path, required string ObjectType){
		var newObject = Duplicate(arguments.object);
		var XML = XMLParse(FileRead(arguments.path));
		var keys = StructKeyArray(XML[arguments.ObjectType]);
		var i = 0;
		
		for (i=1;i <= arraylen(keys); i++){
			Evaluate("newObject.set#keys[i]#(XML[arguments.ObjectType][keys[i]]['XMLText'])");
		}
		
		return newObject;
	}
	
	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
	private struct function getChecksumInfoFromDisk(){
		var i = 0;
		var dirs = directoryList(variables.path, true, "query");
		var qoq = new Query(); 
		var queryString = "	SELECT  	directory, name 
                          	FROM  		resultSet
							WHERE 		name like '%.xml'"; 
		qoq.setAttributes(resultSet = dirs);  
		qoq.SetDBType("query"); 
		dirs = qoq.execute(sql=queryString).getResult();
		
		var returnStruct = StructNew();
		
		for (i = 1; i <= dirs.recordCount; i++){
			var checksumArrayPath = ReplaceNoCase(dirs.directory[i], variables.path, "", "all");
			
			
			if ( compareNoCase(left(dirs.name[i], 1), "_")){
				checksumArrayPath = checksumArrayPath & variables.FS & getToken(dirs.name[i], 1, ".");
			}
			var XMLConfigPath = dirs.directory[i] & variables.FS & dirs.name[i];
			
			returnStruct[checksumArrayPath] = structNew();
			returnStruct[checksumArrayPath]['checksum'] = Hash(FileRead(XMLConfigPath));
			returnStruct[checksumArrayPath]['filePath'] = XMLConfigPath;
			
		}
		
		return returnStruct;
	}


}