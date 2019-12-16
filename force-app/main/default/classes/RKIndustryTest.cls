@isTest 
private class RKIndustryTest {

static testMethod void TestInserts(){

RK_Industry_Translation__c rk = new RK_Industry_Translation__c();
rk.Name = 'Test';
insert rk;

Lead a = new Lead ();
a.LastName='Test';
a.Company='Test';
a.LeadSource='RainKing';
a.Translate_RK_Industry__c='Yes';
a.email='test12345@test.com';
a.LeadSource='Alliances';
insert a;

Account b = new Account();
b.Name='Testing';
b.Translate_RK_Industry__c='Yes';
b.BillingCountry ='US';
insert b;

Contact c = new Contact();
c.FirstName = 'Test';
c.Lastname='Test';
c.Account = b;
c.LeadSource = 'RainKing';
c.email='test1234567@test.com';
insert c;

}
}