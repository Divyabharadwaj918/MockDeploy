@istest
public class AvoidDuplicateUsageEntry_Test{
    public static testMethod void Question_Insert_Test(){
        RFP__c rfp = new RFP__c(name='test RFP', due_date__c=system.today().addDays(1));
        insert rfp;
        Response__c r = new Response__c(name='test response');
        insert r;
        Question__c existingQ = new Question__c(rfp__c=rfp.id, response__c=r.id, question__c='How Can Mirrors Be Real If Our Eyes Aren\'t Real?');
        insert existingQ;
        
        Question__c q = new Question__c(rfp__c=rfp.id, response__c=r.id);
        
        Test.startTest();
        try{
            insert q;
        }catch(Exception e){
            system.debug('Error reads: '+e);
        }
        Test.stopTest();
    }
}