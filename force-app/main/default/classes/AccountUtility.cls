/**
* @author Pratibh Prakash
* @date 20-April-2017
* @description Utility Class contains helper methods for processing related to Account
* @last modified by 
*/
public with sharing class AccountUtility {
    
    /*
    * Method to record Integration Bandwidth History
    */
    public static void createIntegrationHistory(List<Account> accountList){
    	
    	List<Integration_Bandwidth_History__c> bandwidthHistoryForInsert = new List<Integration_Bandwidth_History__c>();
    	
    	for(Integer i=0; i<accountList.size(); i++){
    		Integration_Bandwidth_History__c tempObj = new Integration_Bandwidth_History__c();
    		tempObj.Start_Date__c = accountList[i].Start_Date__c;
    		tempObj.End_Date__c = accountList[i].End_Date__c;
    		tempObj.Bandwidth__c = accountList[i].Bandwidth__c;
    		tempObj.Account__c = accountList[i].Id;
    		tempObj.User__c = UserInfo.getUserId();
    		tempObj.Type__c = 'History';
    		bandwidthHistoryForInsert.add(tempObj);
    	}
    	
    	if(bandwidthHistoryForInsert.size()>0){
    		insert bandwidthHistoryForInsert;
    	}
    }
}