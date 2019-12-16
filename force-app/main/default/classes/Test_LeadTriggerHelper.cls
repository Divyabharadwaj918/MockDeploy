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
*   Description     :   This class is used to cover LeadTriggerHelper class
*
*   Created by      :   
*
*   Created Date    :   1/31/2019
*
*   Revision Log    :   V1.0 - Created
*  
*   Coverage        :  100%
**/
@isTest(SeeAllData=false)
public class Test_LeadTriggerHelper {
   /* 
    *   Description     :   Test method to cover LeadTriggerHelper.
    *
    *   @argument       :       
    *
    *   Revision Logs   :   V_1.0 - Created
    */
    @isTest static void testing_assignLeadsToQueue() {
        
        //Fetching queue and users data
        List<Group> queues = [Select Id, Name From Group Where Type = 'Queue' AND Name ='Unassigned Leads Queue'];
        
        //Creating Lead records
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i<=4; i++) {
             leads.add(new lead(LastName='Test lead '+i, Company='Test Company '+i, Status='Open', Title='Test Title '+i, LeadSource='Marketing',
                                RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard Lead').getRecordTypeId(),
                                Marketo_Campaign__c = 'Test Campaign'+i, OwnerId = queues[0].Id));
        }
        insert leads;

        //Testing scope starts from here
        Test.startTest();
        
        leads[0].Segment__c = 'Mid-market';
        leads[0].Re_route_lead__c = true;
        
        leads[1].Size__c = '16-99 Employees';
        leads[1].Re_route_lead__c = true;
        
        leads[2].Country = 'England';
        leads[2].AnnualRevenue = 1000000000;
        leads[2].Re_route_lead__c = true;
               
        leads[3].Country = 'UK';
        leads[3].Industry = 'Oil';
        leads[3].Re_route_lead__c = true;
        
        leads[4].Country = 'UK';
        leads[4].Industry = 'Consumer Manaufacturing';
        leads[4].Re_route_lead__c = true;
                
        List<Lead> lds1 = new List<Lead>();
        for(Integer i=0;i<=4;i++) {
            lds1.add(leads[i]);
        }    
        if(lds1.size() > 0) {
           update lds1; 
        }  
        
        List<Lead> ld = [Select Id, OwnerId, Re_route_lead__c From Lead];
        List<Group> queues1 = [Select Id, Name From Group Where Type = 'Queue' AND Name ='Mid-Market Queue'];
        
        //Assertion for first lead, checkbox should be unchecked and owner should be changed and would be assigned as Mid-Market Queue
        System.assertEquals(false, ld[0].Re_route_lead__c);
        System.assertNotEquals(queues[0].Id, ld[0].OwnerId);
        
        System.assertEquals(false, ld[0].Re_route_lead__c);
        System.assertEquals(queues1[0].Id, ld[0].OwnerId);
        
        //Assertion for second lead, checkbox should be unchecked and owner should be changed and would be assigned as Mid-Market Queue
        System.assertEquals(false, ld[1].Re_route_lead__c);
        System.assertEquals(queues1[0].Id, ld[1].OwnerId);
        
        //Testing scope ends here
        Test.stopTest();
    }
    
    /**
    *  @description    :   This method is used to test task creation.
    *
    *  @args           :   
    *
    *  @return         :   void
    * 
    **/
    static testMethod void testCreateTaskForImpression(){
        //List to insert contact records.
        List<Lead> leadToInsert = new List<Lead>();
        leadToInsert.add(new Lead(LastName = 'Lead1', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        leadToInsert.add(new Lead(LastName = 'Lead2', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        leadToInsert.add(new Lead(LastName = 'Lead3', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        leadToInsert.add(new Lead(LastName = 'Lead4', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        leadToInsert.add(new Lead(LastName = 'Lead5', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        leadToInsert.add(new Lead(LastName = 'Lead6', LeadSource='Alliances', Company='Test Company', Title='Test Title'));
        
        insert leadToInsert;
        
        List<Task> taskToInsert = new List<Task>();
        taskToInsert.add(new Task(subject = 'Paid Digital- 500 Ad Impressions', WhoId = leadToInsert[1].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
        taskToInsert.add(new Task(subject = 'Paid Digital- 1 Ad Click', WhoId = leadToInsert[1].Id, ActivityDate = date.Today(), Type = 'Other', Status = 'Completed', Priority = 'Normal'));
    
        insert taskToInsert;
        
        Test.startTest();
        
        //List to update contact records.
        List<Lead> LeadToUpdate = [Select Id, adroll__Impressions__c, adroll__Clicks__c From Lead order by LastName ASC];
        
        LeadToUpdate[0].adroll__Impressions__c = 2000;LeadToUpdate[0].adroll__Clicks__c = 10;
        LeadToUpdate[1].adroll__Impressions__c = 2050;LeadToUpdate[1].adroll__Clicks__c = 20;
        LeadToUpdate[2].adroll__Impressions__c = 1000;LeadToUpdate[2].adroll__Clicks__c = 50;
        LeadToUpdate[3].adroll__Impressions__c = 55000;LeadToUpdate[3].adroll__Clicks__c = 110;
        LeadToUpdate[4].adroll__Impressions__c = 10000;LeadToUpdate[4].adroll__Clicks__c = 20;
       
        update leadToUpdate;
        
        List<Lead> leads = [Select Id, adroll__Impressions__c, adroll__Clicks__c From Lead order by LastName ASC];
        
        Integer totalImpressionTask = [Select count() From Task Where whoId = :leads[0].Id AND Subject like '%Ad Impressions%'];
        system.assertEquals(4, totalImpressionTask);
        
        Test.stopTest();
    }
}