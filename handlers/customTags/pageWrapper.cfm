<cfprocessingdirective suppresswhitespace="yes">
<cfif thisTag.executionMode is "start">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfoutput><title>Apptactular</title></cfoutput>
<style type="text/css">
	th {
	text-align: left;
	padding-right: 10px;
	}
	td{
		padding-right: 10px;
		//border-bottom: 1px dotted #999;
		vertical-align: top;	
	}
	
		
	body{
		font-family: "Adobe Clean", "Myriad Pro", Calibri, Tahoma, Arial, Helvetica, sans-serif;
		font-size: 80%;
		
		background-color: #2A587A;
		background-image: url(/apptacular/handlers/grad.jpg);
		background-repeat: repeat-x;
		
	}
	h1 {
		font-size: 120%;
		
		
	}
	h2 {
		font-size: 110%;
		
		
	}
	.alert{
		font-weight: bold;
		color: #FF0000;
		border: 1px dotted #FFFF33;
		background-color: #FFFFCC;
		padding: 1px;
		}
	.breadcrumb{
		font-size: 100%;
	}
	#prev, #next
	{ width: 200px;}	
		
	#next{
		text-align: right;
	}
	
	input[type="text"] { width: 250px; height: 14px; font-size: 11px; }
	#columns input[type="text"] { width: 110px; }
	
	a{
		color:#666666;
	}		
	a:hover{
		color: #FFFFFF;
		
	}
	#logo{
		position: fixed;
		bottom: 10px;
		right: 10px;	
		
	}	
	
	
</style>
</head>
<body>
<cfelse>
<img src ="/apptacular/handlers/logo.jpg" width="100" height="100" id="logo">
</body>
</html>
</cfif>
</cfprocessingdirective>