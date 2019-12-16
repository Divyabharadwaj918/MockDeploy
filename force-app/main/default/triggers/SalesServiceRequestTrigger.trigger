trigger SalesServiceRequestTrigger on Sales_Service_Request__c (after insert, before update, after update) {
    
    if(Trigger.isInsert){
        SalesServiceRequestHelper.copyPartnersFromOpportunity(Trigger.newMap.keySet());
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        Map<Id, RecordType> salesServiceRecordTypes = SalesServiceRequestHelper.retrieveRecordTypes('Sales_Service_Request__c');
        //Filtering records
        for(Integer i=0; i<Trigger.new.size(); i++){
            if(Trigger.new[i].Status__c=='Submitted' && Trigger.new[i].Status__c!=Trigger.oldMap.get(Trigger.new[i].Id).Status__c){
                Trigger.new[i].Standard_Target_Completion_Date__c = SalesServiceRequestHelper.AddBusinessDays(Trigger.new[i].Submitted_Date__c,5);                
            }
            if(Trigger.new[i].Status__c=='Rejected' && Trigger.new[i].Status__c!=Trigger.oldMap.get(Trigger.new[i].Id).Status__c){
                Trigger.new[i].Expedite__c = false;
                Trigger.new[i].Request_Date__c =  null;
                Trigger.new[i].Standard_Target_Completion_Date__c = null;
            }
            if(Trigger.new[i].Status__c=='Complete' && Trigger.new[i].Status__c!=Trigger.oldMap.get(Trigger.new[i].Id).Status__c){
                Trigger.new[i].Completion_Date__c = Date.today();               
            }
            if(Trigger.new[i].Status__c=='Complete' && (Trigger.new[i].Request_Date__c!=null || Trigger.new[i].Standard_Target_Completion_Date__c!=null) && Trigger.new[i].Completion_Date__c!=null){
                Date startDate = Trigger.new[i].Standard_Target_Completion_Date__c;
                if(Trigger.new[i].Request_Date__c!=null){
                    startDate = Trigger.new[i].Request_Date__c;
                }
                Trigger.new[i].of_business_days__c = SalesServiceRequestHelper.getWorkingDays(startDate,Trigger.new[i].Completion_Date__c);
            }
        }
    }
    if(Trigger.isAfter){
        List<KrowUtility.KrowWrapper> krowWrpList = new List<KrowUtility.KrowWrapper>();
        Set<Id> requestsForProcessIds = new Set<Id>();
        
        
        //Filtering records
        for(Integer i=0; i<Trigger.new.size(); i++){
            if(Trigger.new[i].Status__c=='Accepted' && Trigger.new[i].Status__c!=Trigger.oldMap.get(Trigger.new[i].Id).Status__c){
                requestsForProcessIds.add(Trigger.new[i].Id);
            }
        }
        
        //Processing Filtered Records
        if(requestsForProcessIds.size()>0){
            Sales_Service_Request__c[] requestForProcecss = [Select Opportunity__c, Opportunity__r.Name, Opportunity__r.AccountId, Opportunity__r.OwnerId, 
                                                                    LastModifiedDate, CreatedById, OwnerId 
                                                                from Sales_Service_Request__c
                                                                where Id in:requestsForProcessIds];
                                                                
            for(Integer i=0; i<requestForProcecss.size(); i++){
                KrowUtility.KrowWrapper wrpObj = new KrowUtility.KrowWrapper();
                wrpObj.opportunityId = requestForProcecss[i].Opportunity__c;
                wrpObj.projectName = requestForProcecss[i].Opportunity__r.Name;
                wrpObj.projectOwnerId = TradeshiftGlobalSettings__c.getOrgDefaults().Default_Project_Manager__c;
                wrpObj.startDate = date.newinstance(requestForProcecss[i].LastModifiedDate.year(), requestForProcecss[i].LastModifiedDate.month(), requestForProcecss[i].LastModifiedDate.day());
                wrpObj.accountId = requestForProcecss[i].Opportunity__r.AccountId;
                wrpObj.accountExecutiveId = requestForProcecss[i].Opportunity__r.OwnerId;
                wrpObj.serviceAccountManagerId = UserInfo.getUserId();
                wrpObj.solutionConsultantId = requestForProcecss[i].CreatedById;
                krowWrpList.add(wrpObj);
            }
            
            KrowUtility.createKrowProjects(krowWrpList);
        }
    }
    
}