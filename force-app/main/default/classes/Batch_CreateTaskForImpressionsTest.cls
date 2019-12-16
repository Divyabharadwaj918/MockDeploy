/**
* This class contains unit tests for validating the behavior of Apex classes
and triggers.

Unit tests are class methods that verify whether a particular piece
of code is working properly. Unit test methods take no arguments,
commit no data to the database, and are flagged with the testMethod
keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
to a production organization to confirm correctness, ensure code
coverage, and prevent regressions. All Apex classes are
required to have at least 75% code coverage in order to be deployed
to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
methods. Classes defined with the @isTest annotation do not count against
the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
/**
*   Description     :   This class is used to cover the Batch_CreateTaskForImpressionsAndClick class .
*
*   Created by      :   
*
*   Created Date    :   25/05/2019
*
*   Revision Log    :   V1.0 - Created
*  
*   Coverage        :  94%
**/
@isTest(seeAllData = false)
public class Batch_CreateTaskForImpressionsTest {
		
	/**
    *  @description    :   This method is test setup method.
    *
    *  @args           :   
    *
    *  @return         :   void
    * 
    **/
	@testSetup
	static void testData(){
		
		//List to insert contact records.
		List<Contact> listOfContacts = new List<Contact>();
		
		listOfContacts.add(new Contact(LastName = 'Contact-1', LeadSource = 'DOMO', adroll__Impressions__c = 2000, adroll__Clicks__c = 20));
		listOfContacts.add(new Contact(LastName = 'Contact-2', LeadSource = 'DOMO', adroll__Impressions__c = 5000, adroll__Clicks__c = 30));
		listOfContacts.add(new Contact(LastName = 'Contact-3', LeadSource = 'DOMO', adroll__Impressions__c = 2000, adroll__Clicks__c = 5));
		listOfContacts.add(new Contact(LastName = 'Contact-4', LeadSource = 'DOMO', adroll__Impressions__c = 10000, adroll__Clicks__c = 50));
		listOfContacts.add(new Contact(LastName = 'Contact-5', LeadSource = 'DOMO', adroll__Impressions__c = 6000, adroll__Clicks__c = 60));
		listOfContacts.add(new Contact(LastName = 'Contact-6', LeadSource = 'DOMO', adroll__Impressions__c = 2000, adroll__Clicks__c = 80));
		listOfContacts.add(new Contact(LastName = 'Contact-7', LeadSource = 'DOMO', adroll__Impressions__c = 500000, adroll__Clicks__c = 200));
		listOfContacts.add(new Contact(LastName = 'Contact-8', LeadSource = 'DOMO', adroll__Impressions__c = 600, adroll__Clicks__c = 40));
		listOfContacts.add(new Contact(LastName = 'Contact-9', LeadSource = 'DOMO', adroll__Impressions__c = 2000, adroll__Clicks__c = 0));
		
		//insert contacts.
		insert listOfContacts;
        
        List<Task> taskToInsert = new List<Task>();
        taskToInsert.add(new Task(subject = 'Paid Digital- 500 Ad Impressions', WhoId = listOfContacts[2].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
        taskToInsert.add(new Task(subject = 'Paid Digital- 1 Ad Click', WhoId = listOfContacts[2].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
    
        insert taskToInsert;
	}
    
    /**
    *  @description    :   This method is used to test task creation.
    *
    *  @args           :   
    *
    *  @return         :   void
    * 
    **/
    static testMethod void testBatchFunctionality(){
        
        Test.startTest();
        	
        //Run batch class.
        Batch_CreateTaskForImpressionsAndClick btc = new Batch_CreateTaskForImpressionsAndClick('Contact');
        
        Database.executeBatch(btc);
        
        Test.stopTest();
        
        //Query list of contacts
        List<Contact> contacts = [Select Id, Name, adroll__Impressions__c, adroll__Clicks__c From Contact Order by LastName ASC];
       
        //List to query created task records.
        Integer NoOfCreatedTasks = [Select Count() From Task Where WhoId = :contacts[0].Id AND Subject like '%Ad Impressions%'];
        
        //Check assert
        System.assertEquals(4, NoOfCreatedTasks);
        
        NoOfCreatedTasks = [Select Count() From Task Where WhoId = :contacts[0].Id AND Subject like '%Ad Click%'];
        System.assertEquals(20, NoOfCreatedTasks);
        
         //List to query created task records.
        NoOfCreatedTasks = [Select Count() From Task Where WhoId = :contacts[6].Id AND Subject like '%Ad Impressions%'];
        
        //Check assert
        System.assertEquals(100, NoOfCreatedTasks);
        
        NoOfCreatedTasks = [Select Count() From Task Where WhoId = :contacts[6].Id AND Subject like '%Ad Click%'];
        System.assertEquals(100, NoOfCreatedTasks);
    }
}