<cfcomponent displayname="CFPage" hint="A cfc representation of a cfpage." accessors="true" >
	<cfproperty name="name" hint="The name of the page" />
	<cfproperty name="fileLocation" hint="File path of the page" />
	<cfproperty name="extension" />
	<cfproperty name="format" />
	
	<cfscript>
		public CFPage function init(required string name, required string fileLocation){
		
			This.setExtension('cfm');
			This.setFormat('cfml');
			This.setName(arguments.Name);
			This.setFileLocation(arguments.fileLocation);
			variables.NL = createObject("java", "java.lang.System").getProperty("line.separator");
			variables.body = CreateObject("java","java.lang.StringBuilder").Init();
			variables.bodyScript = CreateObject("java","java.lang.StringBuilder").Init();
			
			return This;
		}
	
		public function appendBody(string bodyContent=""){
			variables.body.append(arguments.bodyContent & variables.NL);
		}
		
		public function appendBodyScript(string bodyContent=""){
			variables.bodyScript.append(arguments.bodyContent & variables.NL);
		}
		
		public string function getCFML(){
			return variables.body;
		}
		
		private string function getFileName(){
			return "#This.getFileLocation()#/#This.getName()#.#This.getExtension()#";
		}
		
		public void function write(){
			conditionallyCreateDirectory(This.getFileLocation());

			if (CompareNoCase(This.getFormat(), "cfscript") eq 0)
				fileWrite(getFileName(), Trim(getCFScript()));
			else{
				fileWrite(getFileName(), Trim(getCFML()));
			}
		}
		
		
	
	</cfscript>
	
	
	
	
	
	<cffunction access="public" name="conditionallyCreateDirectory" output="false" returntype="void" description="Checks to see if a directory exists if it doesn't it creates it." >
		<cfargument name="directory" type="string" required="yes" default="" hint="Driectory to create if it doesn't already exist." />

		<cfif not DirectoryExists(arguments.directory)>
			<cfdirectory directory="#arguments.directory#" action="create" />
		</cfif>

	</cffunction>
	
	
</cfcomponent>