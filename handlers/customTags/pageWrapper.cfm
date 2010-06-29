<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<cfset utils = new apptacular.handlers.cfc.utils.utils() />
<cfset imageFolder = ReplaceNoCase(getDirectoryFromPath(getCurrentTemplatePath()), "/customtags", "/", "one") />
<cfset logopath = "#imageFolder#/logo.png" />
<cfset logocsspath = utils.findCSSPathFromFilePath(logopath) />
<cfset bgpath = "#imageFolder#/grad.jpg" />
<cfset bgcsspath = utils.findCSSPathFromFilePath(bgpath) />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfoutput><title>Apptactular</title></cfoutput>
<style type="text/css">
	th {
		text-align: left;
		padding-right: 10px;
		font-weight: normal;
	}
	td{
		padding-right: 10px;
		vertical-align: top;	
	}
	
		
	body{
		font-family: "Adobe Clean", "Myriad Pro", Calibri, Tahoma, Arial, Helvetica, sans-serif;
		font-size: 80%;
		background-color: #2A587A;
		background-image: url(<cfoutput>#bgcsspath#</cfoutput>);
		background-repeat: repeat-x;
		background-position-y: -100px;
		
		margin: 0;
		color: #FFFFFF;
		
	}
	
	h1 {
		font-size: 120%;
	}
	
	h1.table {
		font-size: 150%;
		margin-left: 250px;
	}
	
	h2 {
		font-size: 110%;
	}

	.alert{
		font-weight: bold;
		color: #2A587A;
		border: 1px dotted #FFFF33;
		background-color: #FFFFCC;
		padding: 1px;
		}
		
	.error{
		font-weight: bold;
		color: #FF0000;
		border: 1px dotted #FFFF33;
		background-color: #FFFFCC;
		padding: 1px;
		}	

	.breadcrumb{
		font-size: 100%;
	}
	
	.breadcrumb a{
		color: #000000;
		
	}

	#prev, #next
	{ width: 200px;}	
		
	#next{
		text-align: right;
	}
	
	
	input[type="text"], input[type="password"]{ width: 350px; height: 14px; font-size: 11px; }

	textarea{ width: 350px; height: 140px; font-size: 11px; }

	#columns input[type="text"] { width: 110px; }
	
	a{
		color:#D0D0D0;
	}		
	a:hover{
		color: #FFFFFF;
	}

	#logo{
		position: fixed;
		bottom: 10px;
		right: 10px;	
	}	
	
	.helplink{
		font-size: 80%;
	}
	
	#content{
		margin: 0 5px;
	}
	
	#confirm{
		font-size: 50px;
		margin: 20px 20px;
	}
	
	#updatetable{
		font-size: 16px;
		
	}
	
	#updatetable td{
		text-align: right;
		font-weight: bold;
	}
	
	#loading{
		display: none;
	}
	
	#updatenotice{
		margin:0;
		padding: 2px 5px;
		background-color: #FFFFCC;
		color: #000000;
	}
	
	#updatenotice p{
		margin:0;
		padding: 0;
		
	}
	
	#updatenotice p a{color: #2A587A;}
	#updatenotice p a:hover{color:#5D8BAD;}
</style>

<!--[if lt IE 7]>
<style type="text/css">
	#logo{
		margin-top: 10;
		clear:both;
		position:static;
		float:right;
		bottom:10;
		right:10;
	}
</style>
<![endif]-->



<script language="JavaScript">

	function checkAll(field)
	{
		for (i = 0; i < field.length; i++) {
			if (field[i].disabled != true) {
				field[i].checked = true;
			}
		}	
	}
	
	function uncheckAll(field){
		for (i = 0; i < field.length; i++) {
			if (field[i].disabled != true) {
				field[i].checked = false;
			}
		}
	}	
	function toggleLoading(){
		var loading = document.getElementById("loading");
		loading.style.display = 'block';
		return true;
	}
	
	
</script>

</head>
<body>
<cfif structKeyExists(application, "updateNeeded") AND 
		application.updateNeeded AND
		not FindNoCase("/update/", cgi.script_name)>
<div id="updatenotice">
	<p>There is an <a href="../update/confirm.cfm">update</a> available for Apptacular.</p>
</div>
</cfif>
<div id="header"></div>
<div id="content">
<cfelse>
</div> <!--- end content --->
</body>
</html>
</cfif>
</cfprocessingdirective>