/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 * 
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData = false)
private class Test_KrowProjectWithKrowTaskClone {
    /**
    *   Description     :   Testing for KrowProjectWithKrowTaskClone
    *
    *   Created by      :   
    *
    *   Created Date    :   02/06/2019
    *
    *   Revision Log    :   
    *
    *   Code Coverage   :   100%
    **/ 
   /**
    *   Description     :   This method is used to insert common data
    *
    *   @args           :   
    *
    *   @return type    :   Void
    *
    *   @Revision Log   :   Created
    **/
    static testMethod void testclonekrowProject() {
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
        //List to hold Krow Project
        List<Krow__Project__c> projects = new List<Krow__Project__c>();

        //Add record to list
        projects.add(new Krow__Project__c(Name='Krow_project-1',sipm__c = u.id));
        projects.add(new Krow__Project__c(Name='Krow_project-1',sipm__c = u.id));
        projects.add(new Krow__Project__c(Name='Krow_project-2',sipm__c = u.id));
        projects.add(new Krow__Project__c(Name='Krow_project-2',sipm__c = u.id));
        projects.add(new Krow__Project__c(Name='Krow_project-3',sipm__c = u.id));
        projects.add(new Krow__Project__c(Name='Krow_project-3',sipm__c = u.id)); 

        //Insert Project
        insert projects;

        //List to hold Krow Project Template Task
        List<Krow__Task__c> parentTasks = new List<Krow__Task__c>();

        //Add record to list
        parentTasks.add(new Krow__Task__c(Name='Task-1',Krow__Project__c = projects[0].Id));

        //Insert parentTasks
        insert parentTasks;

        //List to hold Krow Project Template Task
        List<Krow__Task__c> childTasks = new List<Krow__Task__c>();

        //Add record to list
        childTasks.add(new Krow__Task__c(Name='Task-1',Krow__Project__c = projects[0].Id, Krow__Parent_Task__c =parentTasks[0].Id));

        //Insert parentTasks
        insert childTasks;

        //Testing start here
        Test.startTest(); 
        
        //Standard controller       
        ApexPages.StandardController sc = new ApexPages.standardController(projects[0]);
        
        //Controller
        KrowProjectWithKrowTaskCloneController controller = new KrowProjectWithKrowTaskCloneController(sc);

        //Call controller method
        controller.clonekrowProject();

        //Projects
        List<Krow__Project__c> krowProjects = [Select Id From Krow__Project__c];

        //Tasks
        List<Krow__Task__c> krowTasks = [Select Id From Krow__Task__c where Krow__Project__c !=null];
        
        //Assert
        System.assertEquals(7, krowProjects.size());
        System.assertEquals(4, krowTasks.size());
        
        //Testing stop here
        Test.stopTest();
    }
}