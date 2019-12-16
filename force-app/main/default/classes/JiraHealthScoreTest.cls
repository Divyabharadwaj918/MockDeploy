@isTest
private class JiraHealthScoreTest
{
	@isTest
	static void testHealthScore()
	{
		//Creating Account
		List<Account> accountsForInsert = new List<Account>();
		Account testAccount1 = new Account(Name='Test Account', BillingCountry='US');
		accountsForInsert.add(testAccount1);
		Account testAccount2 = new Account(Name='Sample Account', BillingCountry='US');
		accountsForInsert.add(testAccount2);
		insert accountsForInsert;

		//Creating Jira to SF Mapping
		Jira_to_SF_Mapping__c testMapping = new Jira_to_SF_Mapping__c(Name='Test Account', Account__c=testAccount1.Id);
		insert testMapping;

		//Insert Jira Issue to initiate trigger "AssociateJira_withAccount"
		List<JiraIssue__c> jiraIssueForInsert = new List<JiraIssue__c>();
		JiraIssue__c testJiraIssue1 = new JiraIssue__c();
		testJiraIssue1.Affected_customers_suppliers__c='Test';
		testJiraIssue1.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue1.Priority__c = 'Crtical';
		testJiraIssue1.Status__c = 'Open';
		testJiraIssue1.Type__c ='BUG';
		jiraIssueForInsert.add(testJiraIssue1);

		JiraIssue__c testJiraIssue2 = new JiraIssue__c();
		testJiraIssue2.Affected_customers_suppliers__c='Test';
		testJiraIssue2.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue2.Priority__c = 'High';
		testJiraIssue2.Status__c = 'Open';
		testJiraIssue1.Type__c ='BUG';
		jiraIssueForInsert.add(testJiraIssue2);

		JiraIssue__c testJiraIssue3 = new JiraIssue__c();
		testJiraIssue3.Affected_customers_suppliers__c='Test';
		testJiraIssue3.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue3.Priority__c = 'Crtical';
		testJiraIssue3.Status__c = 'Open';
		testJiraIssue3.Type__c ='Feature Request';
		jiraIssueForInsert.add(testJiraIssue3);

		JiraIssue__c testJiraIssue4 = new JiraIssue__c();
		testJiraIssue4.Affected_customers_suppliers__c='Test';
		testJiraIssue4.Date_Created__c = Datetime.now().addMonths(-1);
		testJiraIssue4.Priority__c = 'High';
		testJiraIssue4.Status__c = 'Open';
		testJiraIssue4.Type__c ='Feature Request';
		jiraIssueForInsert.add(testJiraIssue4);

		insert jiraIssueForInsert;
		

		//Creating Health Score Matrix
		List<Jira_Heath_Score_Matrix__c> matricesForInsert = new List<Jira_Heath_Score_Matrix__c>();
		Jira_Heath_Score_Matrix__c open_criticalBugs = new Jira_Heath_Score_Matrix__c(Criteria_Type__c='Number of open bug tickets (ZT) that have priority CRITICAL and HIGH',Criteria_Value__c=2,Health_Score__c=90,Type__c='Bug');
		matricesForInsert.add(open_criticalBugs);
		Jira_Heath_Score_Matrix__c open_criticalFREQS = new Jira_Heath_Score_Matrix__c(Criteria_Type__c='Number of open feature request tickets (FREQS) that have priority CRITICAL and HIGH',Criteria_Value__c=2,Health_Score__c=90,Type__c='Feature Request');
		matricesForInsert.add(open_criticalFREQS);
		insert matricesForInsert;

		CustomerHealthScoreUtility.calculateJiraHealthScore(null);

		Test.startTest();
			CustomerHealthScoreUtility.calculateJiraHealthScore(new Set<String>{testAccount1.Id});
		Test.stopTest();
		String hour = String.valueOf(Datetime.now().hour());
		String min = String.valueOf(Datetime.now().minute() + 1);
		String ss = String.valueOf(Datetime.now().second());

		//parse to cron expression

		String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

		CustomerHealthScheduler s = new CustomerHealthScheduler(); 
		System.schedule('Health Job ' + String.valueOf(Datetime.now()), nextFireTime, s);

	}
}