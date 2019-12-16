@istest(SeeAllData=true)
public class scheduleReportTest{
    static testmethod void testSample() {
        Test.startTest();
        scheduleReport obj = new scheduleReport();
        obj.execute(null);
        Test.stopTest();
    }
}