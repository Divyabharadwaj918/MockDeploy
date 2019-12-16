/**
* @author Pratibh Prakash
* @date 25-April-2017
* @description Test class for AccountUtility class
* @last modified by 
*/
@isTest
private class AccountUtilityTest {

    static testMethod void test_createIntegrationHistory() {
        // Creating Mock Data
        Account acc = new Account(Name='Test Account', BillingCountry = 'US', Start_Date__c=Date.today().addYears(1), End_Date__c=Date.today(), Bandwidth__c=30);
        insert acc;
        
        // Initiating tests: Update Integration Bandwidth fields
        acc.Start_Date__c = acc.Start_Date__c.addDays(1);
        update acc;
        acc.End_Date__c = acc.End_Date__c.addDays(1);
        update acc;
        acc.Bandwidth__c = 50;
        update acc;
        
    }
}