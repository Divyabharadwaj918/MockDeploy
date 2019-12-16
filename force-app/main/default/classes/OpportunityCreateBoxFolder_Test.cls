@istest
public class OpportunityCreateBoxFolder_Test{
    public static testMethod void execute_Test(){
        String authResponse = BoxTestJsonResponseFactory.AUTH_USER_TOKEN;
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(authResponse, 'OK', 200));
        Account a = new Account(name='testaccount', billingcountry='usa');
        insert a;
        Opportunity o = new Opportunity(accountid=a.id, name='testopp', closedate=system.today(), stagename='1 - Identify', trigger__c='Alliances');
        insert o;
        
        Test.startTest();
        system.enqueueJob(new OpportunityCreateBoxFolder_Queue(new Opportunity[]{o}));
        Test.stopTest();
    }
    
    public static testMethod void methods_Test(){
        String authResponse = BoxTestJsonResponseFactory.AUTH_USER_TOKEN;
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(authResponse, 'OK', 200));
        Account a = new Account(name='testaccount', billingcountry='usa');
        insert a;
        Opportunity o = new Opportunity(accountid=a.id, name='testopp', closedate=system.today(), stagename='1 - Identify', trigger__c='Alliances');
        insert o;
        
        test.startTest();
        OpportunityCreateBoxFolder_Queue oclass = new OpportunityCreateBoxFolder_Queue(new Opportunity[]{o});
        oclass.authenticate();
        oclass.getFolders();
        test.stopTest();
    }
}