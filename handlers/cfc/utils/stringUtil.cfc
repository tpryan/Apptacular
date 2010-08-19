component{
	
	/**
    * @hint Psuedo constructor
    */
	public function init(){
    	return This;
    }
    
	/**
    * @hint Takes any string and find the singular of the word. 
    */
	public string function depluralize(required string str){
		var result = specialWordProcess(arguments.str);
		
		if (len(result) > 0){
			return result;
		}
		
		
		
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
	
	/**
	* @hint determines if a particular characters if uppercase or not.
	*/
	public string function isUcase(required string character){
		if(asc(character) gte 65 and asc(character) lte 90) return TRUE;
		else return FALSE;
	}
	
	
	
	private string function specialWordProcess(required string wordToTest){
		var result = "";
		var i = 0;
		var sWords = {};
		sWords['status'] = "status";
		sWords['children'] = "child";
		
		var sWordsList = structKeyArray(sWords);
		
		for (i=1; i <= ArrayLen(sWordsList); i++){
			var wordpart = sWordsList[i];
			if( CompareNoCase( right(arguments.wordToTest, len(wordPart)), wordPart) eq 0){
				if (len(arguments.wordToTest) == len(wordPart)){
					result = sWords[wordPart];
				}
				else{
					result = left(arguments.wordToTest, len(arguments.wordToTest) - len(wordPart)) & sWords[wordPart];
				}
				break;
			}		
		}
		
		
		return result;
	
	}

	public string function CapFirst(required string str){
		var newstr = "";
	    var word = "";
	    var separator = " ";
		var i = 0;
    	var wordArray = listToArray(arguments.str, separator);
	
	
		for (i = 1; i <= ArrayLen(wordArray); i++){
			var word = wordArray[i]; 
			
			newstr = UCase(left(word,1));
	        if (len(word) gt 1){
	            newstr = newstr & right(word,len(word)-1);
	        }
			wordArray[i] = newstr;
	        
	    }

    	return ArrayToList(wordArray, separator);
	}

}
