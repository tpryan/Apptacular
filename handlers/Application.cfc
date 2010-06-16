component {

	this.name = "apptacularhandlers";
	this.customTagPaths = ExpandPath('customTags/');
	this.mappings["/Apptacular"] = expandPath("../");

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
		return true;
	}
	
	public boolean function onApplicationStart(){
		application.rds = {};
		application.rds.username = "";
		application.rds.password = "";
		application.rds.rememberMe = false;
		application.version = "1.@buildNumber@";
		
		return true;
	}
	
	public void function onError(any exception, string eventname){
		include "error.cfm";
		abort;
	}
	
}