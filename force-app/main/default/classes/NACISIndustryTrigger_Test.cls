/**
* @author Pratibh Prakash
* @date 16-Aug-2018
* @description 
*/
@isTest
public class NACISIndustryTrigger_Test {
    private static testMethod void testNACISIndustryTrigger(){
        Industry_Mapping__c testIndustry = new Industry_Mapping__c(Industry__c='Test Industry');
        insert testIndustry;
        
        NAICS_Range__c testRange = new NAICS_Range__c(Industry_Mapping__c=testIndustry.Id, NAICS_Code_Lower__c=20, NAICS_Code_Upper__c=30);
        insert testRange;
        
        Lead testLead = new Lead(FirstName='Test First Name', LastName='Test Last Name', Company='Test Company', LeadSource='Alliances',Trigger__c='Alliances',Country='US',NAICS_Code__c=10);
        insert testLead;
        
        testLead.NAICS_Code__c=20;
        update testLead;
    }
}