/**
 *  Purpose         :   This trigger is to handle all the pre and post processing operations for Contact object
 *
 *  Create By       :   
 *
 *  Created Date    :   20/05/2019
 *
 *  Revision Logs   :   Created
 * 
 * */
trigger Trigger_Contact on Contact (before insert, before update, after update) {
    
    //check request type
    if(trigger.isAfter){
        
        //check event type
        if(trigger.isUpdate)
            ContactTriggerHelper.createTaskForImpression(trigger.new, trigger.oldMap);
    }
}