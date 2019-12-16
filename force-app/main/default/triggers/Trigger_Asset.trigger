trigger Trigger_Asset on Asset (before insert, after insert, after update) {

    try{

        //Condition for thr before insert
        if(Trigger.isBefore && Trigger.isInsert && !AssetTriggerHelper.bypassAssetTrigger){
            AssetTriggerHelper.updateContract(Trigger.New);
        }
        
        //After insert update condtion
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && AssetTriggerHelper.By_Pass_SubscriptionTrigger == false){
            AssettriggerHelper.updateAmountOnContract(Trigger.new);
        }
    }
    catch(Exception excpt){
        System.assert(false, excpt.getMessage()+ ' at this line : '+ excpt.getLineNumber());
    }
}