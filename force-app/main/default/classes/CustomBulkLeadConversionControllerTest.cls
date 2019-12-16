/**
 *    Description     :        Test class of CustomBulkLeadConversionController class.
 *
 *    Created By      :        
 *
 *    Created Date    :        30/08/2017
 *
 *    Revision Logs   :        V_1.0 - Created
 *                      
 **/
@isTest(seeAllData = false)
private class CustomBulkLeadConversionControllerTest
{

    static testMethod void testLeadConversion(){
        Test.startTest();
        
        Id recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Lead' AND IsActive = true LIMIT 1].Id;

        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName = 'Test', LastName='Lead', Phone='123456789', Email='Test@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='12345',LeadSource ='NEW' ,Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead', Phone='123456789', Email='Test@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123456',LeadSource ='NEW',Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead', Phone='123456789', Email='Test@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123457',LeadSource ='NEW',Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead', Phone='123456789', Email='Test@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123458',LeadSource ='NEW',Trigger__c='Sales'));
        
        //insert lead record.
        insert leads;
        
        CustomBulkLeadConversionController.WrapObjects wrap = new CustomBulkLeadConversionController.WrapObjects();
        //incorrect lead id.
        wrap = CustomBulkLeadConversionController.convertLeads('RecordId');
        system.assertEquals(wrap.message, 'Incorrect Lead Id');
        
        wrap = CustomBulkLeadConversionController.convertLeads(leads[0].Id);
        system.assert(wrap.acc != null);
        system.assert(wrap.con != null);
        system.assert(wrap.oppwrapper != null);
        system.assert(wrap.oppList != null);
        system.assertEquals(wrap.message, 'Lead is converted successfully');
        system.assert(wrap.error == null);
        system.assertEquals(4, wrap.oppList.size());
        
        Test.stopTest();
    }    
    
    static testMethod void testLeadConvertForExistingAccCon(){
        Test.startTest();
        
        Id recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Account' AND IsActive = true LIMIT 1].Id;
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'USA';
        acc.RecordTypeId = recordTypeId;
        acc.TS_ID__c = '12345';
        
        //insert account record.
        insert acc;
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Contact' AND IsActive = true LIMIT 1].Id;

        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'lead record';
        con.Email = 'Test1@gmail.com';
        con.AccountId = acc.Id;
        con.Phone = '123456789';
        con.RecordTypeId =recordTypeId;
        insert con;
        
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Lead' AND IsActive = true LIMIT 1].Id;
        
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName = 'Test', LastName='Lead record', Phone='123456789', Email='Test1@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='12345',LeadSource ='NEW' ,Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead record', Phone='123456789', Email='Test1@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123456',LeadSource ='NEW' ,Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead record', Phone='123456789', Email='Test1@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123457',LeadSource ='NEW' ,Trigger__c='Sales'));
        leads.add(new Lead(FirstName = 'Test', LastName='Lead record', Phone='123456789', Email='Test1@gmail.com', RecordTypeId = recordTypeId, company='Tradeshift', TS_ID__c='123458',LeadSource ='NEW' ,Trigger__c='Sales'));
        
        //insert lead record.
        insert leads;
        
        CustomBulkLeadConversionController.WrapObjects wrap = new CustomBulkLeadConversionController.WrapObjects();
        //incorrect lead id.
        wrap = CustomBulkLeadConversionController.convertLeads('RecordId');
        system.assertEquals(wrap.message, 'Incorrect Lead Id');
        
        wrap = CustomBulkLeadConversionController.convertLeads(leads[0].Id);
        system.assert(wrap.acc != null);
        system.assert(wrap.con != null);
        system.assert(wrap.oppwrapper != null);
        system.assert(wrap.oppList != null);
        system.assertEquals(wrap.message, 'Lead is converted successfully');
        system.assert(wrap.error == null);
        system.assertEquals(4, wrap.oppList.size());
        
        Test.stopTest();
    }
}