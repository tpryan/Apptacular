component{
	
	public function init(){
    	return This;
    }
    
	
	public string function depluralize(required string str){
		var result = "";
		
		
		
		
		if (CompareNoCase(right(str, 3), "ies") eq 0){
			result = left(str, len(str)-3) & "y";
		}
		else if(CompareNoCase(right(str, 3), "ses") eq 0){
			result = left(str, len(str)-3) & "se";
		}
		else if(CompareNoCase(right(str, 1), "s") eq 0){
			result = left(str, len(str)-1);
		}
		else if(CompareNoCase(right(str, 2), "ii") eq 0){
			result = left(str, len(str)-2) & "ius";
		}
		else{
			result = str;
		}
		
		return result;
	}
	

}
