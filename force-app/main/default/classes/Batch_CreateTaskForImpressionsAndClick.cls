/**
*  Description     :   This batch used to create task record under contact and lead object for every 500 impression and every click.
*
*  Created By      :   
*
*  Created Date    :   27/05/2019
*
*  Revision Log    :   V_1.0 - Created 
*                      
**/
global class Batch_CreateTaskForImpressionsAndClick implements database.Batchable<Sobject> {
	
	//Variable to hold object Name.
	String objectName = '';
	Integer MAX_AD_TASK = 100;
	
	/**
	*	@description	:	consturctor of batch
	*						
	*	@args			:	
	*
	*	@return			:	
	*
	*	@revision Log	:	  
	*/
	
	global Batch_CreateTaskForImpressionsAndClick(String objName){
		
		//Assign objectName.
		if(objName.equalsIgnoreCase('Contact') || objName.equalsIgnoreCase('Lead'))
			objectName = objName;
	}
	
	/**
	*	@description	:	This is start mehtod of batch.
	*						
	*	@args			:	
	*
	*	@return			:	
	*
	*	@revision Log	:	  
	*/
	global Database.QueryLocator Start(Database.batchableContext bc){
		//Check objectName
		if(String.isBlank(objectName))
			return null;
		
		//String to hold query.
		String query ='Select Id, Name, adroll__Impressions__c, adroll__Clicks__c From '+ objectName+ ' Where adroll__Impressions__c >= 500 AND adroll__Clicks__c > 0';
		
		//return records.
		return Database.getQueryLocator(query);
	}
	
	/**
	*	@description	:	This is execute mehtod of batch.
	*						
	*	@args			:	
	*
	*	@return			:	
	*
	*	@revision Log	:	  
	*/
    global void execute(Database.BatchableContext BC, List<sObject> recordList){
        try{
            //Null check on list.
            if(recordList == null)
                return;
            
            //List of task to insert.
            List<Task> listOfTaskToInsert = new List<Task>();
            
            //Map of task with parent record id.
            Map<Id, List<String>> mapOfTaskByParentId = new Map<Id, List<String>>();
            
            //Set of parent id.
            Set<Id> setOfParentId = new Set<Id>();
            
            //Loop over record list to fill setOfParentId.
            for(sObject obj : recordList)
                setOfParentId.add((Id)obj.get('Id'));
            
            //check size of setOfParentId
            if(setOfParentId.size() > 0){
                
                //Query task record.
                for(Task taskRecord : [Select Id, Subject, WhoId From Task Where WhoId IN : setOfParentId]){
                    
                    //Fill mapOfTaskByParentId
                    if(!mapOfTaskByParentId.containsKey(taskRecord.WhoId))
                        mapOfTaskByParentId.put(taskRecord.WhoId, new List<String>());
                    
                    mapOfTaskByParentId.get(taskRecord.WhoId).add(taskRecord.Subject);
                }
            }
            
            //Loop over recordList to create task record.
            for(sObject obj : recordList){
                
                Integer noOfImpression = Integer.valueOf(obj.get('adroll__Impressions__c'));
                Integer quotient = Integer.valueOf( noOfImpression/500 );
                //Varibale to hold clicks.
                Integer adrollClick = Integer.valueOf(obj.get('adroll__Clicks__c'));
                
                //check contains key in map.
                if(mapOfTaskByParentId.containsKey((Id)obj.get('Id'))){
                    
                    List<String> listOfTaskName = mapOfTaskByParentId.get((Id)obj.get('Id'));
                    
                    //Loop to create task for impression.
                    for(Integer i=1 ; i <= (quotient <= MAX_AD_TASK ?quotient :MAX_AD_TASK) ; i++){
                        
                        //check task contains or not
                        if(!listOfTaskName.contains('Paid Digital- '+ i*500 +' Ad Impressions')){
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital- '+ i*500 +' Ad Impressions';
                            taskRecord.WhoId = (Id)obj.get('Id');
                            taskRecord.ActivityDate = date.Today();
                            taskRecord.Type = 'Other';
                            taskRecord.Status = 'Completed';
                            taskRecord.Priority = 'Normal';
                            
                            //add task into list.
                            listOfTaskToInsert.add(taskRecord);
                        }
                    }
                    
                    //Loop to create task for per click
                    for(Integer i=1 ; i <= (adrollClick <= MAX_AD_TASK ? adrollClick :MAX_AD_TASK) ; i++){
                        
                        //check task contains or not
                        if(!listOfTaskName.contains('Paid Digital- '+ i +' Ad Click')){
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                            taskRecord.WhoId = (Id)obj.get('Id');
                            taskRecord.ActivityDate = date.Today();
                            taskRecord.Type = 'Other';
                            taskRecord.Status = 'Completed';
                            taskRecord.Priority = 'Normal';
                            
                            //add task into list.
                            listOfTaskToInsert.add(taskRecord);
                        }
                    }
                }
                else{
                    //Loop to create task for impression
                    for(Integer i=1 ; i <= (quotient <= MAX_AD_TASK ?quotient :MAX_AD_TASK) ; i++){
                        
                        Task taskRecord = new Task();
                        taskRecord.subject = 'Paid Digital- '+ i*500 +' Ad Impressions';
                        taskRecord.WhoId = (Id)obj.get('Id');
                        taskRecord.ActivityDate = date.Today();
                        taskRecord.Type = 'Other';
                        taskRecord.Status = 'Completed';
                        taskRecord.Priority = 'Normal';
                        
                        //add task into list.
                        listOfTaskToInsert.add(taskRecord);
                    }
                    
                    //Loop to create task per click
                    for(Integer i=1 ; i <= (adrollClick <= MAX_AD_TASK ? adrollClick :MAX_AD_TASK) ; i++){
                        
                        Task taskRecord = new Task();
                        taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                        taskRecord.WhoId = (Id)obj.get('Id');
                        taskRecord.ActivityDate = date.Today();
                        taskRecord.Type = 'Other';
                        taskRecord.Status = 'Completed';
                        taskRecord.Priority = 'Normal';
                        
                        //add task into list.
                        listOfTaskToInsert.add(taskRecord);
                    }
                }
            }
            
            //check size of listOfTaskToInsert.
            if(listOfTaskToInsert.size() > 0)
                insert listOfTaskToInsert;
            
        }catch(Exception e){
            system.assert(false, e.getMessage() + e.getLineNumber());
        }
    }

	/**
	*	@description	:	This is finish mehtod of batch.
	*						
	*	@args			:	
	*
	*	@return			:	
	*
	*	@revision Log	:	  
	*/
    global void finish(Database.BatchableContext BC){

    }
}