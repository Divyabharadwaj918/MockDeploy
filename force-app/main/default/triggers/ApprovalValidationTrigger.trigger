trigger ApprovalValidationTrigger on Krow__Timesheet__c (after update) {

    for(Integer i=0; i<Trigger.new.size(); i++){
        
        if(Trigger.oldMap.get(Trigger.new[i].Id).Krow__Approval_Status__c!=Trigger.new[i].Krow__Approval_Status__c &&
            Trigger.new[i].Krow__Approval_Status__c=='Approved'
            && Trigger.new[i].Krow__Project_Owner__c !=UserInfo.getUserId()){
            
            Trigger.new[i].addError('You cannot approve timesheet as you are not manager.');
        }       
        
    }
}