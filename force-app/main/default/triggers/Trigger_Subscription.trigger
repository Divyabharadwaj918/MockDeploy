trigger Trigger_Subscription on SBQQ__Subscription__c (before insert, after insert, after update) {
    
    try{

        //After insert update condtion
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && SubscriptionTriggerHelper.By_Pass_SubscriptionTrigger == false){
            SubscriptionTriggerHelper.updateAmountOnContract(Trigger.new);
        }
    }
    catch(Exception exp){
        System.assert(false, exp.getMessage()+ ' At this line: '+exp.getLineNumber());
    }

}