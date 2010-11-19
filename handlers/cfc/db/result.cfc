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
 * component returned by the http,ftp,query services
 * @name result  
 * @displayname return object for coldfusion services - http, ftp and query 
 * @output false
 * @accessors true
 */
component 
{
	/**
     * Typically, this would be the value returned by the tag if the name attribute is specified. 
     * For query service (select sql), it represents the resultset returned 
     * For ftp, it represents the query object returned (applicable for action="listdir")
     * For http, it represents the query object returned
	 */
    property name="result" type="any";

	/**
     * Typically, this would be the result struct returned by the tag 
	 */
    property name="prefix" type="struct"; 
}
