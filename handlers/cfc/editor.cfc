component accessors="true"{

	property name="allowedList" getter="true" setter="false";
	property name="BooleanList" getter="true" setter="false";
	property name="TextAreaList" getter="true" setter="false";

	public function init(required string itemToEdit){
   		variables.allowedList = setAllowedList();
    	variables.BooleanList = setBooleanList();
		variables.TextAreaList =setTextAreaList();
		variables.itemToEdit = arguments.itemToEdit;
		
   		return This;
    }
	
	private struct function setAllowedList(){
		
		var allowed = structNew();
		allowed['datasource'] = "displayName";
		allowed['table'] = "entityName,displayName,displayPlural,ForeignKeyLabel,orderby,plural,createInterface,IsJoinTable";
		allowed['column'] = "name,column,displayName,uiType";
		allowed['config'] = "LockApplication,CreateAppCFC,CreateEntities,CreateViews,CreateServices,CreateLogin,OverwriteDataModel,";
		allowed['config'] = allowed['config'] & "<Path Information>,rootCFCPath,rootFilePath,cssfolder,customTagFolder,entityFolder,serviceFolder,appFolder,";
		allowed['config'] = allowed['config'] & "<Misc>,serviceAccess,CFCFormat,WireOneToManyinViews,LogSQL,<Formats>,dateformat,timeformat,";
		allowed['config'] = allowed['config'] & "<Magic Fields>,createdOnString,updatedOnString,";
		allowed['config'] = allowed['config'] & "<MXUnit Settings>,CreateTests,MXUnitFilePath,testFolder";
		allowed['virtualcolumn'] = "name,displayName,getterCode,type,uiType";
	
		return allowed;
	}
	
	private struct function setBooleanList(){
		
		var booleans = structNew();
		booleans['datasource'] = "";
		booleans['table'] = "createInterface,IsJoinTable";
		booleans['column'] = "";
		booleans['config'] = "LockApplication,CreateAppCFC,CreateEntities,CreateLogin,CreateServices,CreateViews,OverwriteDataModel,CreateTests,WireOneToManyinViews,LogSQL";
		booleans['virtualcolumn'] = "";
	
		return booleans;
	}


	private struct function setTextAreaList(){
		
		var textareas = structNew();
		textareas['datasource'] = "";
		textareas['table'] = "";
		textareas['column'] = "";
		textareas['config'] = "";
		textareas['virtualcolumn'] = "getterCode";
		
		return textareas;
	}
	
	public boolean function isBooleanUI(required string field){
		return ListFindNoCase(booleanList[itemToEdit], arguments.field);
	}
	
	public boolean function isTextAreaUI(required string field){
		return ListFindNoCase(TextAreaList[itemToEdit], arguments.field);
	}
	
	public string function getAllowedList(){
		return allowedList[itemToEdit];
	}


}