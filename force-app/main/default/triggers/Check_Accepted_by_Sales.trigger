trigger Check_Accepted_by_Sales on Lead (before update) {
    // Prevent the Accepted by Sales checkbox from being unchecked
    for(Lead l : Trigger.new) {
        Lead beforeUpdate = System.Trigger.oldMap.get(l.Id);  
        if( (l.accepted_by_sales__c == false) && (beforeUpdate.accepted_by_sales__c == true)){
            l.addError('Lead already accepted by sales. It is not allowed to undo it.');
            return;
        }
        else if( (l.accepted_by_sales__c == true) && (beforeUpdate.accepted_by_sales__c == false)){
            l.accepted_date__c = System.Today();
        }                    
    }
}