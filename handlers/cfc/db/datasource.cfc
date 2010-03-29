/**
 * @hint Represents a datasource. 
 */
component accessors="true" extends="dbItem"  
{
	property name="name" hint="Name of the ColdFusion Datasource to use.";
	property name="displayName" hint="A pretty name, not at all like 'db_blog1_mysql'";
	property name="engine"  hint="The database engine.";
	property name="version" hint="The database version.";
	property name="prefix" hint="An prefix on all of the tables in the database.";
	property name="tables" type="table[]" hint="An array of all of the tables in the datasource.";
	property name="tablesStruct" type="struct" hint="An structure of all of the tables in the datasource."; 
	
	/**
	 * @hint You know what this does.
	 */	
	public function init(required string datasource){
		variables.dbinfo = New dbinfo();
		dbinfo.setDatasource(arguments.datasource);
		
		variables.excludedTableList = generateExcludedTables();
		
		This.setName(arguments.datasource);
		This.setDisplayName(arguments.datasource);
		This.setPrefix("");
	
		populateDatasource();
		populateTables();
		
	
		return This;
	}

	/**
	 * @hint Populate table information 
	 */		
	public void function populateTables(){
		writeLog("populateTables called");
		var i = 0;
		var j = 0;
		var tablesArray = ArrayNew(1);
		var tablesStruct = StructNew();
		var tablesStructKey = ArrayNew(1);
		dbinfo.setType("tables");
		var tables = getTablesFromDatabase();
		
		excludedTableList = "";
		for (i = 1; i <= tables.recordCount; i++){
			excludedTableList = ListAppend(excludedTableList, "'#tables.table_name[i]#'");
		}
		
		
		for (i=1; i <= tables.recordCount; i++){
			
			if(structKeyExists(tables, "table_owner")){
				var schema = tables.table_owner[i];
			}
			else{
				var schema = "";
			}
			
			if (CompareNoCase(tables.table_type[i], "view") eq 0){
				var isView = true; 
			}
			else{
				var isView = false; 
			}
			
			
			if (FindNoCase("SYSTEM TABLE", tables.table_type[i])){
				continue;
			}
			
			
			var table = New table(tables.table_name[i], This.getName(), schema, isView);
			
			table.setrowcount(calculateRowCount(table));
			
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
	
	/*TODO: Encaspulate this better.*/
	public string function checkForJoinTables(){
		var i = 0;
		var j = 0;
		var tablesArray = This.getTables();
		var tablesStruct = This.getTablesStruct();
	
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
	
	/**
	 * @hint Counts rows for each table 
	 */	
	public numeric function calculateRowCount(required table table){
		
		if (Len(table.getschema()) > 0){
			var SQL = "SELECT count(*) as countOfRows FROM #table.getSchema()#.#table.getName()#";	
		}
		else{
			var SQL = "SELECT count(*) as countOfRows FROM #table.getName()#";
		}
		
		var qry = new Query(datasource=This.getName());
		qry.setSQL(SQL);
		
			var countOfRows = qry.execute().getResult().countOfRows;
		
		return countOfRows;
	}
	
	/**
	 * @hint Calculates the highest row count in the database.
	 */	
	public numeric function calculateHighestRowCount(){
		var tables = This.getTables();
		var rowCountArray = ArrayNew(1);
		var i = 0;
		
		for (i=1; i <= ArrayLen(tables); i++){
			var table = tables[i];
			ArrayAppend(rowCountArray, table.getRowCount());
		}
		
		ArraySort(rowCountArray, "numeric", "desc");		
		
		return rowCountArray[1];
	}
	
	/**
	 * @hint Pumps the CFC with info about the datasource. 
	 */		
	public void function populateDatasource(){
		dbinfo.setType("version");
		var version = dbinfo.send().getResult();
		This.setEngine(version.database_productname);
		This.setVersion(version.database_version);
	}

	/**
	 * @hint Returns a table object from datasource with that name. 
	 */		
	public table function getTable(required string tableName){
		return This.getTablesStruct()[arguments.tableName];
	}
	
	/**
	 * @hint Alters a table object from datasource with that name. 
	 */		
	public void function setTable(required string tableName, required any table){
		var i = 0;
		var tableStruct = This.getTablesStruct();
		tableStruct[arguments.tableName] = arguments.table;
		This.setTablesStruct(tableStruct);
		
		var tableArray = This.getTables();
		
		for (i=1; i <= ArrayLen(tableArray);i++){
			if (CompareNoCase(tableArray[i].getName(),arguments.tableName)){
				tableArray[i] = arguments.table;
				break;
			}
		
		}
		This.setTables(tableArray);
		
	}

	/**
	 * @hint Converts table to XML for serialization
	 */	
	public string function toXML(){
		return objectToXML("datasource");
	}
	
	public query function getTablesFromDatabase(){
		
		if (FindNoCase("Microsoft", This.getEngine())){
			var tables = getTablesFromMSSQL();
		}
		else{
			var tables = getTablesFromGeneric();
		}
	
		return tables;
	
	}
	
	public void function dePrefixTables(){
		var i = 0;
		if (len(This.getPrefix()) > 0){
			var tables = this.getTables();
			var tableStruct = this.getTablesStruct();
			for (i=1; i <= ArrayLen(tables); i++){
				var table = tables[i];
				table.setEntityName(ReplaceNoCase(table.getEntityName(),This.getPrefix(), "", "one" ));	
				table.setAllNamesBasedOnEntityName();	
				table.setPrefix(This.getPrefix());
				table.populateColumns();
				tables[i] = table;
				tableStruct[table.getName()]= table;
			}
			This.setTables(tables);	
			This.setTablesStruct(tableStruct);		
		}
		
		
	
	}
	
	public void function dePluralize(any stringUtil){
		var i = 0;
		if (len(This.getPrefix()) > 0){
			var tables = this.getTables();
			var tableStruct = this.getTablesStruct();
			for (i=1; i <= ArrayLen(tables); i++){
				var table = tables[i];
				table.setEntityName( stringUtil.depluralize(table.getEntityName()) );
				table.setAllNamesBasedOnEntityName();
				table.populateColumns();	
				tables[i] = table;
				tableStruct[table.getName()]= table;
			}
			This.setTables(tables);	
			This.setTablesStruct(tableStruct);		
		}
		
		
	
	}
	
	private query function getTablesFromMSSQL(){
		var sptables = New storedProc();
		var procResult = New storedProcResult();
		sptables.setProcedure("sp_tables");
		sptables.setDataSource(This.getName());
		sptables.setDebug(true);
		sptables.addProcResult(name="tables",resultset=1); 
		
		tables=sptables.execute().getprocResultSets().tables;
		
		
		var qoq = new Query(); 
		var queryString = "	SELECT  	*  
                          	FROM  		resultSet
							WHERE table_type != 'SYSTEM TABLE'
							AND table_name not in(#PreserveSingleQuotes(variables.excludedTableList)#)"; 
		qoq.setAttributes(resultSet = tables);  
		qoq.SetDBType("query"); 
		tables = qoq.execute(sql=queryString).getResult(); 
	
		return tables;
	}
	
	private query function getTablesFromGeneric(){
		dbinfo.setType("tables");
		var tables = dbinfo.send().getResult();
		return tables;
	}
	
	public array function getTablesOrdered(){
		var tableList = StructKeyArray(variables.tablesStruct);
		var i = 0;
		ArraySort(tableList, "textnocase", "asc");
	
		var result = ArrayNew(1);
		
		for (i =1; i <= ArrayLen(tableList); i++){
		 	ArrayAppend(result, variables.tablesStruct[tableList[i]]);
		}
	
		return result;
	}  

	/**
	 * @hint Create a list of tables to not process.  Somehow pulled in via cfdbinfo in MSSQL
	 */		
	private string function generateExcludedTables(){
		var excludedTableList = "'CHECK_CONSTRAINTS','COLUMN_DOMAIN_USAGE','COLUMN_PRIVILEGES',";
		excludedTableList = excludedTableList & "'COLUMNS','CONSTRAINT_COLUMN_USAGE','CONSTRAINT_TABLE_USAGE','DOMAIN_CONSTRAINTS','DOMAINS','KEY_COLUMN_USAGE',";
		excludedTableList = excludedTableList & "'PARAMETERS','REFERENTIAL_CONSTRAINTS','ROUTINE_COLUMNS','ROUTINES','SCHEMATA','TABLE_CONSTRAINTS',";
		excludedTableList = excludedTableList & "'TABLE_PRIVILEGES','TABLES','VIEW_COLUMN_USAGE','VIEW_TABLE_USAGE','VIEWS','all_columns','all_objects',";
		excludedTableList = excludedTableList & "'all_parameters','all_sql_modules','all_views','allocation_units','assemblies','assembly_files',";
		excludedTableList = excludedTableList & "'assembly_modules','assembly_references','assembly_types','asymmetric_keys','backup_devices','certificates',";
		excludedTableList = excludedTableList & "'check_constraints','column_type_usages','column_xml_schema_collection_usages','columns','computed_columns',";
		excludedTableList = excludedTableList & "'configurations','conversation_endpoints','conversation_groups','credentials','crypt_properties','data_spaces',";
		excludedTableList = excludedTableList & "'database_files','database_mirroring','database_mirroring_endpoints','database_permissions',";
		excludedTableList = excludedTableList & "'database_principal_aliases','database_principals','database_recovery_status','database_role_members',";
		excludedTableList = excludedTableList & "'databases','default_constraints','destination_data_spaces','dm_broker_activated_tasks','dm_broker_connections',";
		excludedTableList = excludedTableList & "'dm_broker_forwarded_messages','dm_broker_queue_monitors','dm_clr_appdomains','dm_clr_loaded_assemblies',";
		excludedTableList = excludedTableList & "'dm_clr_properties','dm_clr_tasks','dm_db_file_space_usage','dm_db_index_usage_stats',";
		excludedTableList = excludedTableList & "'dm_db_mirroring_connections','dm_db_missing_index_details','dm_db_missing_index_group_stats',";
		excludedTableList = excludedTableList & "'dm_db_missing_index_groups','dm_db_partition_stats','dm_db_session_space_usage','dm_db_task_space_usage',";
		excludedTableList = excludedTableList & "'dm_exec_background_job_queue','dm_exec_background_job_queue_stats','dm_exec_cached_plans',";
		excludedTableList = excludedTableList & "'dm_exec_connections','dm_exec_query_memory_grants','dm_exec_query_optimizer_info',";
		excludedTableList = excludedTableList & "'dm_exec_query_resource_semaphores','dm_exec_query_stats','dm_exec_query_transformation_stats',";
		excludedTableList = excludedTableList & "'dm_exec_requests','dm_exec_sessions','dm_fts_active_catalogs','dm_fts_index_population',";
		excludedTableList = excludedTableList & "'dm_fts_memory_buffers','dm_fts_memory_pools','dm_fts_population_ranges','dm_io_backup_tapes',";
		excludedTableList = excludedTableList & "'dm_io_cluster_shared_drives','dm_io_pending_io_requests','dm_os_buffer_descriptors','dm_os_child_instances',";
		excludedTableList = excludedTableList & "'dm_os_cluster_nodes','dm_os_hosts','dm_os_latch_stats','dm_os_loaded_modules','dm_os_memory_allocations',";
		excludedTableList = excludedTableList & "'dm_os_memory_cache_clock_hands','dm_os_memory_cache_counters','dm_os_memory_cache_entries',";
		excludedTableList = excludedTableList & "'dm_os_memory_cache_hash_tables','dm_os_memory_clerks','dm_os_memory_objects','dm_os_memory_pools',";
		excludedTableList = excludedTableList & "'dm_os_performance_counters','dm_os_ring_buffers','dm_os_schedulers','dm_os_stacks','dm_os_sublatches',";
		excludedTableList = excludedTableList & "'dm_os_sys_info','dm_os_tasks','dm_os_threads','dm_os_virtual_address_dump','dm_os_wait_stats',";
		excludedTableList = excludedTableList & "'dm_os_waiting_tasks','dm_os_worker_local_storage','dm_os_workers','dm_qn_subscriptions',";
		excludedTableList = excludedTableList & "'dm_repl_articles','dm_repl_schemas','dm_repl_tranhash','dm_repl_traninfo',";
		excludedTableList = excludedTableList & "'dm_tran_active_snapshot_database_transactions','dm_tran_active_transactions',";
		excludedTableList = excludedTableList & "'dm_tran_current_snapshot','dm_tran_current_transaction','dm_tran_database_transactions',";
		excludedTableList = excludedTableList & "'dm_tran_locks','dm_tran_session_transactions','dm_tran_top_version_generators',";
		excludedTableList = excludedTableList & "'dm_tran_transactions_snapshot','dm_tran_version_store','endpoint_webmethods','endpoints',";
		excludedTableList = excludedTableList & "'event_notification_event_types','event_notifications','events','extended_procedures',";
		excludedTableList = excludedTableList & "'extended_properties','filegroups','foreign_key_columns','foreign_keys','fulltext_catalogs',";
		excludedTableList = excludedTableList & "'fulltext_document_types','fulltext_index_catalog_usages','fulltext_index_columns','fulltext_indexes',";
		excludedTableList = excludedTableList & "'fulltext_languages','http_endpoints','identity_columns','index_columns','indexes','internal_tables',";
		excludedTableList = excludedTableList & "'key_constraints','key_encryptions','linked_logins','login_token','master_files','master_key_passwords',";
		excludedTableList = excludedTableList & "'message_type_xml_schema_collection_usages','messages','module_assembly_usages',";
		excludedTableList = excludedTableList & "'numbered_procedure_parameters','numbered_procedures','objects','openkeys','parameter_type_usages',";
		excludedTableList = excludedTableList & "'parameter_xml_schema_collection_usages','parameters','partition_functions','partition_parameters',";
		excludedTableList = excludedTableList & "'partition_range_values','partition_schemes','partitions','plan_guides','procedures','remote_logins',";
		excludedTableList = excludedTableList & "'remote_service_bindings','routes','schemas','securable_classes','server_assembly_modules',";
		excludedTableList = excludedTableList & "'server_event_notifications','server_events','server_permissions','server_principals','server_role_members',";
		excludedTableList = excludedTableList & "'server_sql_modules','server_trigger_events','server_triggers','servers','service_broker_endpoints',";
		excludedTableList = excludedTableList & "'service_contract_message_usages','service_contract_usages','service_contracts','service_message_types',";
		excludedTableList = excludedTableList & "'service_queue_usages','service_queues','services','soap_endpoints','sql_dependencies','sql_logins',";
		excludedTableList = excludedTableList & "'sql_modules','stats','stats_columns','symmetric_keys','synonyms','syscacheobjects','syscharsets',";
		excludedTableList = excludedTableList & "'syscolumns','syscomments','sysconfigures','sysconstraints','syscurconfigs','sysdatabases','sysdepends',";
		excludedTableList = excludedTableList & "'sysdevices','sysfilegroups','sysfiles','sysforeignkeys','sysfulltextcatalogs','sysindexes','sysindexkeys',";
		excludedTableList = excludedTableList & "'syslanguages','syslockinfo','syslogins','sysmembers','sysmessages','sysobjects','sysoledbusers',";
		excludedTableList = excludedTableList & "'sysopentapes','sysperfinfo','syspermissions','sysprocesses','sysprotects','sysreferences',";
		excludedTableList = excludedTableList & "'sysremotelogins','syssegments','sysservers','system_columns','system_components_surface_area_configuration',";
		excludedTableList = excludedTableList & "'system_internals_allocation_units','system_internals_partition_columns','system_internals_partitions',";
		excludedTableList = excludedTableList & "'system_objects','system_parameters','system_sql_modules','system_views','systypes','sysusers','tables',";
		excludedTableList = excludedTableList & "'tcp_endpoints','trace_categories','trace_columns','trace_event_bindings','trace_events',";
		excludedTableList = excludedTableList & "'trace_subclass_values','traces','transmission_queue','trigger_events','triggers',";
		excludedTableList = excludedTableList & "'type_assembly_usages','types','user_token','via_endpoints','views','xml_indexes',";
		excludedTableList = excludedTableList & "'xml_schema_attributes','xml_schema_collections','xml_schema_component_placements',";
		excludedTableList = excludedTableList & "'xml_schema_components','xml_schema_elements','xml_schema_facets','xml_schema_model_groups',";
		excludedTableList = excludedTableList & "'xml_schema_namespaces','xml_schema_types','xml_schema_wildcard_namespaces','xml_schema_wildcards'";
	
		return excludedTableList;
	}
}