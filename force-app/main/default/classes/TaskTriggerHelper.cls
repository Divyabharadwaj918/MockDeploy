/**
*  Description     :   This class is helper class of task trigger.
*
*  Created By      :   
*
*  Created Date    :   29/05/2019
*
*  Revision Log    :   V_1.0 - Created 
*                      
**/
public class TaskTriggerHelper{
    
    
    /**
    *   @description    :   This method is used To send the email notification to the assignee.
    *                       
    *   @args           :   list<Task>
    *
    *   @return         :   void
    *
    *   @revision Log   :     
    */
    public static void sendNotification(List<Task> newTasks){
    

        //Set to hold the ID of the tassk owner
        Set<Id> taskOwnerIds = new Set<Id>();
        
        //Set to hold the ID for task Created by User
        Set<Id> createdbyIds = new Set<Id>(); 
        
        //Set to hold the  id of the Opportunity
        Set<Id> oppIds = new Set<Id>();
        
        //List to hold the Messagin.singleEmail
        List<Messaging.SingleEmailMessage> emailNotifications = new List<Messaging.SingleEmailMessage>();
        
         Map<String,RecordType> plateformTaskRecordType = new Map<String,RecordType>();
        
        for(RecordType record :[Select Id,DeveloperName  from RecordType where SobjectType ='TASK']){
            if(!plateformTaskRecordType.containsKey(record.DeveloperName))
                plateformTaskRecordType.put(record.DeveloperName, record);   
        }
        //Loop over the new list of tasks  
        for(Task tK : newTasks){
            
            if(tK.WhatId != null && tK.WhatId.getSObjectType() == Schema.Opportunity.SObjectType && (tk.RecordTypeId == plateformTaskRecordType.get('Platform_Solution_Consulting_Request').Id
                                                                                                    ||  tk.RecordTypeId == plateformTaskRecordType.get('Platform_Value_Consulting_Request').Id
                                                                                                    || tk.RecordTypeId == plateformTaskRecordType.get('FDE_Resource_Request').Id)) {
                
                taskOwnerIds.add(tk.OwnerId);
                createdbyIds.add(tk.createdbyId);
                oppIds.add(tk.WhatId);
                                                                                                   
            }
        }   
        
        
        //Map to hold the Opportunity record
        Map<Id, Opportunity> mapOfOpp = new Map<Id, Opportunity>([Select Id, Name, OwnerId From Opportunity Where ID IN: oppIds]);
        
       /* //Loop over the Opportuity map to set the Opportunity ower ID in a set
        for(Opportunity opp : mapOfOpp.values()){
            
                oppOwnerIDs.add(opp.OwnerId );
        }*/
        
        //Map to hold the user record
        Map<Id, User> mapOfUsers= new Map<Id, User>([Select Id, Name, Email From User Where ID IN: taskOwnerIds]);
        
        //Mapto hold the opp owern detail
        Map<Id, User> mapOftaskCreatedby = new Map<Id, User>([Select Id, Name, Email From User Where ID IN: createdbyIds]);
        
        //Loop over the new list of tasks  
        for(Task tK : newTasks){
            //Message Instance
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //To hold the address
            if(mapOfUsers.size()>0){
                List<String> toAddresses = new List<String>{mapOfUsers.get(tk.OwnerId).Email};
               
            //Mail details
            mail.setToAddresses(toAddresses);
            mail.setSubject('Regarding Task Assignment');
            
            //String to hold the html email body
            String mailBody = '';
            mailBody = 'Hi '+mapOfUsers.get(tk.OwnerId).Name+ ',';
            mailBody += '<br /> <br /> ';
            mailBody += mapOftaskCreatedby.get(tk.createdbyId).Name +' has requested your help on '+ mapOfOpp.get(tk.WhatId).Name;
            mailBody += '<br /> <br />'; 
            mailBody += 'Link to Task: '; 
            mailBody += '<a href="'+'https://'+System.URL.getSalesforceBaseUrl().getHost()+'/'+ tk.Id + '">Click here </a>';
            mailBody += '<br />'; 
            mailBody += 'Link to Opportunity: '; 
            mailBody += '<a href="'+'https://'+System.URL.getSalesforceBaseUrl().getHost()+'/'+ mapOfOpp.get(tk.WhatId).Id + '">Click here </a>';
            
            //Set the html body
            mail.setHtmlBody(mailBody);
            System.debug('mail body'+ mailBody);
            
            emailNotifications.add(mail);
            }
        }
        
        //Size Check
        if(emailNotifications.size() > 0){
            
            //To send mail
            Messaging.sendEmail(emailNotifications,false);
        }
    }

