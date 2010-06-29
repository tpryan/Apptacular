component extends="mxunit.framework.TestCase"{


	public void function testisConfigBooleanUIShouldBeFalse(){
		var editor = new apptacular.handlers.cfc.utils.editor("config");
		AssertFalse(editor.isBooleanUI("serviceAccess"));    	
    }
	
	public void function testisConfigBooleanUIShouldBeTrue(){
    	var editor = new apptacular.handlers.cfc.utils.editor("config"); 
		AssertTrue(editor.isBooleanUI("LockApplication"));      
    }
	
	public void function testisvirtualColumnTextAreaUIShouldBeFalse(){
		var editor = new apptacular.handlers.cfc.utils.editor("virtualColumn");
		AssertFalse(editor.isTextAreaUI("name"));    	
    }
	
	public void function testisvirtualColumnTextAreaUIShouldBeTrue(){
    	var editor = new apptacular.handlers.cfc.utils.editor("virtualColumn"); 
		AssertTrue(editor.isTextAreaUI("getterCode"));      
    }


}