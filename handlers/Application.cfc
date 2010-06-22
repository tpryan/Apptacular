component {

	this.name = "apptacularhandlers";
	this.customTagPaths = ExpandPath('customTags/');
	this.mappings["/Apptacular"] = expandPath("../");

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
	
		if (structKeyExists(url, "reset_app")){
			ApplicationStop();
			location(cgi.script_name, false);
		}
		checkForUpdates();
	
		return true;
	}
	
	public boolean function onApplicationStart(){
		application.rds = {};
		application.rds.username = "";
		application.rds.password = "";
		application.rds.rememberMe = false;
		application.version = "1.@buildNumber@";
		application.buildURL = "http://bit.ly/ApptacularBuild";
		application.appURL = "http://bit.ly/Apptacular";
		application.update = new apptacular.handlers.cfc.update(application.version, application.buildURL, application.appURL);
		application.root = getDirectoryFromPath(getCurrentTemplatePath());
		application.updateNeeded = false;
		application.updateInterval = 24;
		return true;
	}
	
	public void function onError(any exception, string eventname){
		include "error.cfm";
		abort;
	}
	
	public void function checkForUpdates(){
		if (not structKeyExists(application,"updateLastChecked") OR 
				DateAdd("h",application.updateInterval, application.updateLastChecked) < now() ){
		
			if (application.update.isOnline()){
				application.updateNeeded = application.update.shouldUpdate();
			}
			else{
				application.updateNeeded = false;
			}		
			
			application.updateLastChecked = Now();
		
		}
	}
	
}