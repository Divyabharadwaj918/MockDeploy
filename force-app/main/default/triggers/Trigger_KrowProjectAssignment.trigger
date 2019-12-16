/**
* Description     -   This trigger is used to insert invoices 
* 
* Created by      -   
* 
* Created Date    -  2/12/2019
*
* Revision log    -   Created
*                   
*/
trigger Trigger_KrowProjectAssignment on Krow__Project_Assignment__c (after insert, after Update) {

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
			KrowProjectAssignmentTriggerHelper.changeProjectStatus(Trigger.new, Trigger.oldMap);
			KrowProjectAssignmentTriggerHelper.changeProjectOwnerToUser(Trigger.new, Trigger.oldMap);
            KrowProjectAssignmentTriggerHelper.updateTIEandSIPM(Trigger.new, Trigger.oldMap);
            //KrowProjectAssignmentTriggerHelper.sendNotificationToProjectResource(Trigger.newMap);
        }
    }
}