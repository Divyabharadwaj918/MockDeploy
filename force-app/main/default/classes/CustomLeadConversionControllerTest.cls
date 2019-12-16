/**
 *    Description     :        Test class of CustomLeadConversionController class.
 *
 *    Created By      :        
 *
 *    Created Date    :        20/08/2017
 *
 *    Revision Logs   :        V_1.0 - Created
 *                      
 **/
@isTest(seeAllData = false)
private class CustomLeadConversionControllerTest {
	
    static testMethod void testConverLead(){
        Id recordTypeId;
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Account' AND IsActive = true LIMIT 1].Id;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'USA';
        acc.RecordTypeId = recordTypeId;
        //insert account record.
        insert acc;
      
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Lead' AND IsActive = true LIMIT 1].Id;
        
        Lead leadRecord = new Lead();
        leadRecord.firstName = 'Test';
        leadRecord.LastName = 'lead conversion';
        leadRecord.Email = 'TestEmail@gmail.com';
        leadRecord.Status = 'NEW';
        leadRecord.Company = 'Tradeshift';
        leadRecord.Country = 'USA';
        leadRecord.TS_ID__c = '123456789';
        leadRecord.Phone = '123456123';
        leadRecord.Trigger__c='Sales';
        leadRecord.LeadSource ='NEW';
        leadRecord.RecordTypeId = recordTypeId;
        leadRecord.Division_Override__c = 'APAC';
        
        //insert lead record.
        insert leadRecord;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRecord);
        CustomLeadConversionController controller = new CustomLeadConversionController(sc);
        
        system.assertEquals(leadRecord.Id, controller.leadRecord.Id);
        
        //call convertLeadMethod.
        controller.convertLead();
        system.assertEquals('success', controller.result);
        system.assert(controller.accountInfo != null);
        system.assert(controller.contactInfo != null);
        system.assert(controller.opportunityInfo != null); 
        
        //call back button method.
        controller.backToLeadRecord();
    }
    
     static testMethod void testLeadConvertExists(){
        Id recordTypeId;
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Account' AND IsActive = true LIMIT 1].Id;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'USA';
        acc.RecordTypeId = recordTypeId;
        acc.TS_ID__c = '123456789';
        //insert account record.
        insert acc;
      
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Contact' AND IsActive = true LIMIT 1].Id;
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'lead conversion2';
        con.Email = 'TestEmail@gmail.com';
        con.AccountId = acc.Id;
        con.Phone = '123456123';
        con.RecordTypeId =recordTypeId;
        insert con;
        system.debug('con='+con);
        recordTypeId = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Lead' AND IsActive = true LIMIT 1].Id;
        
        Lead leadRecord = new Lead();
        leadRecord.firstName = 'Test';
        leadRecord.LastName = 'lead conversion';
        leadRecord.Email = 'TestEmail@gmail.com';
        leadRecord.Status = 'NEW';
        leadRecord.Company = 'Tradeshift';
        leadRecord.Country = 'USA';
        leadRecord.TS_ID__c = '123456789';
        leadRecord.Phone = '123456123';
        leadRecord.Trigger__c='Sales';
        leadRecord.LeadSource ='NEW';
        leadRecord.RecordTypeId = recordTypeId;

        
        //insert lead record.
        insert leadRecord;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRecord);
        CustomLeadConversionController controller = new CustomLeadConversionController(sc);
        
        system.assertEquals(leadRecord.Id, controller.leadRecord.Id);
         //call convertLeadMethod.
        controller.convertLead();
         system.assertEquals('success', controller.result);
        system.assertEquals(controller.accountInfo.Id, acc.Id);
    }
}