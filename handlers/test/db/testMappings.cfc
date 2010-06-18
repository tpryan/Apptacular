component extends="mxunit.framework.TestCase"{
	
	public void function setup(){
    	variables.mappings = New apptacular.handlers.cfc.db.mappings();
    		
    }

	
	public void function testVarBinarySettings(){
    	AssertEquals("binary",mappings.getUIType("varbinary"));
		
    }

}
  

