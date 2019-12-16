@isTest(seealldata=false)
public class ContractAttachmentValidatorCtl_Test {
    
    public static testMethod void testController(){
        //Creating Mock data
        Account testAccount = new Account(Name='Test Account', BillingCity='Test', BillingCountry='US');
        insert testAccount;
        
        Opportunity testOpp = new Opportunity(Name='Test Opportunity', StageName='1 - Identify', Closedate=Date.today()+30, Trigger__c='Sales');
        insert testOpp;
        
        Contract testContract = new Contract(AccountId=testAccount.Id, Opportunity__c=testOpp.Id);
        insert testContract;
        
        List<GoogleDoc> docsforUpload = new List<GoogleDoc>();
        for(Integer i=0;i<3; i++){
            GoogleDoc tempDoc = new GoogleDoc(Name='Doc'+String.valueOf(i+1), URL='https://docs.google.com/PLACEHOLDERPLEASEUPLOAD'+String.valueOf(i+1), ParentId=testContract.Id);
            docsforUpload.add(tempDoc);
        }
        insert docsforUpload;
        
        //Initiating tests
        ApexPages.StandardController sc = new ApexPages.StandardController(testContract);
        ContractAttachmentValidatorController testCtlObj = new ContractAttachmentValidatorController(sc);
        
        testCtlObj.udpateContract();
        
        for(Integer i=0; i<testCtlObj.doclist.size(); i++){
            testCtlObj.doclist[i].URL = 'https://docs.google.com/PLACEHOLDERPLEASEUPLOAD'+String.valueOf(i+1);
        }
        
        testCtlObj.saveDocs();
    }
}