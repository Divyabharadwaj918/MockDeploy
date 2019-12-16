/**
* @author Pratibh Prakash
* @date 24-May-2017
* @description Utility Class contains helper methods for calculating various Heath Score based on Jira, Zendesk etc
* @last modified by 
*/
public class CustomerHealthScoreUtility {

    public static void calculateJiraHealthScore(Set<String> accountIds){
    	if(accountIds!=null && accountIds.size()>0){
    		Database.executeBatch(new JiraHealthScoreBatch(accountIds), 200);
    	}
    	else{
    		Database.executeBatch(new JiraHealthScoreBatch(), 200);
    	}
    }
    
    public static Map<Integer,Integer> retrieveJiraScoreMatrixMap(String scoreType, String criteriaType){
        System.debug('-------scoreType'+scoreType);
        System.debug('-------criteriaType'+criteriaType);
    	Jira_Heath_Score_Matrix__c[] jiraHealthMatrices = [Select Id, Criteria_Value__c, Health_Score__c
    														from Jira_Heath_Score_Matrix__c
    														where Type__c=:scoreType
    														and Criteria_Type__c=:criteriaType];
    	
    	Map<Integer,Integer> tempMap = new Map<Integer, Integer>();
    	
    	for(Integer i=0; i<jiraHealthMatrices.size(); i++){
    		tempMap.put((Integer)jiraHealthMatrices[i].Criteria_Value__c, (Integer)jiraHealthMatrices[i].Health_Score__c);
    	}
    	
    	return tempMap;
    }
}