     /**
    *   @description    :   This method is used to create record of Task_Status_Tracking__c object to track task status history.
    *                       
    *   @args           :   list<Task>, map<Id, Task>
    *
    *   @return         :   void
    *
    *   @revision Log   :     
    */
    public static void createTaskStatusTrackingRecord(List<Task> newListOfTask, Map<Id, Task> oldMapOfTask ){
        
        //List to insert Task_Status_Tracking__c record.
        List<Task_Status_Tracking__c> listOfTaskStatusTrackToInsert = new List<Task_Status_Tracking__c>();
        
        //Map used to hold record type with its id.
        Map<Id, RecordType> mapOfRecordType = new Map<Id, RecordType>([select Id, DeveloperName From RecordType where sobjectType = 'Task']);
       
        //Loop over newListOfTask.
        for(Task task : newListOfTask){
            
            //check insert and update case.
            if(task.WhatId != null && task.whatId.getSObjectType() == Schema.Opportunity.SObjectType &&  (oldMapOfTask == null || (oldMapOfTask != null && task.Status != oldMapOfTask.get(task.Id).status))){
                
                //Create an instance of Task_Status_Tracking__c.
                Task_Status_Tracking__c  taskStatusTrack = new Task_Status_Tracking__c();
                taskStatusTrack.Opportunity__c = task.WhatId;
                taskStatusTrack.TaskId__c = task.Id;
                taskStatusTrack.Task_Name__c = task.Subject;
                taskStatusTrack.New_Status__c = task.Status;
                taskStatusTrack.Old_Status__c = oldMapOfTask == null ? '':oldMapOfTask.get(task.Id).Status;
                taskStatusTrack.Task_Reocrd_Type_Id__c = task.RecordTypeId;
                taskStatusTrack.Task_Record_Type_Name__c = mapOfRecordType != null ? mapOfRecordType.get(task.RecordTypeId).DeveloperName : '';
                
                //Add taskTracking in list.
                listOfTaskStatusTrackToInsert.add(taskStatusTrack);
            }
        }
        
        //check size of list.
        if(listOfTaskStatusTrackToInsert.size() > 0)
            insert listOfTaskStatusTrackToInsert;
    }
    /**
    *  @description    :   This method is used to update Task Record type to Seller Sales if Assigned to is of Role VP_Seller_Sales
    *
    *  @args           :   List , Map
    *
    *  @return         :   void
    * 
    **/
    public static void updateRecordType_SellerSalesOnTask(List<Task> tasks, Map<Id, Task> oldMapOfTask){
        
        //Set to hold owner id
        Set<Id> ownerIds = new Set<Id>();
        
        //Loop over Task
        for(Task tk : tasks) {
            
            //Check for Insert and Map
            if(tk.OwnerId != null && (oldMapOfTask == null || tk.OwnerId != oldMapOfTask.get(tk.Id).OwnerId)) {
                
                //Add owner ID to set
                ownerIds.add(tk.OwnerId);
            }
        }
        
        //Check for Owner Id
        if(ownerIds.size() > 0){
            
            Map<Id, User> mapofUsers = new Map<Id, User>([Select Id, UserRole.DeveloperName From User where ID IN : ownerIds]);
            
            //Loop over Task
            for(Task tk :tasks) {
                
                //Check of Map contains owner ID
                if(mapofUsers.containsKey(tk.ownerId) && mapofUsers.get(tk.ownerId).UserRole.DeveloperName.equalsIgnoreCase( 'VP_Seller_Sales' )) {
                    
                    Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Seller Sales').getRecordTypeId();
                    
                    //Check if Record type is Not 'Seller Sale'
                    if(tk.RecordTypeId != devRecordTypeId)
                        tk.RecordTypeId = devRecordTypeId;
                    
                }
            }
        }
    }
}