component{

	public function init(){
    	variables.functionList = getFunctionList();	
    	return This;
    }
    

	public boolean function isReservedWord(required string word){
		return isFunctionName(arguments.word);
		
		
	}

	private boolean function isFunctionName(required string word){
		return structKeyExists(variables.functionList, arguments.word);
	}
}
