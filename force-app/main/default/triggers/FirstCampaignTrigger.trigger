trigger FirstCampaignTrigger on CampaignMember (after insert) {
    
    //Set<Id> primaryContactIds = new Set<Id>();
    Map<Id,Id> primaryContact_CampaignMap = new Map<Id,Id>();
    List<Opportunity> opportunityForUpdate = new List<Opportunity>();
    
    for(Integer i=0; i<Trigger.new.size(); i++){
        if(Trigger.new[i].ContactId != null && Trigger.new[i].LeadId==null){
            //primaryContactIds.add(Trigger.new[i].ContactId);
            primaryContact_CampaignMap.put(Trigger.new[i].ContactId,Trigger.new[i].CampaignId);
        }
    }
    
    Opportunity[] primaryContactOpportunities = [Select Id, First_Campaign__c, Primary_Contact__c
                                                    from Opportunity
                                                    where Primary_Contact__c in: primaryContact_CampaignMap.keySet()];
            
    if(primaryContactOpportunities.size()>0){
        for(Integer i=0; i<primaryContactOpportunities.size(); i++){
            if(primaryContact_CampaignMap.get(primaryContactOpportunities[i].Primary_Contact__c)!=null){
                primaryContactOpportunities[i].First_Campaign__c= primaryContact_CampaignMap.get(primaryContactOpportunities[i].Primary_Contact__c);
                opportunityForUpdate.add(primaryContactOpportunities[i]);
            }
            
        }
        
        if(opportunityForUpdate.size()>0){
            update opportunityForUpdate;
        }
    }
}