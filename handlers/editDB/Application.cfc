component {

	This.name = "apptacularhandlerseditdb";
	This.customTagPaths = ExpandPath('../customTags/');

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
		return true;
	}
}