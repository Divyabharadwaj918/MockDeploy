/**
* Description     -   TriggerHelper class on CampaignMemberTrigger
* 
* Created by      -   
* 
* Created Date    -   01/15/2019
*
* Revision log    -   V_1.0
*                   
*/

public without sharing class CampaignMemberTriggerHelper {
    
    /**
     * @ desription    :    This method is used to update campaign on account.
     *
     * @ args          :    List<CampaignMember>
     *
     * @ return        :    void
     **/
    public static void populateCampaign(List<CampaignMember> campaignMembers){
        
        //Set to store contact Ids
        Set<Id> conIds = new Set<Id>();
        
        //To store multiple instances of account object
        Map<Id,Account> accountsTobeUpdated = new Map<Id,Account>();
        
        //Loop iterate for each campaign member
        for(CampaignMember campaignMember : campaignMembers){
            
            //Check for CampaignId and ContactId are not equal to null
            if(campaignMember.CampaignId != null && campaignMember.ContactId != null){
                
                //Add contact Id into set
                conIds.add(campaignMember.ContactId);
                
            }
        }
        
        //Check for size
        if(conIds.size() > 0){
            
            //Map to store contactId as key and contact as value in map
            Map<Id,Contact> contactIdWithContactMap = new Map<Id,Contact>([SELECT ID , AccountId FROM Contact WHERE ID IN :conIds AND AccountId != null]);
            
            //Loop iterate for each campaign member
            for(CampaignMember campaignMember : campaignMembers){
                
                //Check for contactIdWithContactMap and contains in map
                if(contactIdWithContactMap != null && contactIdWithContactMap.size() > 0 && contactIdWithContactMap.containsKey(campaignMember.ContactId)){
                    
                    //To store account id related to campaign member
                    Id accId = contactIdWithContactMap.get(campaignMember.ContactId).AccountId;
                    
                    //Add account in list to update campaign field on account object
                    Account acc= new Account(Id = accId ,Campaign__c = campaignMember.CampaignId);

                    //Checck for map
                    if(!accountsTobeUpdated.containsKey(accId))
                        accountsTobeUpdated.put(accId,acc);
                }   
            }
        }

        //Check for size
        if(accountsTobeUpdated.size() > 0)
            //Dml On account to update
            update accountsTobeUpdated.values();
        
    }
}