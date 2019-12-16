trigger AccountOwnerChangeTrigger on Account (before update) {
    List<Account> accountForProcess = new List<Account>();
    Set<Id> ownerIds = new Set<Id>();
    
    
    for(Integer i=0; i<Trigger.new.size(); i++){
        if(Trigger.new[i].OwnerId!=Trigger.oldMap.get(Trigger.new[i].Id).OwnerId){
            accountForProcess.add(Trigger.new[i]);
            ownerIds.add(Trigger.oldMap.get(Trigger.new[i].Id).OwnerId);
            ownerIds.add(Trigger.new[i].OwnerId);
        }
    }
    
    ownerIds.add(UserInfo.getUserId());
    
    if(accountForProcess.size()>0){
        Map<Id,User> ownerMap = new Map<Id,User>([Select Id, UserRole.Name, Territory__c from User where Id in: ownerIds]);
        for(Integer i=0; i<accountForProcess.size(); i++){
                     
            if(ownerMap.get(UserInfo.getUserId()).UserRole.Name=='AE East' || ownerMap.get(UserInfo.getUserId()).UserRole.Name=='AE West'){                       
                
                if(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId!=UserInfo.getUserId()){
                    accountForProcess[i].addError('You cannot change the owner.');
                }
                else if(ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).Territory__c!=ownerMap.get(accountForProcess[i].OwnerId).Territory__c){
                    accountForProcess[i].addError('You cannot change the owner to a different territory.');
                }
            }
            
            if(ownerMap.get(UserInfo.getUserId()).UserRole.Name=='Regional Sales Manager East'){
                System.debug('--------1----------');
                if(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId!=accountForProcess[i].OwnerId){
                    if(ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).UserRole.Name!='AE East' &&
                        ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).UserRole.Name!='Regional Sales Manager East'){
                        accountForProcess[i].addError('You cannot change Account from other region.');
                    }                    
                    else if(ownerMap.get(accountForProcess[i].OwnerId).UserRole.Name!='AE East' && ownerMap.get(accountForProcess[i].OwnerId).UserRole.Name!='Regional Sales Manager East'){
                        accountForProcess[i].addError('You cannot change the owner to other region.');
                    }
                    else if(ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).Territory__c!=ownerMap.get(accountForProcess[i].OwnerId).Territory__c){
                       accountForProcess[i].addError('You cannot change the owner to a different territory.');
                    }
                }
            }
            
            if(ownerMap.get(UserInfo.getUserId()).UserRole.Name=='Regional Sales Manager West'){
                System.debug('--------1----------');
                if(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId!=accountForProcess[i].OwnerId){
                    if(ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).UserRole.Name!='AE West' &&
                        ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).UserRole.Name!='Regional Sales Manager West'){
                        accountForProcess[i].addError('You cannot change Account from other region.');
                    }                    
                    else if(ownerMap.get(accountForProcess[i].OwnerId).UserRole.Name!='AE West' && ownerMap.get(accountForProcess[i].OwnerId).UserRole.Name!='Regional Sales Manager West'){
                        accountForProcess[i].addError('You cannot change the owner to other region.');
                    }
                    else if(ownerMap.get(Trigger.oldMap.get(accountForProcess[i].Id).OwnerId).Territory__c!=ownerMap.get(accountForProcess[i].OwnerId).Territory__c){
                       accountForProcess[i].addError('You cannot change the owner to a different territory.');
                    }
                }
            }
        }
    }
}