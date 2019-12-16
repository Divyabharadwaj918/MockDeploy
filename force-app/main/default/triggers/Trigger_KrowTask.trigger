/**
* Description     -     This trigger is to handle all the pre and post processing operations for Krow Task object
* 
* Created by      -   
* 
* Created Date    -     12/02/2019
*
* Revision log    -     Created
*                       Updated - 10/04/2019
*                   
*/
trigger Trigger_KrowTask on Krow__Task__c (after insert, after update) {

        //Check for Request Event
        if(Trigger.isAfter) {

            //Check fro Event Type
            if(Trigger.isInsert || Trigger.isUpdate) {
            
                //Call helper
                KrowTaskTriggerHelper.assignEnggQueue(Trigger.new, Trigger.oldMap);
                KrowTaskTriggerHelper.updateLastMilestoneOnKrowProject(Trigger.new, Trigger.oldMap);
                KrowTaskTriggerHelper.preventPrecedingMilestoneToBeCompleted(Trigger.new, Trigger.oldMap);
                KrowTaskTriggerHelper.syncProjectHistory(Trigger.new, Trigger.oldMap);
        } 
        
          //SOT-165
          if(Trigger.isInsert){
            //Call helper
            krowTaskTriggerHelper.maintainOrderOfKrowTask(Trigger.new);
          }
    }
}