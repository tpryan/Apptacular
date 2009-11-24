/***********************************************************************************************************
*
* ADOBE CONFIDENTIAL
* ___________________
*
*  Copyright 2008 Adobe Systems Incorporated
*  All Rights Reserved.
*
*  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
*  terms of the Adobe license agreement accompanying it.  If you have received this file from a 
*  source other than Adobe, then your use, modification, or distribution of it requires the prior 
*  written permission of Adobe.
*************************************************************************************************************/

/**
 * DBInfo Service that returns metadata info about targeted database.
 * @name dbinfo
 * @displayname ColdFusion DBInfo Service 
 * @output false
 * @accessors true
 */
component extends="base"
{
	property string datasource;
	property string username;
	property string password;
	property string dbname;
	property string type;
	property string table;
	property string pattern;
	
	//service tag to invoke
    variables.tagName = "CFDBINFO";
	

    //list of valid cfhttp tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());
	
	
	variables.attributes = "";
	/**
	 * Initialization routine. Returns an instance of this component
	 * @output false
	 */
	public dbinfo function init()
    {
		 
		if(!structisempty(arguments))
        {
        	structappend(variables,arguments,"yes");
    	}
        return this;
    }
	
	/**
     * Invoke the dbinfo tag to provide the DBINFO service in cfscript
     * @output true 
     */
    public result function send()
	{

        //store tag attributes to be passed to the service tag in a local variable
		var tagAttributes = duplicate(getTagAttributes());

		//attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if(!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments,"yes");
        }
    
        //if a result attribute is specified, we ignore it so that we can always return the result struct 
		if(structkeyexists(tagAttributes,"result"))
        {
             structdelete(tagAttributes, "result");
        }

		//invoke the ldap tag to perform the http service
		return super.invokeTag(getTagName(),tagAttributes);
    } 
}