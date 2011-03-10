component extends="mxunit.framework.TestCase"{

	public string function setup(){
		var localPath = getDirectoryFromPath(getCurrentTemplatePath());
		variables.builderContent =localPath & '/sample.xml';
		
	}

	public void function testGetTables(){ 
		var simFormPost = FileRead(variables.builderContent);
		var XML = XMLParse(simFormPost);   
    	var builderHelper = new apptacular.handlers.cfc.utils.builderHelper(XML);
    	
    	var serverToUse = builderHelper.getServers()[1];
    	var dsnToUser = "cfartgallery";
    	
    	var tables = builderHelper.getTables(serverToUse,dsnToUser);
    	AssertEquals(ArrayLen(tables), 7);
    	AssertIsStruct(tables[1]);
    	AssertEquals(tables[1]['name'], "ART");
    		    
    }

	public void function testGetTable(){ 
		var simFormPost = FileRead(variables.builderContent);
		var XML = XMLParse(simFormPost);   
    	var builderHelper = new apptacular.handlers.cfc.utils.builderHelper(XML);
    	
    	var serverToUse = builderHelper.getServers()[1];
    	var dsnToUser = "cfartgallery";
    	var tableToUse = "ART";
    	
    	var table = builderHelper.getTable(serverToUse,dsnToUser,"ART");
    	
    	AssertIsStruct(table);
    	AssertIsArray(table['fields']);
    	AssertEquals(ArrayLen(table['fields']), 8);
    	AssertEquals(table['name'], "ART");
    		    
    }
    
    public void function testGetDataSources(){ 
		var simFormPost = FileRead(variables.builderContent);
		var XML = XMLParse(simFormPost);   
    	var builderHelper = new apptacular.handlers.cfc.utils.builderHelper(XML);
    	
    	var serverToUse = builderHelper.getServers()[1];
    	
    	var dsns = builderHelper.getDataSources(serverToUse);
    	
    	
    	AssertIsArray(dsns);
    	AssertIsStruct(dsns[1]);
    	AssertTrue(StructKeyExists(dsns[1], "name"));
    	AssertTrue(StructKeyExists(dsns[1], "server"));
    	
    		    
    }

}