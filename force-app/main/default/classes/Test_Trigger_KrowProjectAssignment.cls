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
*   Description     :   This class is used to cover KrowProjectAssignmentTriggerHelper class
*
*   Created by      :   
*
*   Created Date    :   2/21/2019
*
*   Revision Log    :   V1.0 - Created
*  
*   Coverage        :  
**/
@isTest(SeeAllData=false)
public class Test_Trigger_KrowProjectAssignment {
    
    /* 
    *   Description     :   Test method used to create test data.
    *
    *   @argument       :       
    *Krow__Project_Status__c
    *   Revision Logs   :   V_1.0 - Created
    */
    @testSetup static void testData(){
        //Create krow project record.
        List<Krow__Project__c> listOfKrowProject = new List<Krow__Project__c>();
        listOfKrowProject.add(new Krow__Project__c(Name = 'TestRecord1', Krow__Project_Status__c = 'Queued for SIPM'));
        listOfKrowProject.add(new Krow__Project__c(Name = 'TestRecord2', Krow__Project_Status__c = 'Queued for SIPM'));
        listOfKrowProject.add(new Krow__Project__c(Name = 'TestRecord3', Krow__Project_Status__c = 'Queued for SIPM'));
        listOfKrowProject.add(new Krow__Project__c(Name = 'TestRecord4', Krow__Project_Status__c = 'Queued for SIPM'));
        
        insert listOfKrowProject;
        
        //Create krow role record.
        List<Krow__Krow_Role__c> listOfKrowRoles = new List<Krow__Krow_Role__c>();
        listOfKrowRoles.add(new Krow__Krow_Role__c(Name = 'SIPM (Seller Integration Project Manager)', Krow__Active__c = true));
        listOfKrowRoles.add(new Krow__Krow_Role__c(Name = 'SIE (Seller Integration Engineer)', Krow__Active__c = true));
        insert listOfKrowRoles;
        
        //Create testUser
        User testUser = new User(
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
        insert testUser;
        
        //create project resource record.
        List<Krow__Project_Resources__c> listOfProjectResource = new List<Krow__Project_Resources__c>();
        listOfProjectResource.add(new Krow__Project_Resources__c(Name = 'TestProjectResource', Krow__Project_Role__c = listOfKrowRoles[0].Id, Krow__User__c = testUser.Id));
        insert listOfProjectResource;
        
        //Create project Assignement record.
        List<Krow__Project_Assignment__c> listOfProjectAssignment = new List<Krow__Project_Assignment__c>();
        listOfProjectAssignment.add(new Krow__Project_Assignment__c(Krow__Krow_Project__c = listOfKrowProject[0].Id, Krow__Role__c = listOfKrowRoles[0].Id, Krow__Project_Resource__c = listOfProjectResource [0].Id, Krow__IsOwner__c = true, Krow__User__c = testUser.Id));
        listOfProjectAssignment.add(new Krow__Project_Assignment__c(Krow__Krow_Project__c = listOfKrowProject[1].Id, Krow__Role__c = listOfKrowRoles[1].Id, Krow__Project_Resource__c = listOfProjectResource [0].Id, Krow__IsOwner__c = true, Krow__User__c = testUser.Id));
        listOfProjectAssignment.add(new Krow__Project_Assignment__c(Krow__Krow_Project__c = listOfKrowProject[2].Id, Krow__Role__c = listOfKrowRoles[0].Id, Krow__Project_Resource__c = listOfProjectResource [0].Id, Krow__IsOwner__c = true, Krow__User__c = testUser.Id));
        listOfProjectAssignment.add(new Krow__Project_Assignment__c(Krow__Krow_Project__c = listOfKrowProject[3].Id, Krow__Role__c = listOfKrowRoles[1].Id, Krow__Project_Resource__c = listOfProjectResource [0].Id, Krow__IsOwner__c = true, Krow__User__c = testUser.Id));
        
        insert listOfProjectAssignment;
        
    }
    
    /* 
    *   Description     :   Test method to cover changeProjectStatus method.
    *
    *   @argument       :       
    *
    *   Revision Logs   :   V_1.0 - Created
    */
    
     static testMethod void test_changeProjectStatus(){
        
        Test.startTest();
        
        //Query updated krow project record.
        List<Krow__Project__c> listOfUpdatedKrowProject = [SELECT Id, Name, Krow__Project_Status__c FROM Krow__Project__c ORDER BY Name ASC];
        
        //Assert for project no.
        System.assertEquals(4, listOfUpdatedKrowProject.size());
        
        //Asserts for updated status
        System.assertEquals('Lead', listOfUpdatedKrowProject[0].Krow__Project_Status__c);
        System.assertEquals('Lead', listOfUpdatedKrowProject[1].Krow__Project_Status__c);
        System.assertEquals('Lead', listOfUpdatedKrowProject[2].Krow__Project_Status__c);
        System.assertEquals('Lead', listOfUpdatedKrowProject[3].Krow__Project_Status__c);
        
        Test.stopTest(); 
    }
    
    static testMethod void test_changeProjectOwnerToUser(){
        Test.startTest();
            
        //Query user
        User testUser = [SELECT Id, Username  FROM User where username like '%puser000@amamama.com%' limit 1];
        
        //Query updated krow project record.
        List<Krow__Project__c> listOfUpdatedKrowProject = [SELECT Id, Name, Krow__Project_Status__c, OwnerId FROM Krow__Project__c ORDER BY Name ASC];
        
        //Assert for project no.
        System.assertEquals(4, listOfUpdatedKrowProject.size());
        
        //Asserts for updated status
        System.assertEquals(testUser.Id , listOfUpdatedKrowProject[0].OwnerId);
        System.assertEquals(testUser.Id, listOfUpdatedKrowProject[1].OwnerId);
        System.assertEquals(testUser.Id, listOfUpdatedKrowProject[2].OwnerId);
        System.assertEquals(testUser.Id, listOfUpdatedKrowProject[3].OwnerId);
        
        Test.stopTest();
    }
}