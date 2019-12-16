/**
* @author Pratibh Prakash
* @date 15-May-2017
* @description Test class for KROW Automation functionality
* @last modified by 
*/
@isTest
private class KrowTest {
    
    private static Krow__Project__c testProjectTemplate;
    
    static testMethod void testSalesServiceRequest() {
        /*
        Creating mock data
        */
        createKrowData();
        
        //Creating Account
        List<Account> accountForInsert = new List<Account>();
        Account testAccount = new Account(Name='Test Account', BillingCountry='US');
        accountForInsert.add(testAccount);
        Account testPartnerAccount = new Account(Name='Test Partner Account', BillingCountry='US');
        accountForInsert.add(testPartnerAccount);
        insert accountForInsert;
        
        //Creating Opportunity
        Opportunity testOpportunity = new Opportunity(Name='Test Opporunity', AccountId=testAccount.Id, CloseDate=Date.today(), StageName='1 - Identify', Trigger__c='Sales');
        insert testOpportunity;
        
        //Creating Partner for Opportunity
        Partner testPartner = new Partner(OpportunityId=testOpportunity.Id, AccountToId=testPartnerAccount.Id, Role='Consultant', IsPrimary=true);
        insert testPartner;
        
        AccountPartner[] opportunityPartnerList = [Select Role, OpportunityId, IsPrimary, AccountToId, AccountFromId
                                                    From AccountPartner];
        
        System.debug('--------------opportunityPartnerList='+opportunityPartnerList);
        
        //Create Sales Service Request
        Sales_Service_Request__c testRequest = new Sales_Service_Request__c(Opportunity__c=testOpportunity.Id,Auto_Submit_to_Sales_Service_Team__c=false);
        insert testRequest;
        
        //Submit Sales Service Request for Approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(testRequest.Id);
        req1.setSubmitterId(UserInfo.getUserId());
        Approval.ProcessResult result = Approval.process(req1);
        
        //Inserting Custom Setting data
        insert new TradeshiftGlobalSettings__c(SetupOwnerId=UserInfo.getOrganizationId(), Default_Project_Manager__c=UserInfo.getUserId(), Discount_Threshold__c=10);
        
        
        //Testing SalesServiceRequestApprovalController Controller
        ApexPages.StandardController testStdController = new ApexPages.StandardController(testRequest);
        SalesServiceRequestApprovalController ctlObj = new SalesServiceRequestApprovalController(testStdController);
        
        //Testing abstract class methods
        Boolean hasMessagesFlag = ctlObj.hasMessages;
        String errormsg = ctlObj.errorMessage;
        String alertType = ctlObj.alertType;
        
        //Reject Request without rejection comments
        ctlObj.rejectRequest();
        
        //Reject Request with rejection comments
        ctlObj.comments = 'Test Rejection';
        ctlObj.rejectRequest();
        
        //Resubmitting Request 
        //req1 = new Approval.ProcessSubmitRequest();
        //req1.setComments('Submitting request for approval.');
        //req1.setObjectId(testRequest.Id);
        //req1.setSubmitterId(UserInfo.getUserId());
        result = Approval.process(req1);
        
        
        //Approving Request without selecting template
        ctlObj.approveRequest();
        
        //Approving Request with template selected
        ctlObj = new SalesServiceRequestApprovalController(testStdController);
        ctlObj.selectedTemplate = testProjectTemplate.Id;
        ctlObj.approveRequest();
        
        //Test for second request when Project is already created for the Opportunity
        Sales_Service_Request__c testRequest_second = new Sales_Service_Request__c(Opportunity__c=testOpportunity.Id,Auto_Submit_to_Sales_Service_Team__c=false);
        insert testRequest_second;
        
        //Submit Sales Service Request for Approval
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('Submitting request for approval.');
        req2.setObjectId(testRequest_second.Id);
        req2.setSubmitterId(UserInfo.getUserId());
        result = Approval.process(req2);
        
        //Testing SalesServiceRequestApprovalController Controller when Project is aleady created.
        testStdController = new ApexPages.StandardController(testRequest_second);
        ctlObj = new SalesServiceRequestApprovalController(testStdController);
        
        //Testing Cancel Method
        ctlObj.cancelApproval();
        
        //Approving Request
        ctlObj.approveRequest();
        
        //Testing abstract class methods
        hasMessagesFlag = ctlObj.hasMessages;
        errormsg = ctlObj.errorMessage;
        alertType = ctlObj.alertType;
        
        testRequest_second.Status__c = 'Rejected';
        update testRequest;
        
        testRequest_second.Status__c = 'Complete';
        testRequest_second.Completion_Date__c = Date.today();
        testRequest_second.Standard_Target_Completion_Date__c = Date.today();
        update testRequest;
        
        SalesServiceRequestHelper.getWorkingDays(Date.today(), Date.today()+7);
    }
    
