/**
* @author Pratibh Prakash
* @date 7-Sep-2017
* @description Test class for AccountReportController
* @last modified by 
*/
@isTest
private class AccountReportController_Test {

    static testMethod void testAccountReportController() {
        // Creating Mock data
        Account testAccount = new Account(Name='Test Account', Type='Enterprise Customer', BillingCountry='United Kingdom', Live_Countries__c='United Kingdom;Denmark', Implementation_Countries__c='United Kingdom;Denmark', Road_mapped_Countries__c='United Kingdom;Denmark', Future_Interest_Countries__c='United Kingdom;Denmark');
        insert testAccount;
        
        List<ISO_Countries__c> isoCountryForInsert = new List<ISO_Countries__c>();
        ISO_Countries__c country_UK = new ISO_Countries__c(Name='United Kingdom', ISO_2_Char_Code__c='GB', ISO_3_Char_Code__c='GBR');
        isoCountryForInsert.add(country_UK);
        ISO_Countries__c country_DK = new ISO_Countries__c(Name='Denmark', ISO_2_Char_Code__c='DK', ISO_3_Char_Code__c='DNK');
        isoCountryForInsert.add(country_DK);
        insert isoCountryForInsert;
        
        List<String> countries = AccountReportController.retrieveCountries();
        AccountReportController.retrieveAccounts(countries);
        AccountReportController.retrieveCountriesCodes();
    }
}