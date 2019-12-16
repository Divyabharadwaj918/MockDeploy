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
*   Description     :   This class is used to cover the contact trigger's methods .
*
*   Created by      :   
*
*   Created Date    :   21/05/2019
*
*   Revision Log    :   V1.0 - Created
*  
*   Coverage        :  100%
**/
@isTest(seeAllData = false)
public class ContactTriggerHelperTest {
    
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
        List<Contact> contactToInsert = new List<Contact>();
        contactToInsert.add(new Contact(LastName = 'Contact1', LeadSource='DOMO'));
        contactToInsert.add(new Contact(LastName = 'Contact2', LeadSource='DOMO'));
        contactToInsert.add(new Contact(LastName = 'Contact3', LeadSource='DOMO'));
        contactToInsert.add(new Contact(LastName = 'Contact4', LeadSource='DOMO'));
        contactToInsert.add(new Contact(LastName = 'Contact5', LeadSource='DOMO'));
        contactToInsert.add(new Contact(LastName = 'Contact6', LeadSource='DOMO'));
        
        insert contactToInsert;
        
        List<Task> taskToInsert = new List<Task>();
        taskToInsert.add(new Task(subject = 'Paid Digital- 500 Ad Impressions', WhoId = contactToInsert[1].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
        taskToInsert.add(new Task(subject = 'Paid Digital- 1 Ad Click', WhoId = contactToInsert[1].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
    
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
    
    public static testMethod void testCreateTaskForImpression(){
        Test.startTest();
        
        //List to update contact records.
        List<Contact> contactToUpdate = [Select Id, adroll__Impressions__c, adroll__Clicks__c From Contact order by LastName ASC];
        
        contactToUpdate[0].adroll__Impressions__c = 2000;contactToUpdate[0].adroll__Clicks__c = 10;
        contactToUpdate[1].adroll__Impressions__c = 2050;contactToUpdate[1].adroll__Clicks__c = 20;
        contactToUpdate[2].adroll__Impressions__c = 1000;contactToUpdate[2].adroll__Clicks__c = 50;
        contactToUpdate[3].adroll__Impressions__c = 55000;contactToUpdate[3].adroll__Clicks__c = 110;
        contactToUpdate[4].adroll__Impressions__c = 10000;contactToUpdate[4].adroll__Clicks__c = 20;
       
        update contactToUpdate;
        
        List<Contact> contacts = [Select Id, adroll__Impressions__c, adroll__Clicks__c From Contact order by LastName ASC];
        
        Integer totalImpressionTask = [Select count() From Task Where whoId = :contacts[0].Id AND Subject like '%Ad Impressions%'];
        system.assertEquals(4, totalImpressionTask);
        
        Test.stopTest();
    }
}