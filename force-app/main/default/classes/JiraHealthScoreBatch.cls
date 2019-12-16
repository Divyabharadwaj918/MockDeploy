/**
* @author Pratibh Prakash
* @date 22-May-2017
* @description Batch Class processing Jira health scores
* @last modified by 
*/
global class JiraHealthScoreBatch implements Database.Batchable<sobject>{
	
  global Set<String> accIds = new Set<String>();
	
	//Constructor
	public JiraHealthScoreBatch(){}
	
	public JiraHealthScoreBatch(Set<String> accountIds){
		accIds.addAll(accountIds);
	}
	
	//Start Method	
	global Database.Querylocator start(Database.BatchableContext BC) {
		if(accIds.size()>0){
		  return Database.getQueryLocator([Select Id, Health_Score_Open_Bugs__c, Health_Score_Avg_Days_Open_Critical_Bugs__c, Health_Score_Avg_Days_Open_High_Bugs__c, 
													Open_Bugs__c, Open_Critical_Bugs__c, Total_Open_Days_of_Critical_Bugs__c, Open_High_Bugs__c, Total_Open_Days_of_High_Bugs__c,
													Health_Score_Open_FREQS_Critical_High__c, Health_Score_Avg_Days_Open_Critical_FREQ__c, Health_Score_Avg_Days_Open_High_FREQS__c,
													Open_Feature_Requests__c, Open_Critical_Feature_Reqs__c, Total_Open_Days_of_Critical_FREQS__c, Open_High_Feature_Reqs__c, Total_Open_Days_of_High_FREQS__c
													from Account where Id in:accIds]);
		}
		return Database.getQueryLocator([Select Id, Health_Score_Open_Bugs__c, Health_Score_Avg_Days_Open_Critical_Bugs__c, Health_Score_Avg_Days_Open_High_Bugs__c, 
												Open_Bugs__c, Open_Critical_Bugs__c, Total_Open_Days_of_Critical_Bugs__c, Open_High_Bugs__c, Total_Open_Days_of_High_Bugs__c,
												Health_Score_Open_FREQS_Critical_High__c, Health_Score_Avg_Days_Open_Critical_FREQ__c, Health_Score_Avg_Days_Open_High_FREQS__c,
												Open_Feature_Requests__c, Open_Critical_Feature_Reqs__c, Total_Open_Days_of_Critical_FREQS__c, Open_High_Feature_Reqs__c, Total_Open_Days_of_High_FREQS__c
												from Account]);
	}
	
	//Execute method
	global void execute (Database.BatchableContext BC, List<sobject> scope) {

      //Logic to sync the customer issue records with related Jira tickets.
      Set<Id> accountIds = new Set<Id>();
      for(Sobject tempObj: scope){
          Account tempAccObj = (Account)tempObj;
          accountIds.add(tempAccObj.Id);
      }
      Customer_Issue__c[] customerIssues = [Select Id from Customer_Issue__c where Account__c in:accountIds];
      //Firing DML to trigger field update to sync Customer Issue with associated Jira Ticket
      update customerIssues;

      Account[] accountsforProcessing = [Select Id, Health_Score_Open_Bugs__c, Health_Score_Avg_Days_Open_Critical_Bugs__c, Health_Score_Avg_Days_Open_High_Bugs__c, 
                                        Open_Bugs__c, Open_Critical_Bugs__c, Total_Open_Days_of_Critical_Bugs__c, Open_High_Bugs__c, Total_Open_Days_of_High_Bugs__c,
                                        Health_Score_Open_FREQS_Critical_High__c, Health_Score_Avg_Days_Open_Critical_FREQ__c, Health_Score_Avg_Days_Open_High_FREQS__c,
                                        Open_Feature_Requests__c, Open_Critical_Feature_Reqs__c, Total_Open_Days_of_Critical_FREQS__c, Open_High_Feature_Reqs__c, Total_Open_Days_of_High_FREQS__c
                                        from Account
                                        where Id in:accountIds];

		  //Retrieving matrices for Bugs Scores
		  Map<Integer,Integer> openBugsCritical_HighMatricesMap = new Map<Integer,Integer>();
		  Map<Integer,Integer> openBugsCriticalAvgDaysMatricesMap = new Map<Integer,Integer>();
		  Map<Integer,Integer> openBugsHighAvgDaysMatricesMap = new Map<Integer,Integer>();
  		openBugsCritical_HighMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Bug','Number of open bug tickets (ZT) that have priority CRITICAL and HIGH');
  		openBugsCriticalAvgDaysMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Bug','Average days where bug tickets (ZT) with priority CRITICAL are open');
  		openBugsHighAvgDaysMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Bug','Average days where bug tickets (ZT) with priority HIGH are open');

  		//Retrieving matrices for Feature Request Scores
  		Map<Integer,Integer> openFREQSCritical_HighMatricesMap = new Map<Integer,Integer>();
  		Map<Integer,Integer> openFREQSCriticalAvgDaysMatricesMap = new Map<Integer,Integer>();
  		Map<Integer,Integer> openFREQSHighAvgDaysMatricesMap = new Map<Integer,Integer>();
  		openFREQSCritical_HighMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Feature Request','Number of open feature request tickets (FREQS) that have priority CRITICAL and HIGH');
  		openFREQSCriticalAvgDaysMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Feature Request','Average days where feature request tickets (FREQS) with priority CRITICAL are open');
  		openFREQSHighAvgDaysMatricesMap = CustomerHealthScoreUtility.retrieveJiraScoreMatrixMap('Feature Request','Average days where feature request tickets (FREQS) with priority HIGH are open');

  		List<Account> accountsForUpdate = new List<Account>();
  		
  		System.debug('----------------openBugsCriticalAvgDaysMatricesMap='+openBugsCriticalAvgDaysMatricesMap);
  		System.debug('----------------openBugsHighAvgDaysMatricesMap='+openBugsHighAvgDaysMatricesMap);
  		
  		for(Account tempAccObj: accountsforProcessing){
  		  //Account tempAccObj = (Account)tempObj;

  			//Caculating Health Score for Bugs
  			tempAccObj.Health_Score_Open_Bugs__c =  0;
  			tempAccObj.Health_Score_Avg_Days_Open_Critical_Bugs__c =  0;
  			tempAccObj.Health_Score_Avg_Days_Open_High_Bugs__c =  0;
            System.debug('----------------tempAccObj.Open_Bugs__c='+tempAccObj.Open_Bugs__c);
            System.debug('-----------------openBugsCritical_HighMatricesMap='+openBugsCritical_HighMatricesMap);
  			if(openBugsCritical_HighMatricesMap.get((Integer)tempAccObj.Open_Bugs__c)!=null){
  			   tempAccObj.Health_Score_Open_Bugs__c = openBugsCritical_HighMatricesMap.get((Integer)tempAccObj.Open_Bugs__c);
  			}
  			System.debug('----------------tempAccObj.Total_Open_Days_of_Critical_Bugs__c='+tempAccObj.Total_Open_Days_of_Critical_Bugs__c);
  			System.debug('----------------tempAccObj.Open_Critical_Bugs__c='+tempAccObj.Open_Critical_Bugs__c);
  			if(tempAccObj.Open_Critical_Bugs__c==0){
  				tempAccObj.Health_Score_Avg_Days_Open_Critical_Bugs__c =  100;
  			}
  			if(tempAccObj.Open_Critical_Bugs__c>0 && openBugsCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c))!=null){
  				System.debug('----------(Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c)='+(Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c));
  				System.debug('----------openBugsCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c)'+openBugsCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c)));
  				tempAccObj.Health_Score_Avg_Days_Open_Critical_Bugs__c = openBugsCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_Bugs__c/tempAccObj.Open_Critical_Bugs__c));
  			}
  			System.debug('----------------tempAccObj.Total_Open_Days_of_High_Bugs__c='+tempAccObj.Total_Open_Days_of_High_Bugs__c);
  			System.debug('----------------tempAccObj.Open_High_Bugs__c='+tempAccObj.Open_High_Bugs__c);
  			if(tempAccObj.Open_High_Bugs__c==0){
  				tempAccObj.Health_Score_Avg_Days_Open_High_Bugs__c =  100;
  			}
  			if(tempAccObj.Open_High_Bugs__c>0 && openBugsHighAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_High_Bugs__c/tempAccObj.Open_High_Bugs__c))!=null){
  				tempAccObj.Health_Score_Avg_Days_Open_High_Bugs__c = openBugsHighAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_High_Bugs__c/tempAccObj.Open_High_Bugs__c));
  			}


  			 //Caculating Health Score for Feature Requests
			   tempAccObj.Health_Score_Open_FREQS_Critical_High__c =  0;
  			 tempAccObj.Health_Score_Avg_Days_Open_Critical_FREQ__c =  0;
  			 tempAccObj.Health_Score_Avg_Days_Open_High_FREQS__c =  0;
  			 if(openFREQSCritical_HighMatricesMap.get((Integer)tempAccObj.Open_Feature_Requests__c)!=null){
  				  tempAccObj.Health_Score_Open_FREQS_Critical_High__c = openFREQSCritical_HighMatricesMap.get((Integer)tempAccObj.Open_Feature_Requests__c);
  			 }
  			 if(tempAccObj.Open_Critical_Feature_Reqs__c==0){
  				  tempAccObj.Health_Score_Avg_Days_Open_Critical_FREQ__c =  100;
  			 }
  			 if(tempAccObj.Open_Critical_Feature_Reqs__c>0 && openFREQSCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_FREQS__c/tempAccObj.Open_Critical_Feature_Reqs__c))!=null){
  				  tempAccObj.Health_Score_Avg_Days_Open_Critical_FREQ__c = openFREQSCriticalAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_Critical_FREQS__c/tempAccObj.Open_Critical_Feature_Reqs__c));
  			 }
  			 if(tempAccObj.Open_High_Feature_Reqs__c==0){
  				  tempAccObj.Health_Score_Avg_Days_Open_High_FREQS__c =  100;
  			 }
  			 if(tempAccObj.Open_High_Feature_Reqs__c>0 && openFREQSHighAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_High_FREQS__c/tempAccObj.Open_High_Feature_Reqs__c))!=null){
  				  tempAccObj.Health_Score_Avg_Days_Open_High_FREQS__c = openFREQSHighAvgDaysMatricesMap.get((Integer)(tempAccObj.Total_Open_Days_of_High_FREQS__c/tempAccObj.Open_High_Feature_Reqs__c));
  			 }

          accountsForUpdate.add(tempAccObj);
  		}
  		
  		if(accountsForUpdate.size()>0){
  			Database.update(accountsForUpdate,false);
  		}
  	}
  
	//Finish Method
  	global void finish(Database.BatchableContext BC){
  		
  	}  		
  		
}