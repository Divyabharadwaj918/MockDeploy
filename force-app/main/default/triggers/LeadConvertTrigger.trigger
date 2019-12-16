trigger LeadConvertTrigger on Lead (after update) {
    
    System.debug('----------IN LEAD CONVERT---------');
    List<Opportunity> oppForUdpate = new List<Opportunity>();
    Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
    Set<Id> leadsIdsForProcess = new Set<Id>();
    Set<Id> contactIdsForProcess = new Set<Id>();

    for(Integer i=0; i<Trigger.new.size(); i++){    
        if(Trigger.new[i].IsConverted==true){
            leadsIdsForProcess.add(Trigger.new[i].Id);
            contactIdsForProcess.add(Trigger.new[i].ConvertedContactId);
            System.debug('-------------Trigger.new[i].ConvertedOpportunityId='+Trigger.new[i].ConvertedOpportunityId);
            
            if(Trigger.new[i].ConvertedOpportunityId!=null){
                opportunityMap.put(Trigger.new[i].ConvertedContactId, new Opportunity(Id=Trigger.new[i].ConvertedOpportunityId,Primary_Contact__c=Trigger.new[i].ConvertedContactId,Converted_Lead_Id__c=null));
            }
        }
    }
    
    if(leadsIdsForProcess.size()>0){        
        if(opportunityMap.size()>0){
            update opportunityMap.values();
        }
        
    }
}