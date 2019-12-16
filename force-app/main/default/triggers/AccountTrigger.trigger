/**
* @author Pratibh Prakash
* @date 20-April-2017
* @description Account Trigger to perform operation on insert/update events.
* @last modified by 
*/
trigger AccountTrigger on Account (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
    	List<Account> accountsForBandwidthHistory = new List<Account>();
    	
    	for(Integer i=0; i<Trigger.new.size(); i++){
    		
    		//Logic to check if any of Integration Bandwidth fields are changed.
    		if((Trigger.new[i].Start_Date__c != Trigger.oldMap.get(Trigger.new[i].Id).Start_Date__c && Trigger.oldMap.get(Trigger.new[i].Id).Start_Date__c!=null )||
    			(Trigger.new[i].End_Date__c != Trigger.oldMap.get(Trigger.new[i].Id).End_Date__c && Trigger.oldMap.get(Trigger.new[i].Id).End_Date__c!=null) ||
    			(Trigger.new[i].Bandwidth__c != Trigger.oldMap.get(Trigger.new[i].Id).Bandwidth__c && Trigger.oldMap.get(Trigger.new[i].Id).Bandwidth__c!=null)){
    			
    			accountsForBandwidthHistory.add(Trigger.oldMap.get(Trigger.new[i].Id));
    		}
    	}
    	
    	if(accountsForBandwidthHistory.size()>0){
    		AccountUtility.createIntegrationHistory(accountsForBandwidthHistory);
    	}
    }
}