/**
* Description     -   This class is helper class for trigger on Krow Task object.
* 
* Created by      -   
* 
* Created Date    -   02/12/2019
*
* Revision log    -   
*                   
*/
public class KrowTaskTriggerHelper {
    
   /**
    *  @description    :   This method is used to assign the Queue to Project and Krow task owner. 
    *
    *  @args           :   List
    *
    *  @return         :   void
    * 
    **/
    public static void assignEnggQueue(List<Krow__Task__c> newListOfKrowTasks, Map<Id, Krow__Task__c> oldMapOfKrowTasks ) {
        
        //Size check
        if(newListOfKrowTasks.size() > 0) {
            
            Map<Id,Krow__project__c> mapOfkrowProj = new Map<Id,Krow__project__c>();
            
            for(Krow__Task__c krowtask : newListOfKrowTasks) {
                //Insert and update case
                if(oldMapOfKrowTasks == null || (oldMapOfKrowTasks != null && krowtask.Krow__Status__c != oldMapOfKrowTasks.get(krowtask.Id).Krow__Status__c && krowtask.Krow__Status__c == 'Completed')) {

                    if(krowtask.Name == 'Send full data set to Engineering' && krowtask.Krow__project__c !=null) {
                       mapOfkrowProj.put(krowtask.Krow__project__c,new Krow__project__c(Id = krowtask.Krow__project__c,Krow__Project_Status__c ='Queued for Triage'));
                    }
                    if(krowtask.Name == 'Assign engineer or reject' && krowtask.Krow__project__c !=null) {
                        mapOfkrowProj.put(krowtask.Krow__project__c,new Krow__project__c(Id = krowtask.Krow__project__c, Krow__Project_Status__c ='Not in Queue'));
                    }
                }
            } 
            if(mapOfkrowProj.size() > 0) {
                update mapOfkrowProj.values();
            }
        }
    }
   /**
    *  @description    :   This method is used to update Last_Milestone__c , Timestamp_for_Last_Milestone__c on Project
    *
    *  @args           :   List , Map
    *
    *  @return         :   void
    * 
    **/
    public static void updateLastMilestoneOnKrowProject(List<Krow__Task__c> tasks, Map<Id, Krow__Task__c> oldMapOfTasks) {

        //Set to hold Projects Id
        Set<Id> projectIds = new Set<Id>();
    
        //Loop over Tasks
        for(Krow__Task__c task : tasks) {
    
            //Check for Insert and update case
            if(task.Krow__Project__c != null && task.Krow__Milestone__c == true && task.Krow__Status__c == 'Completed' && 
                                                (oldMapOfTasks == null || task.Krow__Status__c != oldMapOfTasks.get(task.Id).Krow__Status__c || 
                                                 task.Krow__Milestone__c != oldMapOfTasks.get(task.Id).Krow__Milestone__c ||
                                                 task.Krow__Project__c != oldMapOfTasks.get(task.Id).Krow__Project__c)) {
    
                projectIds.add(task.Krow__Project__c);
            }
        }
    
        //Check for Project Id
        if(projectIds.size() > 0){

            Map<Id,Krow__Project__c> mapOfProjects = new  Map<Id,Krow__Project__c>([Select Id, Last_Milestone__c, Timestamp_for_Last_Milestone__c From Krow__Project__c Where Id IN:projectIds ]);
    
            //Check for the Map size
            if(mapOfProjects.size() >0) {
    
                //Loop over Tasks
                for(Krow__Task__c task : tasks) {
    
                    //Check for the key
                    if(mapOfProjects.containsKey(task.Krow__Project__c) && task.Krow__Milestone__c == true ) {
                        mapOfProjects.get(task.Krow__Project__c).Last_Milestone__c = task.Name;
                        mapOfProjects.get(task.Krow__Project__c).Timestamp_for_Last_Milestone__c = System.Datetime.now();
                    }
                }
                if(mapOfProjects.size()>0){
                    update mapOfProjects.values();
                }
            }
        }
    }    
    /**
    *  @description    :   This method is used to check the Preceding Milestone status, on the bases of Project task order.
    *                       It wouldn't allow the upcoming milestone task to be completed till the preceding Milestone was complete. 
    *
    *  @args           :   List , Map
    *
    *  @return         :   void
    * 
    **/
    public static void preventPrecedingMilestoneToBeCompleted(List<Krow__Task__c> newListOfKrowTasks, Map<Id, Krow__Task__c> oldMapOfKrowTasks){
        
        //Set to hold Parent Krow Project Id
        Set<Id> setParentId = new Set<Id>();

        //Map top hold Project Id with all the realted task of that project
        Map<Id,Map<Id,Krow__Task__c>> relatedKrowTask = new Map<Id,Map<Id,Krow__Task__c>>();
        
        //Loop over Krow Task
        for(Krow__Task__c task :newListOfKrowTasks){
            
            //Condition to check parentId 
            if(task.Krow__Project__c != null && task.Krow__Status__c == 'Completed' && task.Krow__Milestone__c == true && (oldMapOfKrowTasks == null || task.Krow__Status__c != oldMapOfKrowTasks.get(task.Id).Krow__Status__c || task.Krow__Milestone__c != oldMapOfKrowTasks.get(task.Id).Krow__Milestone__c ))
                setParentId.add(task.Krow__Project__c);
        }
            
        //Check for the size
        if(setParentId.size() >0) {

            //Query on Project History 
            for(Krow__Task__c task : [Select Krow__Project__c, Krow__Project_Task_Order__c, Project_Task_Order__c, Id, Name, Krow__Milestone__c, Krow__Status__c 
                                    From Krow__Task__c Where Krow__Project__c IN : setParentId AND Krow__Milestone__c = true  order by Project_Task_Order__c/*Krow__Project_Task_Order__c*/]) {
                //Check for the Map 
                if(! relatedKrowTask.containskey(task.Krow__Project__c)) {
                    relatedKrowTask.put(task.Krow__Project__c, new Map<Id,Krow__Task__c>());
                 
                    if(! relatedKrowTask.get(task.Krow__Project__c).containskey(task.Id))
                        relatedKrowTask.get(task.Krow__Project__c).put(task.id, new Krow__Task__c());
                }
            
                //assign related Krow Task
                relatedKrowTask.get(task.Krow__Project__c).put(task.id,task);

            }
        
            //Loop Over New List
            for(Krow__Task__c task : newListOfKrowTasks) {
            
                //Condition 
                if(relatedKrowTask.get(task.Krow__Project__c) != null && task.Krow__Milestone__c == true && task.Krow__Status__c == 'Completed') {
                
                    //Loop over relatedKrowTask values
                    for(Krow__Task__c relatedTask : relatedKrowTask.get(task.Krow__Project__c).values()) {

                        if(/*relatedTask.Krow__Project_Task_Order__c < task.Krow__Project_Task_Order__c*/relatedTask.Project_Task_Order__c < task.Project_Task_Order__c && relatedTask.Krow__Status__c != 'Completed')
                            
                            //Display Error on Updated Task
                            task.addError('Please complete preceding milestone task first, then only you can complete this task.');
                    }
                }
            }
         }
    }
    