    private static void createKrowData(){
        //Creating Rate Card
        Krow__Krow_Rate_Card__c testRateCard = new Krow__Krow_Rate_Card__c(Name='Test Rate Card');
        insert testRateCard;
        
        //Creating Project Template
        testProjectTemplate = new Krow__Project__c();
        testProjectTemplate.Name = 'Test Template';
        testProjectTemplate.Krow__Billable__c = false;
        testProjectTemplate.Krow__Description__c = 'This is test template';
        testProjectTemplate.Krow__Expected_Revenue__c = 10000;
        testProjectTemplate.Krow__Planned_Hours__c = 200;
        testProjectTemplate.Krow__Project_Start_Date__c = Date.today();
        testProjectTemplate.Krow__Project_End_Date__c = Date.today().addMonths(2);
        testProjectTemplate.Krow__Project_Type__c = 'Fixed Fee';
        testProjectTemplate.Krow__Rate_Card__c = testRateCard.Id;
        testProjectTemplate.Krow__Public_Project_Template__c = true;
        testProjectTemplate.Krow__Project_Template__c = true;
        insert testProjectTemplate;
        
        //Creating Project Resource
        Krow__Project_Resources__c testResource = new Krow__Project_Resources__c();
        testResource.Krow__User__c = UserInfo.getUserId();
        testResource.Krow__Active__c = true;
        insert testResource;
        
        Krow__Krow_Role__c roleK=new Krow__Krow_Role__c();
        rolek.Name='Business Analyst (BA)';
        roleK.Krow__Active__c=true;
        insert rolek;
        
        //Creating Project Team
        Krow__Project_Assignment__c tempProjectAssignment = new Krow__Project_Assignment__c();
        tempProjectAssignment.Krow__Project_Resource__c =  testResource.Id;
        tempProjectAssignment.Krow__User__c = UserInfo.getUserId();
        tempProjectAssignment.Krow__Krow_Project__c =  testProjectTemplate.Id;
        tempProjectAssignment.Krow__Role__c=rolek.id;
        insert tempProjectAssignment;
        
        //Creating Project Task
        List<Krow__Task__c> krowTaskForInsert = new List<Krow__Task__c>();
        Krow__Task__c testTask_weekdays = new Krow__Task__c();
        testTask_weekdays.Krow__Start_Date__c = Date.today();
        testTask_weekdays.Krow__Due_Date__c = Date.today();
        testTask_weekdays.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekdays.Krow__Status__c = 'Not Started';
        testTask_weekdays.Krow__Priority__c = 'Normal';
        testTask_weekdays.Krow__Project__c = testProjectTemplate.Id;
        krowTaskForInsert.add(testTask_weekdays);
        
        Krow__Task__c childTask = new Krow__Task__c();
        childTask.Krow__Start_Date__c = Date.today();
        childTask.Krow__Due_Date__c = Date.today();
        childTask.Krow__Assigned_By__c = UserInfo.getUserId();
        childTask.Krow__Status__c = 'Not Started';
        childTask.Krow__Priority__c = 'Normal';
        childTask.Krow__Project__c = testProjectTemplate.Id;
        childTask.Krow__Parent_Task__c = testTask_weekdays.Id;
        krowTaskForInsert.add(childTask);
        
        Krow__Task__c testTask_weekend = new Krow__Task__c();
        testTask_weekend.Krow__Start_Date__c = Date.today();
        testTask_weekend.Krow__Due_Date__c = Date.today();
        testTask_weekend.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend.Krow__Status__c = 'Not Started';
        testTask_weekend.Krow__Priority__c = 'Normal';
        testTask_weekend.Krow__Project__c = testProjectTemplate.Id;
        testTask_weekend.Krow__Include_Weekends__c = true;
        testTask_weekend.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend);
        
        Krow__Task__c testTask_weekend_withDates = new Krow__Task__c();
        testTask_weekend_withDates.Krow__Start_Date__c = Date.today();
        testTask_weekend_withDates.Krow__Due_Date__c = Date.today();
        testTask_weekend_withDates.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend_withDates.Krow__Status__c = 'Not Started';
        testTask_weekend_withDates.Krow__Priority__c = 'Normal';
        testTask_weekend_withDates.Krow__Project__c = testProjectTemplate.Id;
        testTask_weekend_withDates.Krow__Include_Weekends__c = false;
        testTask_weekend_withDates.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend_withDates);
        
        Krow__Task__c testTask_weekend_withoutDates = new Krow__Task__c();
        testTask_weekend_withoutDates.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend_withoutDates.Krow__Status__c = 'Not Started';
        testTask_weekend_withoutDates.Krow__Priority__c = 'Normal';
        testTask_weekend_withoutDates.Krow__Project__c = testProjectTemplate.Id;
        testTask_weekend_withoutDates.Krow__Include_Weekends__c = false;
        testTask_weekend_withoutDates.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend_withoutDates);
        insert krowTaskForInsert;
        
        //Creating Task Assignment
        Krow__Task_Assignment__c testAssignment1 = new Krow__Task_Assignment__c();
        testAssignment1.Krow__Krow_Task__c = testTask_weekdays.Id;
        testAssignment1.Krow__Project_Resource__c = testResource.Id;
        testAssignment1.Krow__User__c =  UserInfo.getUserId();
        testAssignment1.Krow__Project__c = testProjectTemplate.Id;
        testAssignment1.Krow__Start_Date__c = Date.today();
        insert testAssignment1;
        
        //Creating Task Links
        Krow__Task_Link__c testLink = new Krow__Task_Link__c();
        testLink.Krow__Source_Task__c = testTask_weekdays.Id;
        testLink.Krow__Target_Task__c = childTask.Id;
        testLink.Krow__Type__c = 0;
        insert testLink;
        
    }
}