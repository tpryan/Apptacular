/*
	Yeah yeah yeah, so it's bad form to interact with the
	cgi scope in a CFC. But we're passing it in, instead of calling it directly
	Go tell your CF kiddies, this is the right way to do it.

*/
component{

	public function init(required struct cgiStruct){
    	variables.cgiStruct = arguments.cgiStruct;
			
    	return This;
    }
    
	public string function getBaseURL(){
		var baseURL = CreateObject("java","java.lang.StringBuilder").Init();
		
		if ( structKeyExists(variables.cgiStruct, "https") AND
				len(variables.cgiStruct.https) > 0 AND
				isBoolean(variables.cgiStruct.https) AND
				variables.cgiStruct.https){
			baseURL.append("https://");
		}
		else{
			baseURL.append("http://");
		}
		
		baseURL.append(variables.cgiStruct.server_name);
		baseURL.append(":");
		baseURL.append(variables.cgiStruct.server_port);

		return baseURL.toString();	
	}


}