     /**
    *  @description    :   This method is used to maintain the order of the krow task. 
    *
    *  @args           :   List
    *
    *  @return         :   void
    * 
    **/
    
    public static void maintainOrderOfKrowTask(List<Krow__Task__c> newListOfKrowTask){
        //Set to hold newly created taskId.
        Set<Id> setOfNewlyCreatedTaskIds = new Set<Id>();
        
        //Set to hold projectId
        Set<Id> setOfProjectIds = new Set<Id>();
        
        //Map to hold newly created task with project id.
        Map<Id, List<Krow__Task__c>> mapOfNewKrowTaskWithProjectId = new Map<Id, List<Krow__Task__c>>();
        
        //Map to hold existing krow task with project id.
        Map<Id, List<Krow__Task__c>> mapOfExistTaskWithProjectId = new Map<Id, List<Krow__Task__c>>();
        
        //Map to hold task to update.
        Map<Id, Krow__Task__c> mapOfKrowTaskToBeUpdate = new Map<Id, Krow__Task__c>();
        
        //Loop over mapOfKrowTask
        for(Krow__Task__c krowTask : newListOfKrowTask){
            
            //add task id in set.
            setOfNewlyCreatedTaskIds.add(krowTask.Id);
            setOfProjectIds.add(krowTask.Krow__Project__c);
            
            //containsKey check in map of project id.
            if(!mapOfNewKrowTaskWithProjectId.containsKey(krowTask.Krow__Project__c))
                mapOfNewKrowTaskWithProjectId.put(krowTask.Krow__Project__c, new List<Krow__Task__c>());
            
            mapOfNewKrowTaskWithProjectId.get(krowTask.Krow__Project__c).add(krowTask);
        }
        
        //query on krow task to fill mapOfExistTaskWithProjectId
        for(Krow__Task__c krowTask : [Select Id, Name, Krow__Project__c, Project_Task_Order__c From Krow__Task__c Where Id NOT IN :setOfNewlyCreatedTaskIds AND Krow__Project__c IN :setOfProjectIds ORDER BY Project_Task_Order__c ASC]){
            
            //containsKey check on mapOfExistTaskWithProjectId
            if(!mapOfExistTaskWithProjectId.containsKey(krowTask.Krow__Project__c))
                mapOfExistTaskWithProjectId.put(krowTask.Krow__Project__c, new List<Krow__Task__c>());
                
            mapOfExistTaskWithProjectId.get(krowTask.Krow__Project__c).add(krowTask);
        }
        
        
        if(mapOfExistTaskWithProjectId.size() > 0){
            
            //Variable to set order no of task.
            Integer orderNumber; 
            
            //Loop over the mapOfNewKrowTaskWithProjectId to set the order no.
            for(Id projectId : mapOfExistTaskWithProjectId.KeySet()){
                
                //set order no to 1
                orderNumber = 1;
                
                //Update existing task order
                for(Krow__Task__c krowTask : mapOfExistTaskWithProjectId.get(projectId)){
                    
                    //put krow task in map.
                    mapOfKrowTaskToBeUpdate.put(krowTask.Id, new Krow__Task__c(Id= krowTask.Id, Name = krowTask.Name, Project_Task_Order__c = orderNumber));
                    orderNumber++;
                }
                
                //check project id contains in mapOfNewKrowTaskWithProjectId
                if(mapOfNewKrowTaskWithProjectId.containsKey(projectId)){
                    List<Krow__Task__c> krowTaskList = sortKrowTask(mapOfNewKrowTaskWithProjectId.get(projectId));
                    //loop over new krow task get from map to set order number
                    for(Krow__Task__c newKrowTask : krowTaskList){
                        //put krow task in map
                        mapOfKrowTaskToBeUpdate.put(newKrowTask.Id, new Krow__Task__c(Id= newKrowTask.Id, Name = newKrowTask.Name, Project_Task_Order__c = orderNumber));
                        orderNumber++;
                    }
                }
            }
            //system.assert(false, mapOfKrowTaskToBeUpdate.values());
            if(mapOfKrowTaskToBeUpdate.size() > 0){
                update mapOfKrowTaskToBeUpdate.values();
            }
            
        }
    }
    
