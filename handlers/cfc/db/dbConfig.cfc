<cfcomponent>
<cfscript>
	/**
	 * @hint You know, an init. 
	 */
	public function init(required string path){
		
		variables.FS = createObject("java","java.lang.System").getProperty("file.separator");
		
		if (CompareNoCase(right(arguments.path, 1),variables.FS) neq 0){
			variables.path = arguments.path & variables.FS;
		}
		else{
			variables.path = arguments.path;
		}
	}

	/**
	* @hint Writes configurations to disk. 
	*/
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
			
			//Handle Columns
			var columns = tables[i].getColumns();
			for (j=1; j <= arraylen(columns); j++){
				//Write XML to disk
				FileWrite(tableSchemaPath & variables.FS & columns[j].getName() & ".xml", columns[j].serialize());
			}
			
			//Handle Refs
			var refs = tables[i].getReferences();
			
			if (Not isNull(refs)){
				for (j=1; j <= arraylen(refs); j++){
					//Write XML to disk
					FileWrite(tableSchemaPath & variables.FS & "ref_" & refs[j].getforeignKeyTable() & ".xml", refs[j].serialize());
				}
			}
			
		}
		
	
	}
	
	
	/**
	* @hint Rewrites all of the info in a datasource from the config files.
	*/	
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
		
		StructDelete(checksums, DSCSPath);
		
		
		//check tables
		var tableStruct = StructNew();
		var tables = newDataSource.getTables();
		
		for (i=1; i <= arraylen(tables); i++){
			var table = tables[i];
			var tableName = table.getName();
			var tableCSPath = DSCSPath & "/" & tableName;

			//short circuit if the table or config doesn't exist
			if (not structKeyExists(checksums, tableCSPath)){
				tableStruct[tableName] = table;
				continue;
			}
			
			var configCS = checksums[tableCSPath]['checksum'];
			var dbCS = table.getChecksum();
			
			if (CompareNoCase(configCS, dbCS) neq 0 ){
				table = reWriteObject(table, checksums[tableCSPath]['filePath'], "table");
			}
			
			StructDelete(checksums, tableCSPath);
			
			//check columns
			var columnsArray = ArrayNew(1);
			var columnsStruct = StructNew();
			var columns = table.getColumns();
			
			
			
			for (j=1; j <= arraylen(columns); j++){
				var column = columns[j];
				var columnName = column.getName();
				var columnCSPath = DSCSPath & "/" & tableName & "/" & columnName;
				
				
				//short circuit if the table or config doesn't exist
				if (not structKeyExists(checksums, columnCSPath)){
					columnsStruct[columnName] = column;
					continue;
				}
				
				
				if (structKeyExists(checksums, columnCSPath) AND FileExists(checksums[columnCSPath]['filePath'])){
					var configCS = checksums[columnCSPath]['checksum'];
					var dbCS = column.getChecksum();
				
					if (CompareNoCase(configCS, dbCS) neq 0 ){
						var column = reWriteObject(column, checksums[columnCSPath]['filePath'], "column");
					}
				}
				
				StructDelete(checksums, columnCSPath);
				columnsStruct[columnName] = column;
			}
			
			//Handle Refs
			var refs = table.getReferences();
			var refArray = ArrayNew(1);
			
			
			
			if (Not isNull(refs)){
				for (j=1; j <= arraylen(refs); j++){
					var reference = refs[j];
					var refCSPath = DSCSPath & "/" & tableName & "/ref_" & reference.getforeignKeyTable();
					
					
					if (not structKeyExists(checksums, refCSPath)){
						ArrayAppend(refArray, reference);
						continue;
					}
					
					
					
					var configCS = checksums[refCSPath]['checksum'];
					var dbCS = reference.getChecksum();
				
				
					if (CompareNoCase(configCS, dbCS) neq 0 ){
						var reference = reWriteObject(reference, checksums[refCSPath]['filePath'], "reference");
					}
					StructDelete(checksums, refCSPath);
					ArrayAppend(refArray, reference);
				
				}
				
				
			}
			
			
			var AlteredColumns = [];
			
			for (j=1; j <= ArrayLen(columns); j++){
				ArrayAppend(AlteredColumns, columnsStruct[columns[j].getName()]);
			}
			
			table.setColumns(AlteredColumns);
			table.setColumnsStruct(columnsStruct);
			table.setReferences(refArray);
						
			//add edited or unedited tables back to the datsource
			tableStruct[tableName] = table;
			
		
		}
		
		
		
		
		//Process Virtual Columns
		var VCKeys = StructKeyArray(checksums);
		
		//Remove Orphan columns
		for (i = ArrayLen(VCKeys); i > 0; i--){
			var node = ListLast(VCKeys[i], FS);
			if (CompareNoCase(left(node, 3), "vc_") neq 0){
				ArrayDeleteAt(VCKeys, i);
			}
		}
		
		
		for (i=1; i <= ArrayLen(VCKeys); i++){
			var virtualColumn = New virtualColumn();
			virtualColumn = reWriteObject(virtualColumn, checksums[VCKeys[i]]['filePath'], "virtualColumn");
			var tableName = ListLast(GetDirectoryFromPath(checksums[VCKeys[i]]['filePath']), FS);
			var table = tableStruct[tableName];
			table.addVirtualColumn(virtualColumn);
			tableStruct[tableName] = table;
		}
		
		// poppulate array
		var tablesStructKeys = StructKeyArray(tableStruct);
		var tablesArray = ArrayNew(1);
		for (i=1; i <= ArrayLen(tablesStructKeys); i++){
			ArrayAppend(tablesArray, tableStruct[tablesStructKeys[i]]);
		}
		
		newDataSource.setTables(tablesArray);
		newDataSource.setTablesStruct(tableStruct);
		
		return newDataSource;
	}
	
	/**
	 * @hint Rewrites the content of a cfc based on file 
	 */	
	private any function reWriteObject(required any object, required string path, required string ObjectType){
		var newObject = Duplicate(arguments.object);
		var XML = XMLParse(FileRead(arguments.path));
		try{
		var keys = StructKeyArray(XML[arguments.ObjectType]);
		}
		catch(any e){
			writeDump(arguments);
			writeDump(e);
			abort;
		}
		var i = 0;
		
		try{
		for (i=1;i <= arraylen(keys); i++){
			invokeSetter(newObject, keys[i],  XML[arguments.ObjectType][keys[i]]['XMLText']);
		}
		
		}
		catch(any e){
			writeLog("Apptacular Error:  There is a good chance that you have added a variable to 
				the variables scope of one of your database CFC's that doesn't need to be serialized.
				Edit DbItem.cfc and delete project .apptacular folder to fix.");
			writeDump("here there be errors", "console");
			writeDump(newObject, "console");
			writeDump(keys, "console");
			writeDump(i, "console");
			//writeDump(keys[i]);
			//writeDump(newObject);
			writeDump(e);
			abort;
		}
		
		return newObject;
	}
	
	/**
	* @hint Creates a directory if it doesn't exist.
	*/	
	private void function conditionallyCreateDirectory(required string path){
		if(not directoryExists(path)){
			DirectoryCreate(path);
		}
	}
	
	/**
	* @hint Calculates a checksum for a file database xml file. 
	*/
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

</cfscript>

<cffunction name="invokeSetter" output="FALSE" access="public"  returntype="string" hint="Implements cfinvoke in script" >
	<cfargument name="object" type="Any" required="TRUE" hint="The Object to invoke." />
	<cfargument name="property" type="string" required="TRUE" hint="Property to set" />
	<cfargument name="value" type="string" required="TRUE" hint="Value to set" />
	
	<cfinvoke component="#arguments.object#" method="set#arguments.property#" >
		<cfinvokeargument name="#arguments.property#" value="#arguments.value#" />
	</cfinvoke>


</cffunction>

</cfcomponent>
