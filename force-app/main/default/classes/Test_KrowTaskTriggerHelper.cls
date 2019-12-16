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
*   Description     :   This class is used to insert invoices and add coverage in trigger's methods .
*
*   Created by      :   
*
*   Created Date    :   03/01/2019
*
*   Revision Log    :   V1.0 - Created
*  
*   Coverage        :  100%
**/
@isTest(seeAllData = false)
public class Test_KrowTaskTriggerHelper {
    
    @isTest static void test_AssignEnggQueue() {

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        insert u;
        
        Test.startTest();
        
        //List to hold multiple instances of Account
        List<Account> accs = new List<Account>();
        
        accs.add(new Account(Name='Test_Acc1', BillingCountry = 'United States'));
        accs.add(new Account(Name='Test_Acc2', BillingCountry = 'United States'));
        insert accs;
        
        //List to hold mutiple instances of Project__c 
        List<Krow__Project__c> projects = new List<Krow__Project__c>();
        projects.add(new Krow__Project__c(Name='Test Project1', Krow__Account__c =accs[0].Id, SIPM__c = u.Id));
        projects.add(new Krow__Project__c(Name='Test Project2', Krow__Account__c =accs[1].Id, SIPM__c = u.Id));
        insert projects;
        
        List<Krow__Task__c> krowtasks = new List<Krow__Task__c>();
        krowtasks.add(new Krow__Task__c(Name='Send full data set to Engineering', Krow__Project__c=projects[0].Id, Krow__Milestone__c= true));
        krowtasks.add(new Krow__Task__c(Name='Assign engineer or reject', Krow__Project__c=projects[1].Id, Krow__Milestone__c= true));
        insert krowtasks;
        
        //Fetched specific Queue
        List<Group> queue = [Select Id, Name From Group Where Type = 'Queue' AND Name= 'Engineering'];  
        
        krowtasks[0].Krow__Status__c = 'Completed';
        update krowtasks[0];
        
        List<Krow__Project__c> projectsUpdated = [Select Id, OwnerId, Name, Krow__Project_Status__c From Krow__Project__c];
        List<Krow__Task__c> tasksUpdated = [Select Id, OwnerId, Name From Krow__Task__c];
        
        //System.assertEquals(queue[0].Id, projectsUpdated[0].OwnerId);
        //System.assertEquals('Complete', projectsUpdated[0].Krow__Project_Status__c);
        //System.assertEquals(queue[0].Id, tasksUpdated[0].OwnerId);
        
        krowtasks[1].Krow__Status__c = 'Completed';
        update krowtasks[1];
        
        List<Krow__Project__c> projectsUpdated_New = [Select Id, OwnerId, Name, Krow__Project_Status__c From Krow__Project__c];
        List<Krow__Task__c> tasksUpdated_New = [Select Id, OwnerId, Name From Krow__Task__c];
        
        //System.assertEquals(queue[0].Id, projectsUpdated_New[1].OwnerId);
        //System.assertEquals('Complete', projectsUpdated_New[1].Krow__Project_Status__c);
        //System.assertEquals(queue[0].Id, tasksUpdated_New[1].OwnerId);
        
        
        Test.stopTest();
    } 
}