    public static void syncProjectHistory(List<Krow__Task__c> newTask , Map<Id,Krow__Task__c> oldMapOfTask){
        
        /*
        //List to hold child project History object
        List<Project_History__c> mapOfProjectHistorytobeInserted = new List<Project_History__c>();
        
        //List to hold child project History object
        List<Project_History__c> mapOfProjectHistorytobeUpdated = new List<Project_History__c>();
        
        //set to hold Project id
        Set<Id> taskId = new Set<Id>();
        
        //Loop over newProjects
        for(Krow__Task__c krow : newTask) {

            //Check for Insert
            if(krow.Krow__Milestone__c != false && krow.Krow__Status__c == 'Completed' && oldMapOfTask == null) {

                    //Add record to Map
                    mapOfProjectHistorytobeInserted.add(new Project_History__c(Name = krow.Name , Entered_Initial_Date__c = system.today(), Krow_Task__c = krow.id)); 
            }
            //Add Id to set
            taskId.add(krow.id);
        }

        //Check for Project Id
        if(taskId.size() >0) {
     
            //Map to hold child  Project History 
            Map<Id, Project_History__c> mapOfProjectHistory  = new Map<Id, Project_History__c>();
            
            //Query on Project History 
            for(Project_History__c pro : [Select Krow_Project__c, Krow_Task__c,Id, Name From Project_History__c Where Krow_Task__c IN : taskId]) {

                //Check for the Map 
                if(! mapOfProjectHistory.containskey(pro.Krow_Task__c)) {
                    mapOfProjectHistory.put(pro.Krow_Task__c,new Project_History__c());
                   mapOfProjectHistory.put(pro.Krow_Task__c,pro);
            }
            }
            //Loop over newProjects
            for(Krow__Task__c krow : newTask) {

                //Check for the update case
                if(oldMapOfTask!= null  && krow.Krow__Milestone__c != false && krow.Krow__Status__c =='Completed') {
                                  
                    //Check on Project history name
                    if( mapOfProjectHistory.size() > 0 && mapOfProjectHistory.get(krow.Id) != null && mapOfProjectHistory.get(krow.Id).Name == krow.Name) {
                            
                        //assign record to update
                        mapOfProjectHistorytobeUpdated.add(new Project_History__c(Id = mapOfProjectHistory.get(krow.Id).Id,
                                                                                        Name = krow.name , Entered_Initial_Date__c = System.Datetime.now(), Krow_Task__c = krow.id, Krow_Project__c= krow.Krow__Project__c));

                    }
                    else 
                        //assign record to insert
                        mapOfProjectHistorytobeInserted.add(new Project_History__c( Name = krow.name , Entered_Initial_Date__c = System.Datetime.now(), Krow_Task__c = krow.id, Krow_Project__c= krow.Krow__Project__c)); 
                }
            }
            
            //Check for the size
            if(mapOfProjectHistorytobeInserted.size() >0) {
                insert mapOfProjectHistorytobeInserted;
            }   
            if(mapOfProjectHistorytobeUpdated.size() > 0) {
                update mapOfProjectHistorytobeUpdated;
            }
        }*/
    }
    
     /**
    *  @description    :   This method is used to sort the list of record
    *
    *  @args           :   List
    *
    *  @return         :   List<Krow__Task__c>
    * 
    **/
    private static List<Krow__Task__c> sortKrowTask(List<Krow__Task__c> listOfKrowTask){
        for (Integer i =0; i < listOfKrowTask.size(); i++) {
            for (Integer j = i; j > 0; j--) {
                if (listOfKrowTask[j-1].Project_Task_Order__c > listOfKrowTask[j].Project_Task_Order__c){
                    Krow__Task__c temp = listOfKrowTask[j];
                    listOfKrowTask[j] = listOfKrowTask[j-1];
                    listOfKrowTask[j-1] = temp;
                }
            }
        }
        return listOfKrowTask;
    }
}