component {

	This.name = "apptacularhandlerseditdb";
	This.customTagPaths = ExpandPath('../customTags/');
	this.mappings["/Apptacular"] = expandPath("../../");

	/**
    * @hint Fires when any page of the application is requested.
    */
	public boolean function onRequestStart() {
		return true;
	}
}