component {

	This.name = "apptacularhandlerseditconfig";
	This.customTagPaths = ExpandPath('../customTags/');
	this.mappings["/Apptacular"] = expandPath("../../");

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
		return true;
	}
}