component extends="mxunit.framework.TestCase"{
	
	
	public void function test_config_GetDisplayName_DisplayNameNOTSet(){
		var config = "apptacular.handlers.cfc.generators.cfapp.config";
		var configHelper = new apptacular.handlers.cfc.utils.docHelper(config);
		var actual = configHelper.getDisplayName("Astringthatshouldneverbeaconfigitem");
		var expected  = "Astringthatshouldneverbeaconfigitem";
		AssertEquals(expected, actual);
    }
	
	public void function test_config_GetDisplayName_DisplayNameSet(){
		var config = "apptacular.handlers.cfc.generators.cfapp.config";
		var configHelper = new apptacular.handlers.cfc.utils.docHelper(config);
		var actual = configHelper.getDisplayName("createTests");
		var expected  = "Create Unit Tests";
		AssertEquals(expected, actual);
    }
	
	public void function test_table_GetDisplayName_DisplayNameSet(){
		var table = "apptacular.handlers.cfc.db.table";
		var docHelper = new apptacular.handlers.cfc.utils.docHelper(table);
		var actual = docHelper.getDisplayName("displayname");
		var expected  = "Display Name";
		AssertEquals(expected, actual);
    }

}