/**
*  Description     :   This trigger is used for task object.
*
*  Created By      :   
*
*  Created Date    :   29/05/2019
*
*  Revision Log    :   V_1.0 - Created 
*                      
**/
trigger Trigger_Task on Task (before insert, after insert, after update) {
 
    //Before Condtition
    if(Trigger.isBefore) {

        //Check for Insert and update case
        if(Trigger.isInsert || Trigger.isUpdate){
        
        	//Trigger Helper Method Calling
        	TaskTriggerHelper.updateRecordType_SellerSalesOnTask(Trigger.New, Trigger.oldMap);
        }
    }
    
    //After Condtition
    if(Trigger.isAfter && Trigger.isInsert){
        
        //Trigger Helper Method Calling
        TaskTriggerHelper.sendNotification(Trigger.New);
    }
    
    //Check After condition.
    if(Trigger.isAfter){
        
        //check insert and update event.
        if(Trigger.isInsert || Trigger.isUpdate)
            TaskTriggerHelper.createTaskStatusTrackingRecord(Trigger.new, Trigger.oldMap);
    }
}