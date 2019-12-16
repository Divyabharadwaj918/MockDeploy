@isTest
public class DealDeskReviewCommentsTrigger_Test {
    private static testMethod void testDealDeskComments(){
        //Creating Mock Data
        Account testAccount = new Account(Name='Test', BillingCountry='US');
        insert testAccount;
        
        List<Contact> contactForInsert = new List<Contact>();
        Contact testContact1 = new Contact(FirstName='Test First Name 1', LastName='Test Last Name 1', AccountId=testAccount.Id, LeadSource='Alliances');
        contactForInsert.add(testContact1);       
        insert contactForInsert;
        
        //Initiating tests
        Opportunity testOpp = new Opportunity(Name='Test', AccountId=testAccount.Id, Primary_Contact__c=testContact1.Id,
        LeadSource='Alliances',Trigger__c='Alliances',StageName='1 - Identify',CloseDate=Date.today()+10);
        testOpp.New_Comment__c = 'Test Comments 1';
        testOpp.Legal_Finance_Comment__c = 'Legal Comments 1';
        testOpp.Product_Comment__c = 'Product Comments 1';
        testOpp.IT_Security_Comment__c = 'IT Comments 1';
        testOpp.Services_Comment__c = 'Service Comments 1';
        insert testOpp;
        
        try{
            testOpp.New_Comment__c = '';
            testOpp.Legal_Finance_Approval__c = 'Rejected';
            testOpp.Product_Approval__c = 'Rejected';
            testOpp.Services_Approval__c = 'Rejected';
            testOpp.IT_Security_Approval__c = 'Rejected';          
            testOpp.Legal_Finance_Comment__c = 'Legal Comments 2';
            testOpp.Product_Comment__c = 'Product Comments 2';
            testOpp.IT_Security_Comment__c = 'IT Comments 2';
            testOpp.Services_Comment__c = 'Service Comments 2';
        
            update testOpp;
        }
        catch(Exception ex){
            //System.assert(ex.getMessage().contains('New Comment is required when rejecting.'));
        }
        
        testOpp.New_Comment__c = 'Test Comments 2';
        testOpp.Legal_Finance_Comment__c = 'Legal Comments32';
            testOpp.Product_Comment__c = 'Product Comments 32';
            testOpp.IT_Security_Comment__c = 'IT Comments 32';
            testOpp.Services_Comment__c = 'Service Comments 32';
        update testOpp;
    }
}