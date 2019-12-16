/**
* Description     -     This class is helper class for trigger on Contact object.
* 
* Created by      -   
* 
* Created Date    -     20/05/2019
*
* Revision log    -     Created
*                   
*/
public class ContactTriggerHelper {
    
    public static Integer MAX_AD_TASK = 100;
    
    /**
    *  @description    :   This method is used to create task under contact if impression reached to 500 or more.
    *
    *  @args           :   List, Map
    *
    *  @return         :   void
    * 
    **/
    
    public static void createTaskForImpression(List<Contact> newContactList, Map<Id, Contact> oldMapOfContact){
        
        //Set of contact id which have more than or equals 500 contact impression.
        Set<Id> setOfContactIds = new Set<Id>();
        
        //Map used to hold impression task by their contact id.
        Map<Id, List<String>> mapOfTaskNameByContactId = new Map<Id, List<String>>();
        
        //List of task to insert.
        List<Task> listOfTaskToInsert = new List<Task>();
        
        //Loop over newContactList
        for(Contact con : newContactList){
            
            //check update condition
            if(oldMapOfContact != null && ( (con.adroll__Impressions__c != oldMapOfContact.get(con.Id).adroll__Impressions__c && con.adroll__Impressions__c >= 500) || (con.adroll__Clicks__c != oldMapOfContact.get(con.Id).adroll__Clicks__c && con.adroll__Clicks__c > 0))){
                setOfContactIds.add(con.Id);
            }
        }
        
        //check size of setofContactIds
        if(setOfContactIds.size() > 0){
            
            //Query task record.
            for(Task taskRecord : [Select Id, Subject, WhoId From Task Where WhoId IN : setOfContactIds]){
                
                //Fill mapOfTaskNameByContactId
                if(!mapOfTaskNameByContactId.containsKey(taskRecord.WhoId))
                    mapOfTaskNameByContactId.put(taskRecord.WhoId, new List<String>());
                    
                mapOfTaskNameByContactId.get(taskRecord.WhoId).add(taskRecord.Subject);
            }
        }
            //Loop over new Contact record to create task record.
            for(Contact con : newContactList){
                
                //check update condition
                if(oldMapOfContact != null && con.adroll__Impressions__c != oldMapOfContact.get(con.Id).adroll__Impressions__c && con.adroll__Impressions__c >= 500){
                    
                    Integer quotient = Integer.valueOf(con.adroll__Impressions__c/500) ;
                    
                    //check contains key in map.
                    if(mapOfTaskNameByContactId.containsKey(con.Id)){
                        system.debug(con.Id + con.LastName);
                    system.debug(mapOfTaskNameByContactId);
                        List<String> listOfTaskName = mapOfTaskNameByContactId.get(con.Id);
                        
                        //Loop to create task
                        for(Integer i=1 ; i <= (quotient <= MAX_AD_TASK ?quotient :MAX_AD_TASK) ; i++){
                            
                            //check task contains or not
                            if(!listOfTaskName.contains('Paid Digital- '+ i*500 +' Ad Impressions')){
                                Task taskRecord = new Task();
                                taskRecord.subject = 'Paid Digital- '+ i*500 +' Ad Impressions';
                                taskRecord.WhoId = con.Id;
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
                        //Loop to create task
                        for(Integer i=1 ; i <= (quotient <= MAX_AD_TASK ?quotient :MAX_AD_TASK) ; i++){
                                
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital- '+ i*500 +' Ad Impressions';
                            taskRecord.WhoId = con.Id;
                            taskRecord.ActivityDate = date.Today();
                            taskRecord.Type = 'Other';
                            taskRecord.Status = 'Completed';
                            taskRecord.Priority = 'Normal';
                            
                            //add task into list.
                            listOfTaskToInsert.add(taskRecord);
                        }
                    }
                }
                
                //check for contact clicks.
                if(oldMapOfContact != null && con.adroll__Clicks__c != oldMapOfContact.get(con.Id).adroll__Clicks__c && con.adroll__Clicks__c > 0){
                    system.debug(con.Id + con.LastName);
                    system.debug(mapOfTaskNameByContactId);
                    //check contains key in map.
                    if(mapOfTaskNameByContactId.containsKey(con.Id)){
                        
                        List<String> listOfTaskName = mapOfTaskNameByContactId.get(con.Id);
                        
                        //Loop to create task
                        for(Integer i=1 ; i <= (con.adroll__Clicks__c <= MAX_AD_TASK ? con.adroll__Clicks__c :MAX_AD_TASK) ; i++){
                                
                            //check task contains or not
                            if(!listOfTaskName.contains('Paid Digital- '+ i +' Ad Click')){
                                Task taskRecord = new Task();
                                taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                                taskRecord.WhoId = con.Id;
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
                        //Loop to create task
                        for(Integer i=1 ; i <= (con.adroll__Clicks__c <= MAX_AD_TASK ? con.adroll__Clicks__c :MAX_AD_TASK) ; i++){
                            
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                            taskRecord.WhoId = con.Id;
                            taskRecord.ActivityDate = date.Today();
                            taskRecord.Type = 'Other';
                            taskRecord.Status = 'Completed';
                            taskRecord.Priority = 'Normal';
                            
                            //add task into list.
                            listOfTaskToInsert.add(taskRecord);
                        }
                    }
                }
            }
            
            //size check of list.
            if(listOfTaskToInsert.size() > 0)
                insert listOfTaskToInsert;
    }    
}