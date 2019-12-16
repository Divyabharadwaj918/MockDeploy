/**
* Description     -   This trigger is used to assign owner to lead
* 
* Created by      -   
* 
* Created Date    -  
*
* Revision log    -   
*                   
*/
trigger Trigger_Lead on Lead (after update) {
    if(Trigger.isAfter){
        
        if(Trigger.isUpdate)
            LeadTriggerHelper.createTaskForImpression(Trigger.new, Trigger.oldMap);
        if(Trigger.isUpdate && !LeadTriggerHelper.byPassTrigger){
            LeadTriggerHelper.LeadAssign(Trigger.new, Trigger.oldMap);
        }
    }
}