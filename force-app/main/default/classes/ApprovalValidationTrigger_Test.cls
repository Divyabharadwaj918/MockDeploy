@isTest
private class ApprovalValidationTrigger_Test {
    
    private static Krow__Project__c testProject;
    
    static testMethod void testApprovalValidation(){
        //Creating mock data
        createKrowData();
        
        Krow__Timesheet__c testTimesheet = new Krow__Timesheet__c();
        insert testTimesheet;
        
        testTimesheet.Krow__Approval_Status__c = 'Approved';
        try{
            update testTimesheet;
        }
        catch(Exception ex){
            System.assert(ex.getMessage().contains('You cannot approve timesheet as you are not manager.'));
        }
        
        
    }
    
    private static void createKrowData(){
        User[] users = [Select Id from User where Profile.Name='System Administrator' and Id=:UserInfo.getUserId()];
        //Creating Rate Card
        Krow__Krow_Rate_Card__c testRateCard = new Krow__Krow_Rate_Card__c(Name='Test Rate Card');
        insert testRateCard;
        
        //Creating Project Template
        testProject = new Krow__Project__c();
        testProject.OwnerId =  users[0].Id;
        testProject.Name = 'Test Template';
        testProject.Krow__Billable__c = false;
        testProject.Krow__Description__c = 'This is test project';
        testProject.Krow__Expected_Revenue__c = 10000;
        testProject.Krow__Planned_Hours__c = 200;
        testProject.Krow__Project_Start_Date__c = Date.today();
        testProject.Krow__Project_End_Date__c = Date.today().addMonths(2);
        testProject.Krow__Project_Type__c = 'Fixed Fee';
        testProject.Krow__Rate_Card__c = testRateCard.Id;
        testProject.Krow__Public_Project_Template__c = false;
        testProject.Krow__Project_Template__c = false;
        insert testProject;
        
        //Creating Project Resource
        Krow__Project_Resources__c testResource = new Krow__Project_Resources__c();
        testResource.Krow__User__c = users[0].Id;
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
        tempProjectAssignment.Krow__Krow_Project__c =  testProject.Id;
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
        testTask_weekdays.Krow__Project__c = testProject.Id;
        krowTaskForInsert.add(testTask_weekdays);
        
        Krow__Task__c childTask = new Krow__Task__c();
        childTask.Krow__Start_Date__c = Date.today();
        childTask.Krow__Due_Date__c = Date.today();
        childTask.Krow__Assigned_By__c = UserInfo.getUserId();
        childTask.Krow__Status__c = 'Not Started';
        childTask.Krow__Priority__c = 'Normal';
        childTask.Krow__Project__c = testProject.Id;
        childTask.Krow__Parent_Task__c = testTask_weekdays.Id;
        krowTaskForInsert.add(childTask);
        
        Krow__Task__c testTask_weekend = new Krow__Task__c();
        testTask_weekend.Krow__Start_Date__c = Date.today();
        testTask_weekend.Krow__Due_Date__c = Date.today();
        testTask_weekend.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend.Krow__Status__c = 'Not Started';
        testTask_weekend.Krow__Priority__c = 'Normal';
        testTask_weekend.Krow__Project__c = testProject.Id;
        testTask_weekend.Krow__Include_Weekends__c = true;
        testTask_weekend.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend);
        
        Krow__Task__c testTask_weekend_withDates = new Krow__Task__c();
        testTask_weekend_withDates.Krow__Start_Date__c = Date.today();
        testTask_weekend_withDates.Krow__Due_Date__c = Date.today();
        testTask_weekend_withDates.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend_withDates.Krow__Status__c = 'Not Started';
        testTask_weekend_withDates.Krow__Priority__c = 'Normal';
        testTask_weekend_withDates.Krow__Project__c = testProject.Id;
        testTask_weekend_withDates.Krow__Include_Weekends__c = false;
        testTask_weekend_withDates.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend_withDates);
        
        Krow__Task__c testTask_weekend_withoutDates = new Krow__Task__c();
        testTask_weekend_withoutDates.Krow__Assigned_By__c = UserInfo.getUserId();
        testTask_weekend_withoutDates.Krow__Status__c = 'Not Started';
        testTask_weekend_withoutDates.Krow__Priority__c = 'Normal';
        testTask_weekend_withoutDates.Krow__Project__c = testProject.Id;
        testTask_weekend_withoutDates.Krow__Include_Weekends__c = false;
        testTask_weekend_withoutDates.Krow__Duration_Scale__c = 'Hour';
        krowTaskForInsert.add(testTask_weekend_withoutDates);
        insert krowTaskForInsert;
        
        //Creating Task Assignment
        Krow__Task_Assignment__c testAssignment1 = new Krow__Task_Assignment__c();
        testAssignment1.Krow__Krow_Task__c = testTask_weekdays.Id;
        testAssignment1.Krow__Project_Resource__c = testResource.Id;
        testAssignment1.Krow__User__c =  UserInfo.getUserId();
        testAssignment1.Krow__Project__c = testProject.Id;
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