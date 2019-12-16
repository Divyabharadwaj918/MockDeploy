/**
* Description     -     This class is helper class for trigger on Krow Project object.
* 
* Created by      -   
* 
* Created Date    -     1/29/2019
*
* Revision log    -     Created
*				  -		Updated By Divya - 20-09-2019, created a new method to update the Parent Buyer Account/Parent seller Account on KrowProject
*                   
*/
public without sharing class KrowProjectTriggerHelper {
        /**
    *  @description    :   This method is used to create Krow project template and added Krow Project task to newly created Krow Project
    *
    *  @args           :   List, Map
    *
    *  @return         :   void
    * 
    **/
    public static void createKrowProjectTemplate(List<Krow__Project__c> projects, Map<Id, Krow__Project__c> oldMapOfProject) {
        
        //Set to hold Krow Project Id
        Map<Id,Krow__Project__c> mapOfkrowProjects = new Map<Id,Krow__Project__c>();
        
        //Map to hold Krow Project with List of Task
        Map<Id,List<Krow__Task__c>> mapOfKrowProjectIdWithKrowTasks = new Map<Id,List<Krow__Task__c>>();
        
        //Map to hold Krow Project with Project Template
        Map<Id,Krow_Project_Template__c> mapofKrowProjectIdWithKrowProjectTemplateId = new Map<Id,Krow_Project_Template__c>();
        
        //Set to hold Krow Project name
        set<String> setOfKrowProjectName = new set<String>();
        
        //set to hold Krow Task id
        set<Id> setOfKrowTaskIds = new set<Id>();
        //Map is used to hold krowTask with project+templatedTaskId as key
        Map<String, Krow_Project_Template_Task__c> mapOftemplaeTaskByProjectIdAndTemplateTaskId = new Map<String, Krow_Project_Template_Task__c>();
        //Loop over Krow Project
        for(Krow__Project__c krowProject : projects) {
            
            //insert or update condition
            if(oldMapOfProject == null || (oldMapOfProject != null && krowProject.Krow__Project_Template__c != oldMapOfProject.get(krowProject.Id).Krow__Project_Template__c)) {
                
                if(krowProject.Krow__Project_Template__c == true) {
                    //Process if condition is true
                    if(!mapOfkrowProjects.containsKey(krowProject.Id))
                        mapOfkrowProjects.put(krowProject.Id,krowProject);
                }
                if(krowProject.Krow__Project_Template__c == false && krowProject.Name != null) {
                    setOfKrowProjectName.add(krowProject.Name);
                }                
            }
        }
        
        //Process if size is greater than zero
        if(mapOfkrowProjects.size()>0){
            
            //Loop over Krow Task
            for(Krow__Task__c krowTask : [Select Id, Name, Krow__Project__c, Krow__Description__c, Krow__Milestone__c, Krow__Project_Task_Order__c, Project_Task_Order__c From Krow__Task__c where Krow__Project__c != null AND Krow__Project__c IN: mapOfkrowProjects.keySet()]) {
                
                //Fill the map
                if(!mapOfKrowProjectIdWithKrowTasks.containsKey(krowTask.Krow__Project__c))
                    mapOfKrowProjectIdWithKrowTasks.put(krowTask.Krow__Project__c, new List<Krow__Task__c>());
                mapOfKrowProjectIdWithKrowTasks.get(krowTask.Krow__Project__c).add(krowTask);
            }
            
            //Loop over key set
            for(Id krowProjectId :mapOfkrowProjects.keySet()) {
                
                //Create Project Template
                Krow_Project_Template__c kp = new Krow_Project_Template__c();
                kp.Name = mapOfkrowProjects.get(krowProjectId).name;
                mapofKrowProjectIdWithKrowProjectTemplateId.put(krowProjectId,kp);
            }
            
            //Check for size
            if(mapofKrowProjectIdWithKrowProjectTemplateId.size()>0)
                insert mapofKrowProjectIdWithKrowProjectTemplateId.values();
            
            //List to hold Krow Task
            List<Krow_Project_Template_Task__c> krowProjectTemplateTaskTobeInserted = new List<Krow_Project_Template_Task__c>();
            
            //Process if size is greater than zero
            if(mapofKrowProjectIdWithKrowProjectTemplateId.size()>0 && mapOfKrowProjectIdWithKrowTasks.size()>0) {
                
                //Loop over mapOfKrowProjectIdWithKrowTasks
                for( Id KpId: mapOfKrowProjectIdWithKrowTasks.keySet()) {
                    
                    //Loop over task
                    for(Krow__Task__c kTask : mapOfKrowProjectIdWithKrowTasks.get(KpId)) {
                        setOfKrowTaskIds.add(kTask.Id);
                    }
                }
                
                //Check for set size
                if(setOfKrowTaskIds.size()>0) {
                    
                    Map<String, Krow_Project_Template_Task__c> mapOfUniqueIdWithKrowTemplateTask = new Map<String, Krow_Project_Template_Task__c>();
                    
                    set<Id> setKrowTaskIsGoingToInsert = new set<Id>();
                    
                    //Map to hold the mapping with the Task with key
                    Map<Id, String> mappingOfTemplateTaskToBeUpdateded = new Map<Id, String>();
                    Map<Id, Id> mapOfkrowTaskWithParentkrowTaskId = new Map<Id, Id>();
                    Map<String, String> mapToHoldMappingOfParentTask = new Map<String, String>();
                    
                    for(Krow__Task__c krowTask : [Select Id, Name, Krow__Milestone__c, Krow__Description__c, Krow__Project__c, Krow__Parent_Task__c, Krow__Project_Task_Order__c,
                                                  Project_Task_Order__c, Krow__Parent_Task__r.Name
                                                  From Krow__Task__c where ID IN: setOfKrowTaskIDs]) {
                                                      
                                                      
                                                      //Fill the map
                                                      if(!mapOfKrowProjectIdWithKrowTasks.containsKey(krowTask.Krow__Project__c))
                                                          mapOfKrowProjectIdWithKrowTasks.put(krowTask.Krow__Project__c, new List<Krow__Task__c>());
                                                      mapOfKrowProjectIdWithKrowTasks.get(krowTask.Krow__Project__c).add(krowTask);
                                                      if(String.isNotBlank(krowTask.Krow__Parent_Task__c))
                                                          mapOfkrowTaskWithParentkrowTaskId.put(krowTask.Id, krowTask.Krow__Parent_Task__c);
                                                  }  
                    
                    //loop through each onboarding to accounts and tasks
                    for(Id ProjectId : mapofKrowProjectIdWithKrowProjectTemplateId.keySet()) {
                        
                        if(mapOfKrowProjectIdWithKrowTasks.containsKey(ProjectId)) {
                            
                            //loop over the task under template.
                            for(Krow__Task__c krowTask : mapOfKrowProjectIdWithKrowTasks.get(ProjectId)){
                                
                                
                                Krow_Project_Template_Task__c templateTask = new Krow_Project_Template_Task__c();
                                templateTask.Name=  krowTask.Name;
                                templateTask.Krow_Milestone__c = krowTask.Krow__Milestone__c;
                                templateTask.Krow_Project_Template_Task_Order__c =krowTask.Project_Task_Order__c;//krowTask.Krow__Project_Task_Order__c;
                                templateTask.Krow_Description__c = krowTask.Krow__Description__c;
                                templateTask.Krow_Project_Template__c = mapofKrowProjectIdWithKrowProjectTemplateId.get(ProjectId).Id;
                                
                                mapOftemplaeTaskByProjectIdAndTemplateTaskId.put(mapofKrowProjectIdWithKrowProjectTemplateId.get(ProjectId).Id+'__'+krowTask.Id, templateTask);
                                
                                
                            }
                        }
                        
                    }
                    //Check for Size
                    if(mapOftemplaeTaskByProjectIdAndTemplateTaskId.size() > 0 ) {
                        
                        //Innsert values
                        insert mapOftemplaeTaskByProjectIdAndTemplateTaskId.values();
                        
                            Map<Id, Krow_Project_Template_Task__c> templateTasksToUpdate = new Map<Id, Krow_Project_Template_Task__c>();
                            //Loop over Map key set
                            for(String key : mapOftemplaeTaskByProjectIdAndTemplateTaskId.keyset()){
                                String templateId = key.subStringBefore('__');
                                String TaskId = key.subStringAfter('__');
                                if(mapOfkrowTaskWithParentkrowTaskId.containsKey(TaskId)){
                                    
                                    Krow_Project_Template_Task__c tempalateTaskRecord = mapOftemplaeTaskByProjectIdAndTemplateTaskId.get(key); 
                                    
                                    Id parentTaskId = mapOfkrowTaskWithParentkrowTaskId.get(TaskId);
                                    
                                    Id parenttemplateTaskId = mapOftemplaeTaskByProjectIdAndTemplateTaskId.get(templateId+'__'+parentTaskId).Id;
                                    tempalateTaskRecord.Krow_Project_Parent_Template_Task__c = parenttemplateTaskId;
                                    templateTasksToUpdate.put(tempalateTaskRecord.Id, tempalateTaskRecord);
                                }
                            }
                            
                            //size check of templateTasksToUpdate.
                            if(templateTasksToUpdate.size() > 0)
                                update templateTasksToUpdate.values();
                    }
                    
                    //Check for this
                    if(setOfKrowProjectName.size() >0) {
                        
                        List<Krow_Project_Template__c> templetedTobeDeteled = [Select Id From Krow_Project_Template__c where Name IN:setOfKrowProjectName];
                        
                        //Check for the size
                        if(templetedTobeDeteled.size()>0)
                            delete templetedTobeDeteled;
                    }
                }
            }
        }
    }
    
    /**
*  @description    :   This method is used to insert Krow Project Template task
*
*  @args           :   List, Map
*
*  @return         :   void
* 
**/
    public static void createNewKrowTask(List<Krow__Project__c> projects, Map<Id, Krow__Project__c> oldMapOfProject) {
        //Map of Template id With Krow projects
        Map<Id, List<Krow__Project__c>> mapOfTemplateWithKrowProjects = new Map<Id, List<Krow__Project__c>>();
        
        //Map of Template id With Krow tasks
        Map<Id, List<Krow_Project_Template_Task__c>> mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks = new Map<Id, List<Krow_Project_Template_Task__c>>();
        
        //Set to hold Krow Project Is
        Set<Id> setofKrowProjectIds = new Set<Id>();
        Set<Id> setofKrowProjectTemplateIds = new Set<Id>();
        
        //added - 13/05/19 - Start
        //Map to hold completed task name with project id.
        Map<Id, Set<String>> completedTaskNameWithProjectId = new Map<Id, Set<String>>();
        
        //set used when project not have template id but have completed task. 
        Set<Id> setOfProjectId = new Set<Id>();
        
        //Map is used to hold krowTask with project+templatedTaskId as key
        Map<String, Krow__Task__c> mapOfkrowTaskByProjectIdAndTemplateTaskId = new Map<String, Krow__Task__c>();
        
        //Map to hold template task id with its parent task id.
        Map<Id, Krow_Project_Template_Task__c> mapOfTemplateTaskWithParentTemplateTaskId = new Map<Id, Krow_Project_Template_Task__c>();
        //added - 13/05/19 - End
        
        //SOT-165
        Set<Id> krowTaskIdsNotToDelete = new Set<Id>();
        
        //Query on Record type
        Id recordTypeId = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Seller_Project' Limit 1].Id;
        
        for(Krow__Project__c krowProject : projects) {
            //insert or update condition
            if((oldMapOfProject == null || (oldMapOfProject != null && krowProject.Krow_Project_Template__c != oldMapOfProject.get(krowProject.Id).Krow_Project_Template__c)) && krowProject.RecordTypeId == recordTypeId) {
                
                if(krowProject.Krow_Project_Template__c != null) {
                    
                    //Filling map
                    if(!mapOfTemplateWithKrowProjects.containsKey(krowProject.Krow_Project_Template__c)) 
                        mapOfTemplateWithKrowProjects.put(krowProject.Krow_Project_Template__c, new List<Krow__Project__c>());
                    
                    mapOfTemplateWithKrowProjects.get(krowProject.Krow_Project_Template__c).add(krowProject);
                }
                if(oldMapOfProject != null && oldMapOfProject.get(krowProject.Id).Krow_Project_Template__c != null) {
                    setofKrowProjectIds.add(krowProject.Id);
                    setofKrowProjectTemplateIds.add(oldMapOfProject.get(krowProject.Id).Krow_Project_Template__c );
                }
                
                //added - 13/05/19
                setOfProjectId.add(krowProject.Id);
            }
        }
        
        if(setOfProjectId.size() > 0){
            //fetch completed krow task. added - 13/05/19
            for(Krow__Task__c task : [Select Id, Name, Krow__Parent_Task__c, Krow__Parent_Task__r.Name,
                                        krow__Parent_Task__r.krow__Parent_Task__c, krow__Parent_Task__r.krow__Parent_Task__r.Name, 
                                        krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c, krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.Name,
                                        krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c, krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.Name,
                                        Krow__Project__c From Krow__Task__c Where Krow__Project__c != null AND Krow__Project__c IN :setOfProjectId AND Krow__Status__c = 'Completed']){
                
                //SOT-165
                krowTaskIdsNotToDelete.add(task.Id);
                if(String.isNotBlank(task.krow__Parent_Task__c))
                    krowTaskIdsNotToDelete.add(task.krow__Parent_Task__c);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__c))
                    krowTaskIdsNotToDelete.add(task.krow__Parent_Task__r.krow__Parent_Task__c);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c))
                    krowTaskIdsNotToDelete.add(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c))
                    krowTaskIdsNotToDelete.add(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c);
                
                //contains key check in map.
                if(!completedTaskNameWithProjectId.containsKey(task.Krow__Project__c))
                    completedTaskNameWithProjectId.put(task.Krow__Project__c, new Set<String>());
                    
                completedTaskNameWithProjectId.get(task.Krow__Project__c).add(task.Name);
                
                if(String.isNotBlank(task.krow__Parent_Task__c))
                    completedTaskNameWithProjectId.get(task.Krow__Project__c).add(task.krow__Parent_Task__r.Name);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__c))
                    completedTaskNameWithProjectId.get(task.Krow__Project__c).add(task.krow__Parent_Task__r.krow__Parent_Task__r.Name);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c))
                    completedTaskNameWithProjectId.get(task.Krow__Project__c).add(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.Name);
                if(String.isNotBlank(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__c))
                    completedTaskNameWithProjectId.get(task.Krow__Project__c).add(task.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.krow__Parent_Task__r.Name);
            }
        }
        
        //Check for the Size
        if(setofKrowProjectIds.size()>0 && setofKrowProjectTemplateIds.size()>0){
            
            List<Krow__Task__c> krowTasksTobeDeleted = new List<Krow__Task__c>();
            
            //List to hold Task name
            /*List<String> KrowProjectTemplateTaskName = new List<String>();
            
            //Fetching all flow tasks that is related to Accounts
            for(Krow_Project_Template_Task__c task : [Select Id, Name, Krow_Project_Template__c From Krow_Project_Template_Task__c Where Krow_Project_Template__c != null AND Krow_Project_Template__c IN: setofKrowProjectTemplateIds]) {
                KrowProjectTemplateTaskName.add(task.name);
                
            }*/
            
            //Loop over krow task SOT-165 Added krowTaskIdsNotToDelete
            for(Krow__Task__c task :[Select Id, Krow__Project__c, Name,  Krow__Project__r.Krow_Project_Template__c From Krow__Task__c Where Krow__Project__c != null AND Id NOT IN :krowTaskIdsNotToDelete AND Krow__Project__c IN: setofKrowProjectIds /*AND Name IN:KrowProjectTemplateTaskName AND Name != null*/ AND Krow__Status__c != 'Completed']){
                krowTasksTobeDeleted.add(task);
            }
            
            //Check for the size
            if(krowTasksTobeDeleted.size()>0)
                delete krowTasksTobeDeleted;
            
        }
        
        if(mapOfTemplateWithKrowProjects.size() > 0) {
            
            //Query task records
            for(Krow_Project_Template_Task__c task : [Select Id, Name, Krow_Milestone__c, Krow_Description__c, Krow_Project_Template_Task_Order__c, 
                                                      Krow_Project_Template__c, Krow_Project_Parent_Template_Task__c, Krow_Project_Parent_Template_Task__r.Name
                                                      From Krow_Project_Template_Task__c Where Krow_Project_Template__c IN: mapOfTemplateWithKrowProjects.keyset() AND Krow_Project_Template__c != null ]) {
                                                          
                                                          if(!mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.containsKey(task.Krow_Project_Template__c)) 
                                                              mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.put(task.Krow_Project_Template__c, new List<Krow_Project_Template_Task__c>());
                                                          
                                                          mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.get(task.Krow_Project_Template__c).add(task);
                                                          
                                                          //Added 14/05/19
                                                          if(String.isNotBlank(task.Krow_Project_Parent_Template_Task__c))
                                                              mapOfTemplateTaskWithParentTemplateTaskId.put(task.Id, task);
                                                      }
            
           
            if(mapOfTemplateWithKrowProjects.size() > 0 && mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.size() > 0) {
                
                //loop through each onboarding to accounts and tasks
                for(Id templateId : mapOfTemplateWithKrowProjects.keySet()) {
                    
                    //Loop over projects related to task.
                    for(Krow__Project__c project : mapOfTemplateWithKrowProjects.get(templateId)) {
                        
                        if(mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.containsKey(templateId)) {
                            
                            //loop over the task under template.
                            for(Krow_Project_Template_Task__c templateTask : mapOfKrowProjectTemplateIDWithKrowTProjectTemplateTasks.get(templateId)){
                                
                                if(completedTaskNameWithProjectId.size() == 0 || !completedTaskNameWithProjectId.get(project.Id).contains(templateTask.Name)){
                                    Krow__Task__c krowTask = new Krow__Task__c();
                                    krowTask.Name = templateTask.Name;
                                    krowTask.Krow__Milestone__c = templateTask.Krow_Milestone__c;
                                    krowTask.Krow__Project_Task_Order__c = templateTask.Krow_Project_Template_Task_Order__c;
                                    krowTask.Project_Task_Order__c = templateTask.Krow_Project_Template_Task_Order__c;
                                    krowTask.Krow__Description__c = templateTask.Krow_Description__c;
                                    krowTask.Krow__Project__c = project.Id;
                                    
                                    mapOfkrowTaskByProjectIdAndTemplateTaskId.put(project.Id+'__'+templateTask.Id, krowTask);
                                }
                            }  
                        }
                    }
                }
                
                //size check of mapOfkrowTaskByProjectIdAndTemplateTaskId
                if(mapOfkrowTaskByProjectIdAndTemplateTaskId.size() > 0)
                    insert mapOfkrowTaskByProjectIdAndTemplateTaskId.values();
                
                //SOT-165
                Map<String, Id> mapOfKrowTaskIdWithProjectAndKrowTaskName = new Map<String, Id>(); 
                
                //loop over mapOfkrowTaskByProjectIdAndTemplateTaskId to fill mapOfKrowTaskIdWithProjectAndKrowTaskName
                for(Krow__Task__c task : [Select Id, Name, Krow__Project__c From Krow__Task__c Where Krow__Project__c IN: setOfProjectId]){
                    mapOfKrowTaskIdWithProjectAndKrowTaskName.put(task.krow__Project__c+'__'+task.Name, task.Id);
                }
                
                Map<Id, Krow__Task__c> krowTasksToUpdate = new Map<Id, Krow__Task__c>();
                
                //loop over inserted krow__task to update parent task field.
                for(String key : mapOfkrowTaskByProjectIdAndTemplateTaskId.keySet()){
                    String projectId = key.subStringBefore('__');
                    String templateTaskId = key.subStringAfter('__');
                    
                    if(mapOfTemplateTaskWithParentTemplateTaskId.containsKey(templateTaskId)){
                        
                        Krow__Task__c krowTaskRecord = mapOfkrowTaskByProjectIdAndTemplateTaskId.get(key); 
                        
                        Id parentTemplateTaskId = mapOfTemplateTaskWithParentTemplateTaskId.get(templateTaskId).Krow_Project_Parent_Template_Task__c;
                        String parentTemplateTaskName = mapOfTemplateTaskWithParentTemplateTaskId.get(templateTaskId).Krow_Project_Parent_Template_Task__r.Name;
                        
                        Id parentKrowTaskId ;
                        if(mapOfkrowTaskByProjectIdAndTemplateTaskId.containsKey(projectId+'__'+parentTemplateTaskId))
                            parentKrowTaskId = mapOfkrowTaskByProjectIdAndTemplateTaskId.get(projectId+'__'+parentTemplateTaskId).Id;
                        
                        else if(mapOfKrowTaskIdWithProjectAndKrowTaskName.containsKey(projectId+'__'+parentTemplateTaskName))
                            parentKrowTaskId = mapOfKrowTaskIdWithProjectAndKrowTaskName.get(projectId+'__'+parentTemplateTaskName);
                        
                        krowTaskRecord.Krow__Parent_Task__c = parentKrowTaskId;
                        krowTasksToUpdate.put(krowTaskRecord.Id, new Krow__Task__c(id = krowTaskRecord.Id, Krow__Parent_Task__c = krowTaskRecord.Krow__Parent_Task__c));
                    }
                }
                
                //size check of krowTasksToUpdate.
                if(krowTasksToUpdate.size() > 0)
                    update krowTasksToUpdate.values();
            }
        }
    }
        /**
    *  @description    :   This method is used to assign Queue Status according to Owner
    *
    *  @args           :   List, Map
    *
    *  @return         :   void
    * 
    **/
    public static void updateQueuedStatusOnKrowProject(List<Krow__Project__c> newProjects, Map<Id, Krow__Project__c> oldMapOfProject) {

        //Fetched specific Queue
		map<Id,Group> mapOfQueue = new Map<Id,Group>();

        //Query Queue
        QueueSObject QueueID = [Select Queue.Id, QueueId,Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name = 'SIPM' and SObjectType ='Krow__Project__c' Limit 1];
        
        //Query on Record type
        map<Id, RecordType> mapOfrecordTypes = new Map<Id,RecordType>();

        //Loop over Group
        for(Group gp : [Select Id, DeveloperName, Type From Group where Type ='Queue']){
            
            //Add values to Map
            mapOfQueue.put(gp.Id,gp);

        }
        
        //Loop over Record type
        for(RecordType rType : [Select Id, DeveloperName From RecordType where sobjecttype = 'Krow__Project__c' AND  DeveloperName = 'Buyer_Seller_Project']) {
            
            //Add Values to Map
            mapOfrecordTypes.put(rType.Id,rType);
            
        }
            
        //Loop over Krow Project
        for(Krow__Project__c krowProject : newProjects) {

            //Check the current SIPM not null and update than SIPM will be the owner of the project.    
            if(oldMapOfProject == null || ( oldMapOfProject != null && oldMapOfProject.get(krowProject.Id).SIPM__c != krowProject.SIPM__c)){

                if(krowProject.SIPM__c != null){
                   krowProject.ownerId = krowProject.SIPM__c;
                }

                else if(krowProject.SIPM__c == null && krowProject.OwnerId != QueueID.QueueId) {

                    krowProject.OwnerId = QueueID.QueueId ;
                }
            }
            
            //Check for insert case of projct and update case for project owner
            if(krowProject.OwnerId != null && krowProject.recordTypeId != null && mapOfrecordTypes.containsKey(krowProject.recordTypeId) && (oldMapOfProject == null || ( oldMapOfProject != null && oldMapOfProject.get(krowProject.Id).OwnerId != krowProject.OwnerId)) ){

                //Check for queue
                if(mapOfQueue.size()>0 && mapOfQueue.containsKey(krowProject.OwnerId)) {

                    //Check for SIPM
                    //SOT-159 Date:4/10/2019
                    if(mapOfQueue.get(krowProject.OwnerId).DeveloperName =='SIPM')
                 
                        krowProject.Krow__Project_Status__c ='Queued for SIPM';


                    //Check for Engineering
                    else if(mapOfQueue.get(krowProject.OwnerId).DeveloperName ==  'Engineering')
                        
                        krowProject.Krow__Project_Status__c ='Queued for Engineering';

                }
                //Not in queue
               /* else {
                     krowProject.Krow__Project_Status__c ='Not in Queue';
                }*/
            }
        }   
    }
    
    /**
    *  @description    :   This method is used to create buyerSellerRelationship record
    *
    *  @args           :   List
    *
    *  @return         :   void
    * 
    **/
    
    public static void createBuyerSellerRelationship(List<Krow__Project__c> projectList){
        
        //List to hold the buyerSellerRelationship records to be insert.
        List<Buyer_Seller_Relationship__c> relationshipsToBeInsert = new List<Buyer_Seller_Relationship__c>();
        
        //Set to hold id of account.
        Set<Id> setOfAccountsId = new Set<Id>();
       
        //Query on Record type
        Id recordTypeId = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Seller_Project' Limit 1].Id;
        
        //Loop over project list.
        for(Krow__Project__c project : projectList){
            
            //check buyer and seller not null.
            if(project.RecordTypeId == recordTypeId && project.Krow__Account__c != NULL && project.Seller_Account__c != NULL){
                setOfAccountsId.add(project.Krow__Account__c);
                setOfAccountsId.add(project.Seller_Account__c);
                
                //Create instance of relationship.
                Buyer_Seller_Relationship__c relationship = new Buyer_Seller_Relationship__c();
                relationship.Krow_Project__c = project.Id;
                relationship.Associate_Account__c = project.krow__Account__c;
                relationship.Buyer__c =  project.krow__Account__c;
                relationship.Seller__c = project.Seller_Account__c;
                relationship.Buyer_Parent_Account__c = project.Buyer_Parent_Account__c;
                relationship.Seller_Parent_Account__c = project.Seller_Parent_Account__c;
                //Add relationship record in list.
                relationshipsToBeInsert.add(relationship);
            }
        }

        //Check set size.
        if(setOfAccountsId.size() == 0)
            return;
        
        //Query account records.
        Map<Id, Account> queryAccounts = new Map<Id, Account>([Select Id, Name From Account Where Id IN : setOfAccountsId]);
        
        if(queryAccounts.size() == 0)
            return;
        
        //Loop over relatonship list.
        for(Buyer_Seller_Relationship__c relationship : relationshipsToBeInsert){
            relationship.Name = queryAccounts.get(relationship.Buyer__c).Name +'-'+ queryAccounts.get(relationship.Seller__c).Name;
        }
        
        //Size check on relationship list.
        if(relationshipsToBeInsert.size() > 0){
            insert relationshipsToBeInsert;  
        }
        
    }
    /**
    *  @description    :   This method is used to create Project History record
    *
    *  @args           :   List, Map
    *
    *  @return         :   void
    * 
    **/
    public static void syncProjectHistory(List<Krow__Project__c> newProjects , Map<Id,Krow__Project__c> oldMapOfProject){

        //List to hold child project History object
        List<Project_History__c> mapOfProjectHistorytobeInserted = new List<Project_History__c>();
        
        //List to hold child project History object
        List<Project_History__c> mapOfProjectHistorytobeUpdated = new List<Project_History__c>();
        
        //set to hold Project id
        Set<Id> projectId = new Set<Id>();

        //Loop over newProjects
        for(Krow__Project__c krow : newProjects) {

            //Check for Insert
            if(krow.Last_Milestone__c != null && oldMapOfProject == null) {

                    //Add record to Map
                    mapOfProjectHistorytobeInserted.add(new Project_History__c(Name = krow.Last_Milestone__c , Entered_Initial_Date__c = krow.Timestamp_for_Last_Milestone__c, Krow_Project__c = krow.id)); 
            }
            //Add Id to set
            projectId.add(krow.id);
        }

        //Check for Project Id
        if(projectId.size() >0) {
     
            //Map to hold child  Project History 
            Map<Id, Map<String,Project_History__c>> mapOfProjectHistory  = new Map<Id,  Map<String,Project_History__c>>();
            
            //Query on Project History 
            for(Project_History__c pro : [Select Krow_Project__c, Id, Name From Project_History__c Where Krow_Project__c IN : projectId]) {

                //Check for the Map 
                if(! mapOfProjectHistory.containskey(pro.Krow_Project__c)) {
                    mapOfProjectHistory.put(pro.Krow_Project__c, new Map<String,Project_History__c>());
                        if(! mapOfProjectHistory.get(pro.Krow_Project__c).containskey(pro.name))
                            mapOfProjectHistory.get(pro.Krow_Project__c).put(pro.name, new Project_History__c());
                }
                mapOfProjectHistory.get(pro.Krow_Project__c).put(pro.name,pro);
            }

            //Loop over newProjects
            for(Krow__Project__c krow : newProjects) {

                //Check for the update case
                if(oldMapOfProject!= null && oldMapOfProject.get(krow.Id) != null && krow.Last_Milestone__c != null && oldMapOfProject.get(krow.id).Last_Milestone__c != krow.Last_Milestone__c ) {
                        
                    //Check on Project history name
                    if( mapOfProjectHistory.size() > 0 && mapOfProjectHistory.get(krow.Id) != null && mapOfProjectHistory.get(krow.Id).containskey(krow.Last_Milestone__c)) {
                            
                        //assign record to update
                        mapOfProjectHistorytobeUpdated.add(new Project_History__c(Id = mapOfProjectHistory.get(krow.Id).get(krow.Last_Milestone__c).Id,
                                                                                        Name = krow.Last_Milestone__c , Entered_Initial_Date__c = krow.Timestamp_for_Last_Milestone__c ,
                                                                                        Krow_Project__c =krow.id));

                    }
                    else 
                        //assign record to insert
                        mapOfProjectHistorytobeInserted.add(new Project_History__c( Name = krow.Last_Milestone__c , Entered_Initial_Date__c = krow.Timestamp_for_Last_Milestone__c, Krow_Project__c = krow.id)); 
                }
            }
            //Check for the size
            if(mapOfProjectHistorytobeInserted.size() >0) {
                insert mapOfProjectHistorytobeInserted;
            }   
            if(mapOfProjectHistorytobeUpdated.size() > 0) {
                update mapOfProjectHistorytobeUpdated;
            }
        }
    }
    /**
      *  @description    :   This method is used to update the Buyer /Seller PArent Account on Krow Project
      *
      *  @args           :   List, Map
      *
      *  @return         :   void
      *
      *  @Revision log   :	 Created - 20-09-2019
      * 
    **/
    public static void updatedParentSellerBuyerAccountOnKrowProject(List<Krow__Project__c> projects, Map<Id, Krow__Project__c> oldMapOfProject) {

		//Set to hold PArent Account
		Set<Id> accountIds = new Set<Id>();
	
		//Loop over Krow Project
		for(Krow__Project__c kp : projects) {

			//Check for tthe Insert/Update case
			if(kp.Seller_Account__c != null || 	kp.Krow__Account__c != null && 
               (oldMapOfProject == null 	|| 	kp.Seller_Account__c != oldMapOfProject.get(kp.Id).Seller_Account__c ||
												kp.Krow__Account__c != oldMapOfProject.get(kp.Id).Krow__Account__c)){

				//Check Account is Both seller/Buyer
				if(kp.Seller_Account__c == kp.Krow__Account__c)
					accountIds.add(kp.Krow__Account__c);
				else {
					accountIds.add(kp.Seller_Account__c);
					accountIds.add(kp.Krow__Account__c);
				}
			}
		}

		//Check fo set Size
		if(accountIds.size() >0 ){

			//Query over Account
			Map<Id,Account> mapOfAccounts = new Map<Id,Account>([Select Id, ParentId From Account where Id IN :accountIds]);
		
			//Loop over Krow Project
			for(Krow__Project__c kp : projects) {

				//Check for Seller Account  / Buyer Account
				if(kp.Seller_Account__c != null || kp.Krow__Account__c != null ) {
				
					//Check the Seller Account
					if(mapOfAccounts.containskey(kp.Seller_Account__c))
						kp.Seller_Parent_Account__c = mapOfAccounts.get(kp.Seller_Account__c).ParentId;
					
					//Check the Buyer Account
					if(mapOfAccounts.containskey(kp.Krow__Account__c))
						kp.Buyer_Parent_Account__c = mapOfAccounts.get(kp.Krow__Account__c).ParentId;

				}
			}
		}
	}
}