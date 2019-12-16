/**
 *  Purpose         :   This trigger is to handle all the pre and post processing operations for Krow project object
 *
 *  Create By       :   
 *
 *  Created Date    :   02/01/2019
 *
 *  Revision Logs   :   Created
 *                      Updated -04/02/2019- Called a new method "syncProjectStatusHistory"
 * 
 * */

trigger Trigger_KrowProject on Krow__Project__c (after Insert, after Update, before Insert, before Update) {

    try {
        //Check for request Type
        if(Trigger.isAfter) {
            
            //Check for event type.
            if(Trigger.isInsert){
                KrowProjectTriggerHelper.createBuyerSellerRelationship(Trigger.new);

            }
    
            //Check for event type
            if(Trigger.isUpdate) {
                //Call helper
                KrowProjectTriggerHelper.createKrowProjectTemplate(Trigger.new, Trigger.oldMap);

            }
    
            //Check for event type
            if(Trigger.isInsert || Trigger.isUpdate) {
                //Call helper
                KrowProjectTriggerHelper.createNewKrowTask(Trigger.new, Trigger.oldMap);
                //Call helper
                KrowProjectTriggerHelper.syncProjectHistory(Trigger.new, Trigger.oldMap);
            }
        }
        //Check for request Type
        if(Trigger.isBefore) {
            
            //Check for Event Type
            if(Trigger.isInsert || Trigger.isUpdate ) {
    
                //Call helper
                KrowProjectTriggerHelper.updateQueuedStatusOnKrowProject(Trigger.new, Trigger.oldMap);
                KrowProjectTriggerHelper.updatedParentSellerBuyerAccountOnKrowProject(Trigger.new, Trigger.oldMap);
            }
        }
    }
    //Catching DML Exceptions
    catch(DMLException e) {
        //Add Error Message on Page
        if(Trigger.isDelete)
            Trigger.Old[0].addError(e.getDmlMessage(0));
        else {
            if(e.getDmlMessage(0).contains('Krow.KrowTaskTrigger: data changed by trigger for field Project Owner: id value of incorrect type')){
                Trigger.New[0].addError('Project Owner value of incorrect type');
            }
            else
                Trigger.New[0].addError(e.getDmlMessage(0));
        }
    }
}