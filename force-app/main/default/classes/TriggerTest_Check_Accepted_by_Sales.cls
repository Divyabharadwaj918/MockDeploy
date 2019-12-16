public with sharing class TriggerTest_Check_Accepted_by_Sales {
 
    static TestMethod void testOwnerLink() {
 
        // Create a Lead
        Lead l1 = new Lead();
        l1.firstname = 'foo';
        l1.lastname = 'foo';
        l1.Status = 'Open';
        l1.company = 'Test Company';
        l1.email = 'xyz@gmail.com';
        l1.title = 'Other';
        l1.country = 'USA';
        l1.Job_Function__c = 'Other';
        l1.LeadSource='Alliances';
        
        insert l1;
 
        // Test: accepted_by_sales__c should be false
        Lead l2 = [select id, accepted_by_sales__c from Lead where Id = :l1.Id];
        System.assertEquals(l2.accepted_by_sales__c, false);
        l2.accepted_by_sales__c = true;

        update l2;
 
        // Test: accepted_by_sales__c should be true
        Lead l3 = [select id, accepted_by_sales__c from Lead where Id = :l2.Id];
        System.assertEquals(l3.accepted_by_sales__c, true);

        try {
            l3.accepted_by_sales__c = false;       
            update l3;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Lead already accepted by sales.'));
        }
    }
}