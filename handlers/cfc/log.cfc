component{

	public function init(required string datasource){
    	variables.datasource = arguments.datasource;
		variables.logentries = {};	
		variables.logorder = [];
		writeLog("*******************************************************");
		writeLog("Apptacular Event Logging started");
		writeLog("*******************************************************");	
    	return This;
    }
    
	
	public void function startEvent(required string id, required string label){
		var event = {};
		event.label = arguments.label;
		event.startTime = getTickCount();
		event.totalTime = 0;
		event.logged = false;
		event.open = true;
		event.id = arguments.id;
		variables.logentries[arguments.id] = duplicate(event);
		ArrayAppend(variables.logorder, arguments.id);
	}
	
	public void function endEvent(required string id){
		var event = variables.logentries[arguments.id];
		event.endTime = getTickCount();
		event.open = false;
		event.totalTime = (event.endTime - event.startTime) / 1000;
		variables.logentries[arguments.id] = event;
	}
	
	public void function createEventSeries(required string id, required string label){
		var event = {};
		event.label = arguments.label;
		event.totalTime = 0;
		event.logged = false;
		event.id = arguments.id;
		event.open = true;
		variables.logentries[arguments.id] = duplicate(event);
		ArrayAppend(variables.logorder, arguments.id);
	}
	
	public void function startEventSeriesItem(required string id){
		var event = variables.logentries[arguments.id];
		event.startTime = getTickCount();
		event.open = true;
		variables.logentries[arguments.id] = event;
		
	}
	
	public void function endEventSeriesItem(required string id){
		var event = variables.logentries[arguments.id];
		event.endTime = getTickCount();
		var totalTime = (event.endTime - event.startTime) / 1000;
		event.totalTime = event.totalTime + totalTime;
		event.open = false;
		variables.logentries[arguments.id] = event;
		
	}
	
	public struct function getEvent(required string id){
		var event = variables.logentries[arguments.id];
		return event;
		
	}
	
	
	
	/**
    * @hint Utility used to log the time each step takes.
    */
	public void function logTimes(){
		var i = 0;
		
		var startTime = getTickCount();
		
		for (i = 1; i <= arraylen(variables.logorder); i++){
			var event = variables.logentries[variables.logorder[i]];
			if (not event.logged and not event.open){
				writeLog("Apptacular step: #datasource#: #NumberFormat(event.totalTime, "_.____")# seconds for #event.label#.");
				event.logged = true;
				variables.logentries[event.id] = event;
			}
		}
	
		var endTime = getTickCount();
		var totalTime = (endTime - startTime) / 1000;
		writeLog("Apptacular step: #datasource#: #NumberFormat(totalTime, "_.____")# seconds for writing the logs.");
	} 



}
