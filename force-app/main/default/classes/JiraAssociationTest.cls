@isTest
private class JiraAssociationTest {
	
	@isTest 
	static void testJiraAssociation() {
		/* 
		Creating Mock data
		*/

		//Creating Account
		Account testAccount = new Account(Name='Test Account', BillingCountry='US');
		insert testAccount;

		//Creating Jira to SF Mapping
		Jira_to_SF_Mapping__c testMapping = new Jira_to_SF_Mapping__c(Name='Test', Account__c=testAccount.Id);
		insert testMapping;

		//Insert Jira Issue to initiate trigger "AssociateJira_withAccount"
		List<JiraIssue__c> jiraIssueForInsert = new List<JiraIssue__c>();
		JiraIssue__c testJiraIssue1 = new JiraIssue__c();
		testJiraIssue1.Affected_customers_suppliers__c='Test';
		testJiraIssue1.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue1.Priority__c = 'Crtical';
		testJiraIssue1.Status__c = 'Open';
		jiraIssueForInsert.add(testJiraIssue1);

		JiraIssue__c testJiraIssue2 = new JiraIssue__c();
		testJiraIssue2.Affected_customers_suppliers__c='all';
		testJiraIssue2.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue2.Priority__c = 'Crtical';
		testJiraIssue2.Status__c = 'Open';
		jiraIssueForInsert.add(testJiraIssue2);
		insert jiraIssueForInsert;

		//Update the Jira Issue to initiate the update event of trigger "AssociateJira_withAccount"
		testJiraIssue1.Priority__c = 'High';
		update testJiraIssue1;

	}
	
	
	
}