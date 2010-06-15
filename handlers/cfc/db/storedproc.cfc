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
 * Stored procedure service to call stored procedures in cfscript
 * @name storedproc  
 * @displayname ColdFusion Storedproc service
 * @accessors true
 */
component extends="base"
{
    property string datasource; 
    property string procedure; 
    property boolean debug; 
    property string cachedafter; 
    property string cachedwithin; 
    property numeric blockfactor; 
    property string password; 
    property string result; 
    property boolean returncode;  
    property string username; 
    
    //used to store cfprocparams child tags
    variables.parameters = [];

    //used to store cfprocresult child tags
    variables.procresults = [];

	//name of the service tag
    variables.tagName = "CFSTOREDPROC";

    //list of valid cfstoredproc service tag attributes. 
    variables.tagAttributes = getSupportedTagAttributes(getTagName());


    /**
     * Initialization routine. Returns an instance of this component
     * @output false 
     */
    public storedproc function init()
    {
		if(!structisempty(arguments))
        {
        	 structappend(variables,arguments,"yes");
    	}
        return this;
    }
    

    /**
     * Add procresult child tags that are stored in the procresults array 
     * @output false
     */
    public void function addProcResult()
    {
		if(!structisempty(arguments))
        {
        	arrayappend(variables.procresults, arguments);
    	}
    }


    /**
     * Removes procresult child tags(if defined) by resetting the procresults array 
     * @output false
     */
    public void function clearProcResults()
    {
		variables.procresults = [];
    }


	/** 
     * Clear tag attributes and child tags like procparams and procresults (if applicable)
     * @output false
     */
    public void function clear()
    {
         //clear service tag attributes and procparam tags
         super.clear(); 
         
         //clear procresult child tags
         clearProcResults();
	}


    /**
	 * Invoke the cfstoredproc tag (and its child tags cfprocparams and cfprocresult) to provide the storedproc service in cfscript
	 *
	 * Usage ::
     * sp = new sp();	//stored proc object
     * r = sp.execute(procedure="proc")  //execute stored procedure and return an instance of com.adobe.coldfusion.storedprocResult with data (like procresultsets|procvars|result) set
     * r.getProcResultSets() //access any resultsets returned by the stored procedure
     * r.getProcOutVariables() //access any OUT|INOUT variables set by the stored procedure
     * r.getResult() //access result struct (a.k.a cfstoredproc scope) avaialble after a stored procedure call)
	 *
     * @returns  An instance of com.adobe.coldfusion.storedprocResult with the appropriate data set (like procresultsets|procvars|result)
     * @output false
	 */
    public storedprocResult function execute()
    {
        //store tag attributes to be passed to the service tag in a local variable
		var tagAttributes = duplicate(getTagAttributes());

		//attributes passed to service tag action like execute() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments,"yes");
        }

        /*
		Bug 73305 :: After a stored procedure is executed, the cfstoredproc prefix contains "executiontime,statuscode" 
		but in the event that the result attribute is specified, the struct returned contains "executiontime,statuscode,cached", so
		we retain the result attribute instead of deleting it (like we do for other ftp/http services) 
        
        Commenting the code block for now:
        //if a result attribute is specified, we ignore it so that we can always return the result struct 
		if(structkeyexists(tagAttributes,"result"))
        {
			 structdelete(tagAttributes,"result");
		}
		*/
        
		//invoke the service tag
		return super.invokeTag(getTagName(),tagAttributes,{params=variables.parameters,procresults=variables.procresults});
    }
}