public class JiraUtility {
	
	@future
	public static void associateJiraWithCustomers(Set<String> jiraIds){
		
		//Retrieving Jira Issues
		JiraIssue__c[] jiraIssues = [Select Id, Name, Affected_customers_suppliers__c 
										from JiraIssue__c
										where Id in: jiraIds];
		
		Map<String, List<String>> jiraAffectedCustomer_AccountMap = new Map<String, List<String>>();//Map to store affected customer value and corresponding list of Account Ids
		jiraAffectedCustomer_AccountMap.put('all', new List<String>());//"all" value to store list of the Accounts in order to associate tickets with All Accounts which have Affected Customers = All
		
		//Populating Map
		Jira_to_SF_Mapping__c[] jira2SFMappings = [Select Id, Name, Account__c from Jira_to_SF_Mapping__c];//Retrieve Jira to SF Mappings
		for(Integer i=0; i<jira2SFMappings.size(); i++){
			if(!jiraAffectedCustomer_AccountMap.containsKey(jira2SFMappings[i].Name)){
				jiraAffectedCustomer_AccountMap.put(jira2SFMappings[i].Name.toLowerCase(), new List<String>());
			}
			jiraAffectedCustomer_AccountMap.get(jira2SFMappings[i].Name.toLowerCase()).add(jira2SFMappings[i].Account__c);
			jiraAffectedCustomer_AccountMap.get('all').add(jira2SFMappings[i].Account__c);
		}
		
		
		List<Customer_Issue__c> customerIssuesForInsert = new List<Customer_Issue__c>();
		for(Integer i=0; i<jiraIssues.size(); i++){
			//Mapping Jira with Affected Customers = All to all the Accounts			
			if(jiraIssues[i].Affected_customers_suppliers__c.trim().equalsIgnoreCase('all')){
				for(String accId: jiraAffectedCustomer_AccountMap.get('all')){
					Customer_Issue__c tempObj = new Customer_Issue__c(Name = jiraIssues[i].Name, Account__c=accId, Jira_Issue__c=jiraIssues[i].Id);
		    		customerIssuesForInsert.add(tempObj);
				}
			}
			else{//Mapping Jira to specific Account as per Affected Customers value
				if(jiraIssues[i].Affected_customers_suppliers__c.trim().split(';').size()>0){
					for(String affectedCustomerKey: jiraIssues[i].Affected_customers_suppliers__c.trim().split(';')){
						if(jiraAffectedCustomer_AccountMap.get(affectedCustomerKey.trim().toLowerCase())!=null){
							for(String accId: jiraAffectedCustomer_AccountMap.get(affectedCustomerKey.trim().toLowerCase())){
								Customer_Issue__c tempObj = new Customer_Issue__c(Name = jiraIssues[i].Name, Account__c=accId, Jira_Issue__c=jiraIssues[i].Id);
			    				customerIssuesForInsert.add(tempObj);
							}
						}
					}
				}
			}		   
		}
		
		//Inserting Jira and Account associations
		if(customerIssuesForInsert.size()>0){
			insert customerIssuesForInsert;	
		}
	}

	public static void updateCustomerIssues(Set<Id> jiraIds){
		Customer_Issue__c[] customerIssues = [Select Id from Customer_Issue__c where Jira_Issue__c in:jiraIds];

		//Executing UPDATE on customer issues object which will trigger Process on Customer Issues to sync data from Jira to Customer Issue record
		if(customerIssues.size()>0){
		update customerIssues;
		}
	}
}