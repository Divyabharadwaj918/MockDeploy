trigger AssociateJira_withAccount on JiraIssue__c (after insert, after update) {
    
    if(Trigger.isInsert && Trigger.isAfter){
	    Set<String> jiraForProcessing = new Set<String>();
	    
	    //Filtering Data
	    for(Integer i=0; i<Trigger.new.size(); i++){
	    	if(Trigger.new[i].Affected_customers_suppliers__c!=null && Trigger.new[i].Affected_customers_suppliers__c!=''){
	    		jiraForProcessing.add(Trigger.new[i].Id);
	    	}
	    }
	    
	    //Processing tickets which has Affected Customers populated
	    JiraUtility.associateJiraWithCustomers(jiraForProcessing);
    }
    if(Trigger.isUpdate){
    	JiraUtility.updateCustomerIssues(Trigger.newMap.keySet());
    }
}