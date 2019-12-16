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
*   Description     :  
*
*   Created by      :   
*
*   Created Date    :   1/16/2019
*
*   Revision Log    :   V1.0 - Created
*
**/
@isTest(SeeAllData=false)
public class CampaignMemberTriggerHelperTest {
    
    /* 
    *   Description     :   Define test setup method to define data.
    *
    *   @argument       :       
    *
    *   Revision Logs   :   V_1.0 - Created
    */
    @TestSetup Static void setup(){
        
        //List to hold multple account instances
        List<Account> accounts = new List<Account>();
        
        //Loop to make bulk data for account
        for(Integer i=0; i < 5 ; i++) {
            
            //Add in list to insert
            accounts.add(new Account(Name='Bill_Acc_'+i,BillingCountry='USD'));
        }
        
        //Dml on account object
        insert accounts;
        
        //To store multiple contact instances
        List<Contact> contacts = new List<Contact>();
        
        //Loop to iterate for each account
        for(Account account : accounts){
            
            //Loop to make bulk data for contact
            for(Integer i=0; i < 5 ; i++) {
                contacts.add(new Contact(AccountId=account.Id,FirstName='Bill',LastName='Contact'+i,CurrencyIsoCode='USD',LeadSource = 'Marketing'));
            }    
        }
        
        //Dml on conatct object
        insert contacts;
        
        //To store multiple campaign instances
        List<Campaign> campaigns = new List<Campaign>();
        
        //To insert bulk data for campaign
        for(Integer i=0; i < 5 ; i++) {
            campaigns.add(new Campaign(Name='Bill_Campaign_'+i,CurrencyIsoCode ='USD'));
        }
        
        //Dml on campaign object
        insert campaigns;
        
    }
    
    /**
    *  @description  :  This method is used to test populateCampaign method of helper.  
    *
    *  @args      :  
    *
    *  @return      :  void
    **/
    public static testmethod void updateCampaignOnAccount(){
        
        //To store multiple contact instances by query
        List<Contact> contacts = [SELECT Id , AccountId FROM Contact LIMIT 2];
        
        //To store multiple campaign instances by query
        List<Campaign> campaigns =[SELECT Id FROM Campaign];
        
        //To store multiple campaign member instances 
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        
        //Set contact id and campaign with campaign members
        campaignMembers.add(new CampaignMember(ContactId=contacts[0].Id,CampaignId=campaigns[0].Id,CurrencyIsoCode ='USD'));
        campaignMembers.add(new CampaignMember(ContactId=contacts[1].Id,CampaignId=campaigns[0].Id,CurrencyIsoCode ='USD'));
        
        //To store multiple account instances by query
        List<Account> accounts = [SELECT Id , Campaign__c FROM Account WHERE Id =: contacts[0].AccountId];
        
        //Assert to check camaign field updated or not
        system.assertEquals(null, accounts[0].Campaign__c);
        
        //To store multiple account instances by query
        accounts = [SELECT Id , Campaign__c FROM Account WHERE Id =: contacts[1].AccountId];
        
        //Assert to check camaign field updated or not
        system.assertEquals(null, accounts[0].Campaign__c);
        
        //Dml on campaign member and Trigger run on insert
        insert campaignMembers;
        
        Test.startTest();
        
        //To store multiple account instances by query
        accounts = [SELECT Id,Campaign__c FROM Account WHERE Id =: contacts[0].AccountId];
        
        //Assert to check camaign field updated or not
        system.assertEquals(campaigns[0].Id, accounts[0].Campaign__c);
   
        //To store multiple account instances by query
        accounts = [SELECT Id,Campaign__c FROM Account WHERE Id =: contacts[1].AccountId];
        
        //Assert to check camaign field updated or not
        system.assertEquals(campaigns[0].Id, accounts[0].Campaign__c);
       
        Test.stopTest();
        
    }
    
}