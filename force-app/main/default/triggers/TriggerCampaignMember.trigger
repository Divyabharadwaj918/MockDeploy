/**
* Description     -   Trigger on CampaignMember Object to update campaign field on account.
* 
* Created by      -   
* 
* Created Date    -   01/15/2019
*
* Revision log    -   V_1.0
*                   
*/
trigger TriggerCampaignMember on CampaignMember (after insert) {
    
    //Trigger run on insert and after event
    if(Trigger.isAfter && Trigger.isInsert){
        
        //Call helper class to update campaign field on account.
        CampaignMemberTriggerHelper.populateCampaign(Trigger.new);
    }
    
}