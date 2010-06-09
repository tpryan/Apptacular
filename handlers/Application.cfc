component {

	This.name = "apptacularhandlers";
	This.customTagPaths = ExpandPath('customTags/');

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
		
		return true;
	}
}