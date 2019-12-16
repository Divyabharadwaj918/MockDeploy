/**
* Description     -   This class is used to update lead owner
* 
* Created by      -   
* 
* Created Date    -   1/31/2019
*
* Revision log    -   
*                   
*/
public without sharing class LeadTriggerHelper {
    
    public static Boolean byPassTrigger = false;
    
    /** @description    :   This method is used to update lead owner as queue. 
*
*  @args          :   List, Map
*
*  @return        :   void
* 
**/
    public static void LeadAssign(List<Lead> newLeads, Map<Id, Lead> oldMapOfLeads) {
        
        if(newLeads.size() > 0) {
            
            //Fetching a particular queue id
            List<Group> queues = [Select Id, Name From Group Where Type = 'Queue' AND Name ='Unassigned Leads Queue'];
            List<Lead> leadstoUpdate = new List<Lead>();
            
            for(Lead ld: newLeads) { 
                
                //Condition for checkbox value change from false to true only and owner id should be for Unassigned Leads Queue
                if(ld.Re_route_lead__c != oldMapOfLeads.get(ld.Id).Re_route_lead__c && ld.Re_route_lead__c == true && ld.OwnerId == queues[0].Id) {
                    
                    //Specifies the assignment rule to be used when updating/creating a lead.
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    
                    //Running for default active rule
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    
                    //Assign id and checkbox value in Lead
                    Lead leadInst = new Lead (Id=ld.Id, Re_route_lead__c = false);
                    leadInst.setOptions(dmo);
                    leadstoUpdate.add(leadInst);
                }
            }
            if(leadstoUpdate.size() > 0) {
                byPassTrigger = true;
                update leadstoUpdate;
            }
        }
    }  
    
    /**
*  @description    :   This method is used to create task under Lead if impression reached to 500 or more.
*
*  @args           :   List, Map
*
*  @return         :   void
* 
**/   
    public static void createTaskForImpression(List<Lead> newLeadList , Map<Id, Lead> oldMapOfLead){
        Integer MAX_AD_TASK = 100;
        
        //Set of contact id which have more than or equals 500 contact impression.
        Set<Id> setOfLeadIds = new Set<Id>();
        
        //Map used to hold task by their contact id.
        Map<Id, List<String>> mapOfTaskNameByLeadId = new Map<Id, List<String>>();
        
        //List of task to insert.
        List<Task> listOfTaskToInsert = new List<Task>();
        
        //Loop over newContactList
        for(Lead lead : newLeadList){
            
            //check update condition
            if(oldMapOfLead != null && ((lead.adroll__Impressions__c != oldMapOfLead.get(lead.Id).adroll__Impressions__c && lead.adroll__Impressions__c >= 500)
                                        ||(lead.adroll__Clicks__c > 0 && lead.adroll__Clicks__c != oldMapOfLead.get(lead.Id).adroll__Clicks__c))){
                                            setOfLeadIds.add(lead.Id);
                                        }
        }
        
        //check size of setofContactIds
        if(setOfLeadIds.size() > 0){
            
            //Query task record.
            for(Task taskRecord : [Select Id, Subject, WhoId From Task Where WhoId IN : setOfLeadIds]){
                
                //Fill mapOfTaskNameByContactId
                if(!mapOfTaskNameByLeadId.containsKey(taskRecord.WhoId))
                    mapOfTaskNameByLeadId.put(taskRecord.WhoId, new List<String>());
                
                mapOfTaskNameByLeadId.get(taskRecord.WhoId).add(taskRecord.Subject);
            }
        }
        //Loop over new Contact record to create task record.
        for(Lead lead : newLeadList){
            
            Integer quotient;
            
            //check update condition
            if(oldMapOfLead != null && lead.adroll__Impressions__c != oldMapOfLead.get(lead.Id).adroll__Impressions__c && lead.adroll__Impressions__c >= 500){
                
                quotient = Integer.valueOf(lead.adroll__Impressions__c/500) ;
                
                //check contains key in map.
                if(mapOfTaskNameByLeadId.containsKey(lead.Id)){
                    
                    List<String> listOfTaskName = mapOfTaskNameByLeadId.get(lead.Id);
                    
                    //Loop to create task
                    for(Integer i=1 ; i <= (quotient<= MAX_AD_TASK ?quotient :MAX_AD_TASK) ; i++){
                        
                        //check task contains or not
                        if(!listOfTaskName.contains('Paid Digital-'+ i*500+' Ad Impressions' )){
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital-'+ i*500+' Ad Impressions';
                            taskRecord.WhoId = lead.Id;
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
                    for(Integer i=1 ; i <= (quotient<= 100 ?quotient :100) ; i++){
                        
                        Task taskRecord = new Task();
                        taskRecord.subject = 'Paid Digital-'+ i*500+' Ad Impressions';
                        taskRecord.WhoId = lead.Id;
                        taskRecord.ActivityDate = date.Today();
                        taskRecord.Type = 'Other';
                        taskRecord.Status = 'Completed';
                        taskRecord.Priority = 'Normal';
                        
                        //add task into list.
                        listOfTaskToInsert.add(taskRecord);
                    }
                }
            }
            
            //check for Lead clicks.
            if(oldMapOfLead != null && lead.adroll__Clicks__c != oldMapOfLead.get(lead.Id).adroll__Clicks__c && lead.adroll__Clicks__c > 0){
                
                //check contains key in map.
                if(mapOfTaskNameByLeadId.containsKey(lead.Id)){
                    List<String> listOfTaskName = mapOfTaskNameByLeadId.get(lead.Id);
                    
                    //Loop to create task
                    for(Integer i=1 ; i <= (lead.adroll__Clicks__c <= 100 ? lead.adroll__Clicks__c:MAX_AD_TASK ); i++){
                        
                        //check task contains or not
                        if(!listOfTaskName.contains('Paid Digital- '+ i +' Ad Click')){
                            Task taskRecord = new Task();
                            taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                            taskRecord.WhoId = lead.Id;
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
                    for(Integer i=1 ; i <= (lead.adroll__Clicks__c <= 100 ? lead.adroll__Clicks__c:MAX_AD_TASK ) ; i++){
                        
                        Task taskRecord = new Task();
                        taskRecord.subject = 'Paid Digital- '+ i +' Ad Click';
                        taskRecord.WhoId = lead.Id;
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