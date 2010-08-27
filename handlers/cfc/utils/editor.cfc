component accessors="true"{

	property name="allowedList" getter="true" setter="false";
	property name="BooleanList" getter="true" setter="false";
	property name="TextAreaList" getter="true" setter="false";

	/**
	* @hint The init that fires up all of this stuff. 
	*/
	public function init(required string itemToEdit){
   		variables.allowedList = setAllowedList();
    	variables.BooleanList = setBooleanList();
		variables.TextAreaList =setTextAreaList();
		variables.itemToEdit = arguments.itemToEdit;
		
   		return This;
    }
	
	/**
	* @hint Defines the list of configuration options that you can edit in builder ui
	*/
	private struct function setAllowedList(){
		
		var allowed = structNew();
		allowed['datasource'] = "displayName,prefix";
		allowed['table'] = "entityName,displayName,displayPlural,ForeignKeyLabel,orderby,plural,createInterface,IsJoinTable";
		allowed['column'] = "name,column,displayName,uiType,includeInEntity";
		allowed['config'] = "<Application Basics>,LockApplication,CreateAppCFC,CreateEntities,CreateViews,CreateServices,CreateLogin,OverwriteDataModel,";
		allowed['config'] = allowed['config'] & "<Path Information>,rootCFCPath,rootFilePath,cssfolder,customTagFolder,entityFolder,serviceFolder,appFolder,";
		allowed['config'] = allowed['config'] & "<Service Methods>,serviceGetMethod,serviceUpdateMethod,serviceDeleteMethod,serviceListMethod,serviceListPagedMethod,serviceSearchMethod,serviceSearchPagedMethod,serviceInitMethod,serviceCountMethod,";
		allowed['config'] = allowed['config'] & "<Misc>,serviceAccess,ReturnQueriesFromService,CFCFormat,WireOneToManyinViews,LogSQL,depluralize,MakeSuperSerivces,MakeSuperEntities,<Formats>,dateformat,timeformat,cssfilename,";
		
		allowed['config'] = allowed['config'] & "<Magic Fields>,createdOnString,updatedOnString,";
		allowed['config'] = allowed['config'] & "<MXUnit Settings>,CreateTests,MXUnitFilePath,testFolder";
		allowed['virtualcolumn'] = "name,displayName,getterCode,type,uiType";
	
		return allowed;
	}
	
	/**
	* @hint Defines the list of configuration options that present a boolean option in Builder ui.
	*/
	private struct function setBooleanList(){
		
		var booleans = structNew();
		booleans['datasource'] = "";
		booleans['table'] = "createInterface,IsJoinTable";
		booleans['column'] = "includeInEntity";
		booleans['config'] = "LockApplication,CreateAppCFC,CreateEntities,CreateLogin,CreateServices,CreateViews,OverwriteDataModel,MakeSuperSerivces,MakeSuperEntities,CreateTests,WireOneToManyinViews,LogSQL,depluralize,ReturnQueriesFromService";
		booleans['virtualcolumn'] = "";
	
		return booleans;
	}

	/**
	* @hint Defines the list of configuration options that present a richtextarea in Builder ui.
	*/
	private struct function setTextAreaList(){
		
		var textareas = structNew();
		textareas['datasource'] = "";
		textareas['table'] = "";
		textareas['column'] = "";
		textareas['config'] = "";
		textareas['virtualcolumn'] = "getterCode";
		
		return textareas;
	}
	
	/**
	* @hint Test if configuration option presents a boolean option in Builder ui.
	*/
	public boolean function isBooleanUI(required string field){
		return ListFindNoCase(booleanList[itemToEdit], arguments.field);
	}
	
	/**
	* @hint Test if configuration option presents a richtextarea in Builder ui.
	*/
	public boolean function isTextAreaUI(required string field){
		return ListFindNoCase(TextAreaList[itemToEdit], arguments.field);
	}
	
	/**
	* @hint Gets the list of all configs that can be edited in Builder UI. 
	*/
	public string function getAllowedList(){
		return allowedList[itemToEdit];
	}


}