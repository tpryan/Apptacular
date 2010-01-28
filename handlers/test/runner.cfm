<cfparam name="url.output" type="string" default="extjs" />

<cfinvoke component="mxunit.runner.DirectoryTestSuite"   
          method="run" 
		  componentPath="apptacular.handlers.test" 
          directory="#expandPath('.')#"   
          recurse="true"   
          returnvariable="results" />  
		  
<cfoutput> #results.getResultsOutput(url.output)# </cfoutput>