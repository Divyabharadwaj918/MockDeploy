trigger OneRecordOnly on RK_Industry_Translation__c (before insert) {

for (RK_Industry_Translation__c x : Trigger.new) {

List <RK_Industry_Translation__c> z = New list <RK_Industry_Translation__c> ([Select Id from RK_Industry_Translation__c limit 2]);

if(z.size() > 0) {x.adderror('Please edit the existing translation record rather than creating a new one.');}


}
}