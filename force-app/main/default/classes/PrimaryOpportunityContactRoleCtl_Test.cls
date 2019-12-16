/**
* @author Pratibh Prakash
* @date 30-July-2018
* @description 
*/
@isTest
public class PrimaryOpportunityContactRoleCtl_Test {
    private static testMethod void testPrimaryContactRole(){
        //Creating Mock Data
        Account testAccount = new Account(Name='Test', BillingCountry='US');
        insert testAccount;
        
        List<Contact> contactForInsert = new List<Contact>();
        Contact testContact1 = new Contact(FirstName='Test First Name 1', LastName='Test Last Name 1', AccountId=testAccount.Id, LeadSource='Alliances');
        contactForInsert.add(testContact1);
        Contact testContact2 = new Contact(FirstName='Test First Name 2', LastName='Test Last Name 2', AccountId=testAccount.Id, LeadSource='Alliances');
        contactForInsert.add(testContact2);        
        insert contactForInsert;
        
        Campaign testCampaign = new Campaign(Name='Test Campaign');
        insert testCampaign;
        
        CampaignMember testCampaignMember1 = new CampaignMember(ContactId=testContact1.Id, CampaignId=testCampaign.Id, Status='Sent');
        insert testCampaignMember1;
        
        Opportunity testOpp = new Opportunity(Name='Test', AccountId=testAccount.Id, Primary_Contact__c=testContact1.Id,LeadSource='Alliances',Trigger__c='Alliances',StageName='1 - Identify',CloseDate=Date.today()+10);
        insert testOpp;
        
        OpportunityContactRole testRole = new OpportunityContactRole(OpportunityId=testOpp.Id, ContactId=testContact2.Id, IsPrimary=true);
        insert testRole;
        
        /*
        ** Initiating tests
        */
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
        //Initiating Constructor
        PrimaryOpportunityContactRoleController ctlObj = new PrimaryOpportunityContactRoleController(sc);
        ctlObj.populatePrimaryContact();
        
        CampaignMember testCampaignMember2 = new CampaignMember(ContactId=testContact2.Id, CampaignId=testCampaign.Id, Status='Sent');
        insert testCampaignMember2;
    }
    
    private static testMethod void testLeadConvertTrigger(){
        //Creating Mock Data
        Lead testLead = new Lead(FirstName='Test First Name', LastName='Test Last Name', Company='Test Company', LeadSource='Alliances',Trigger__c='Alliances',Country='US');
        insert testLead;
        
		Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }
}