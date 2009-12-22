component extends="mxunit.framework.TestCase"{
	

	
	public void function testAllPropertiesDocumented(){
    	var metaData = GetComponentMetaData("apptacular.handlers.cfc.db.datasource");
		var props = metaData.properties;
		var i = 0;
		var missing = [];
		
		for (i = 1; i <= ArrayLen(props); i++){
			if (not StructKeyExists(props[i], "hint")){
				ArrayAppend(missing, props[i].name);
			}
		}
		
		if (ArrayLen(missing) > 0){
			debug(missing);
			fail("Missing Documentation for #arrayLen(missing)# settings. See debug for list.");
			
		}
		
    }

}
  

