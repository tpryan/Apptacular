<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfoutput><title>apptacular_blog</title></cfoutput>
<style type="text/css">
	th {
	text-align: left;
	padding-right: 10px;
	}
	td{
		padding-right: 10px;
		border-bottom: 1px dotted #999;	
	}	
	body{
		font-family: "Adobe Clean", "Myriad Pro", Calibri, Tahoma, Arial, Helvetica, sans-serif;
		font-size: 90%;
	}
	h1 {
		font-size: 120%;
		
		
	}
	h2 {
		font-size: 110%;
		
		
	}
	.alert{
		font-weight: bold;
		color: red;
		border: 1px dotted red;
		background-color: #FFDFDF;
		padding: 1px;
		}
	.breadcrumb{
		font-size: 80%;
	}	
</style>
</head>
<body>
<cfelse>
</body>
</html>
</cfif>
</cfprocessingdirective>