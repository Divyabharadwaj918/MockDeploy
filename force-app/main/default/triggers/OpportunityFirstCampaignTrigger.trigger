trigger OpportunityFirstCampaignTrigger on Opportunity (before insert, before update) {
    
    
    Set<Id> primaryContactIds = new Set<Id>();
    List<Opportunity> opportunityForProcess = new List<Opportunity>();
    
    if(Trigger.isInsert){
        for(Integer i=0; i<Trigger.new.size(); i++){
            if(Trigger.new[i].Primary_Contact__c!=null){
                primaryContactIds.add(Trigger.new[i].Primary_Contact__c);
                opportunityForProcess.add(Trigger.new[i]);
            }
        }
    }
    if(Trigger.isUpdate){
        for(Integer i=0; i<Trigger.new.size(); i++){
            System.debug('----------------Converted_Lead_Id__c='+Trigger.new[i].Converted_Lead_Id__c);
            if(Trigger.new[i].Primary_Contact__c!=null && Trigger.new[i].Primary_Contact__c != Trigger.oldMap.get(Trigger.new[i].Id).Primary_Contact__c){
                primaryContactIds.add(Trigger.new[i].Primary_Contact__c);
                opportunityForProcess.add(Trigger.new[i]);
            }
        }
    }
    
    if(primaryContactIds.size()>0){
        CampaignMember[] campaignMembers = [Select Id, ContactId, leadId,CampaignId 
                                                from CampaignMember
                                                where ContactId in: primaryContactIds
                                                order by CreatedDate ASC];
        
        Map<String,List<CampaignMember>> contactCampaignMemberMap = new Map<String,List<CampaignMember>>();
        
        for(Integer i=0; i<campaignMembers.size(); i++){
            if(!contactCampaignMemberMap.containsKey(campaignMembers[i].ContactId)){
                contactCampaignMemberMap.put(campaignMembers[i].ContactId, new List<CampaignMember>());
            }
            contactCampaignMemberMap.get(campaignMembers[i].ContactId).add(campaignMembers[i]);            
        }
        
        for(Integer i=0; i<opportunityForProcess.size(); i++){
            opportunityForProcess[i].First_Campaign__c = null;
            if(contactCampaignMemberMap.get(opportunityForProcess[i].Primary_Contact__c)!=null){
                opportunityForProcess[i].First_Campaign__c = contactCampaignMemberMap.get(opportunityForProcess[i].Primary_Contact__c)[0].CampaignId;
            }
        }
    
    }
    
    
}