component {

	This.name = "apptacularhandlerscreateproject";
	This.customTagPaths = ExpandPath('../customTags/');

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
		return true;
	}
}