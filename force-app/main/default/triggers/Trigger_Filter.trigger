trigger Trigger_Filter on Filter__c (before insert, before update ,before delete) {
    if(trigger.isbefore){
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete){
            if(FilterTriggerHelper.isTrigger ==  false){
                system.debug('FilterTriggerHelper' +FilterTriggerHelper.isTrigger);
                FilterTriggerHelper.updateDefaultFilter(trigger.new, trigger.old);

            }
        }
    }
}