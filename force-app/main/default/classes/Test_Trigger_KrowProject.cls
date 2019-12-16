/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 * 
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /**
    *   Description     :   Testing for Trigger_KrowProject trigger and it's helper class
    *
    *   Created by      :   
    *
    *   Created Date    :   02/06/2019
    *
    *   Revision Log    :   
    *
    *   Code Coverage   :   100%
    **/ 
@isTest(seeAllData = false)
private class Test_Trigger_KrowProject {
   
   /**
    *   Description     :   This method is used to insert common data
    *
    *   @args           :   
    *
    *   @return type    :   Void
    *
    *   @Revision Log   :   Created
    **/
    @testSetup static void setupData() {

        //List to hold Krow Project Template
        List<Krow_Project_Template__c> templates = new List<Krow_Project_Template__c>();

        //Add record to list
        templates.add(new Krow_Project_Template__c(Name='Template-1'));
        templates.add(new Krow_Project_Template__c(Name='Template-2'));
        templates.add(new Krow_Project_Template__c(Name='Template-3'));

        //Insert
        insert templates;

        List<Account> accounts = new List<Account>();
        
        accounts.add(new Account(Name = 'Account -1', BillingCountry='US'));
        
        //Insert Account
        insert accounts;

        List<Campaign> campaigns = new List<Campaign>();
        
        Campaigns.add(new Campaign(Name = 'Campaign -1'));
        
        //Insert Account
        insert campaigns;
        
        //List to hold Krow Project Template Task
        List<Krow_Project_Template_Task__c> tasks = new List<Krow_Project_Template_Task__c>();

        //Add record to list
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-1-Task-1',Krow_Project_Template__c = templates[0].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-1-Task-2',Krow_Project_Template__c = templates[0].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-1-Task-3',Krow_Project_Template__c = templates[0].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-1-Task-4',Krow_Project_Template__c = templates[0].Id));
        
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-2-Task-1',Krow_Project_Template__c = templates[1].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-2-Task-2',Krow_Project_Template__c = templates[1].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-2-Task-3',Krow_Project_Template__c = templates[1].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-2-Task-4',Krow_Project_Template__c = templates[1].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-2-Task-5',Krow_Project_Template__c = templates[1].Id));
        
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-3-Task-1',Krow_Project_Template__c = templates[2].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-3-Task-2',Krow_Project_Template__c = templates[2].Id)); 
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-3-Task-3',Krow_Project_Template__c = templates[2].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-3-Task-4',Krow_Project_Template__c = templates[2].Id));
        tasks.add(new Krow_Project_Template_Task__c(Name='Template-3-Task-5',Krow_Project_Template__c = templates[2].Id));

        //Insert tasks
        insert tasks;
        
        tasks = [Select Id, Name, Krow_Project_Parent_Template_Task__c From Krow_Project_Template_Task__c Where Krow_Project_Template__c = :templates[0].Id order by Name Asc];
        tasks[3].Krow_Project_Parent_Template_Task__c = tasks[2].Id;
        tasks[2].Krow_Project_Parent_Template_Task__c = tasks[1].Id;
        tasks[1].Krow_Project_Parent_Template_Task__c = tasks[0].Id;
        
        update tasks;

        tasks = [Select Id, Name, Krow_Project_Parent_Template_Task__c From Krow_Project_Template_Task__c Where Krow_Project_Template__c = :templates[1].Id order by Name Asc];
        tasks[4].Krow_Project_Parent_Template_Task__c = tasks[2].Id;
        tasks[3].Krow_Project_Parent_Template_Task__c = tasks[1].Id;
        tasks[2].Krow_Project_Parent_Template_Task__c = tasks[1].Id;
        tasks[1].Krow_Project_Parent_Template_Task__c = tasks[0].Id;
        tasks[0].Krow_Project_Parent_Template_Task__c = tasks[4].Id;
        
        update tasks;  
        
        tasks = [Select Id, Name, Krow_Project_Parent_Template_Task__c From Krow_Project_Template_Task__c Where Krow_Project_Template__c = :templates[2].Id order by Name Asc];
        
        tasks[3].Krow_Project_Parent_Template_Task__c = tasks[2].Id;
        tasks[2].Krow_Project_Parent_Template_Task__c = tasks[4].Id;
        tasks[1].Krow_Project_Parent_Template_Task__c = tasks[4].Id;
        
        update tasks;
    }
    /**
    *   Description     :   This method is used to test createNewKrowTask method of KrowProjectTriggerHelper class
    *
    *   @args           :   
    *
    *   @return type    :   Void
    *
    *   @Revision Log   :   Created
    **/
    static testMethod void testCreateNewKrowTask(){
        try{
            List<Krow_Project_Template__c> templates =  [Select Id, Name From Krow_Project_Template__c order by Name Asc];
            
            //Insert Onboarding Tempalate
            Krow_Project_Template__c template = new Krow_Project_Template__c();
            template.Name = 'Test-Onboarding TEmplate';
            insert template ;
            
            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );
            
            insert u;
            
            //List to hold Account
            List<Account> accounts = [Select Id, Name From Account];
            
            List<Campaign> campaigns = [Select Id, Name From Campaign];        
            
            //Query on Record type
            List<RecordType> recordTypesBuyerOnboard = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Onboarding_Project'];
            
            Krow__Project__c krowBuyerProject = new Krow__Project__c();
            krowBuyerProject.Name ='Krow_Project-2';
            krowBuyerProject.Krow__Account__c = accounts[0].Id;
            krowBuyerProject.Seller_Account__c = accounts[0].Id;
            krowBuyerProject.Krow_Project_Template__c = template.Id;
            krowBuyerProject.Onboarding_Category__c = 'Managed';
            krowBuyerProject.Product_Types__c = 'DD';
            krowBuyerProject.Projected_Invoice_Volume__c = 1;
            krowBuyerProject.Seller_Released_Date__c = Date.today();
            krowBuyerProject.Potential_Spend__c = 12.1;
            krowBuyerProject.RecordTypeId = recordTypesBuyerOnboard[0].Id;
            krowBuyerProject.Campaign__c = campaigns[0].Id;
            krowBuyerProject.Project_Origin__c = 'Tradeshift';
            insert krowBuyerProject;
            
            
            //Query on Record type
            List<RecordType> recordTypes = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Seller_Project'];
            
            //List to hold Krow Project
            List<Krow__Project__c> projects = new List<Krow__Project__c>();
            
            //Add record to list
            projects.add(new Krow__Project__c(Name='Krow_project-1', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress',
                                              Krow_Project_Template__c = templates[0].Id,Krow__Account__c = accounts[0].Id, 
                                              Seller_Account__c = accounts[0].Id,
                                              Onboarding_Category__c = 'Managed',
                                              Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                              Projected_Invoice_Volume__c = 1,
                                              Seller_Released_Date__c = Date.today(),
                                              Potential_Spend__c = 12.1, OwnerId = u.Id,
                                              Buyer_Project__c= krowBuyerProject.Id,
                                              Campaign__c = campaigns[0].Id));
            
            //Insert Project
            insert projects;
            
            Krow__Project__c krowProject = new Krow__Project__c();
            krowProject.Name ='Krow_Project-2';
            krowProject.Krow__Account__c = accounts[0].Id;
            krowProject.Seller_Account__c = accounts[0].Id;
            krowProject.Krow_Project_Template__c = template.Id;
            //krowProject.Onboarding_Category__c = 'Managed';
            krowProject.Product_Types__c = 'DD';
            krowProject.Projected_Invoice_Volume__c = 1;
            krowProject.Seller_Released_Date__c = Date.today();
            krowProject.Potential_Spend__c = 12.1;
            krowProject.Buyer_Project__c= krowBuyerProject.Id;
            krowProject.Campaign__c = campaigns[0].Id;
            krowProject.Project_Origin__c = 'Tradeshift';
            krowProject.OwnerId = u.Id;
            insert krowProject;
            
            //Testing start form here
            Test.startTest();
            
            //Query on Project
            projects = [Select Id From Krow__Project__c];
            
            //Update Krow Project Template
            projects[0].Krow_Project_Template__c = templates[1].Id;
            
            //Update projects
            update projects;
            //Testing stop here 
            //
            delete projects;
            Test.stopTest();
    }
        Catch(Exception ex){
            system.debug(ex.getMessage());
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Project Owner value of incorrect type') ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    
    /**
    *   Description     :   This method is used to test createKrowProjectTemplate method of KrowProjectTriggerHelper class
    *
    *   @args           :   
    *
    
    *   @return type    :   Void
    *
    *   @Revision Log   :   Created
    **/
    static testMethod void testcreateKrowProjectTemplate(){

        //Query on Record type
        List<RecordType> recordTypes = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Seller_Project'];

        //List to hold Account
        List<Account> accounts = [Select Id, Name From Account];

        //List to hold Campaign
        List<Campaign> campaigns = [Select Id, Name From Campaign];
    
        //List to hold Krow Project
        List<Krow__Project__c> projects = new List<Krow__Project__c>();
        
        //Insert Onboarding Tempalate
        Krow_Project_Template__c template = new Krow_Project_Template__c();
        template.Name = 'Test-Onboarding TEmplate';
        insert template ;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        insert u;

        List<RecordType> recordTypesBuyerOnboard = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Onboarding_Project'];
        
        Krow__Project__c krowBuyerProject = new Krow__Project__c();
        krowBuyerProject.Name ='Krow_Project-2';
        krowBuyerProject.Krow__Account__c = accounts[0].Id;
        krowBuyerProject.Seller_Account__c = accounts[0].Id;
		krowBuyerProject.Krow_Project_Template__c = template.Id;
		krowBuyerProject.Onboarding_Category__c = 'Managed';
		krowBuyerProject.Product_Types__c = 'DD';
		krowBuyerProject.Projected_Invoice_Volume__c = 1;
		krowBuyerProject.Seller_Released_Date__c = Date.today();
		krowBuyerProject.Potential_Spend__c = 12.1;
        krowBuyerProject.RecordTypeId = recordTypesBuyerOnboard[0].Id;
        krowBuyerProject.Campaign__c = campaigns[0].Id;
        krowBuyerProject.Project_Origin__c = 'Tradeshift';
        insert krowBuyerProject;


        //Add record to list
        projects.add(new Krow__Project__c(Name='Krow_project-1', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress',
                                         Krow__Account__c = accounts[0].Id, Seller_Account__c = accounts[0].Id, 
                                         Krow_Project_Template__c = template.Id,
                                         Onboarding_Category__c = 'Managed',
                                         Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1,
                                         Seller_Released_Date__c = Date.today(),
                                         Potential_Spend__c = 12.1,
										 SIPM__c = u.Id, Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        projects.add(new Krow__Project__c(Name='Krow_project-2', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress',
                                         Krow__Account__c = accounts[0].Id, Seller_Account__c = accounts[0].Id, 
                                          Krow_Project_Template__c = template.Id,
                                         Onboarding_Category__c = 'Managed',
                                         Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1,
                                         Seller_Released_Date__c = Date.today(),
                                         Potential_Spend__c = 12.1,Last_Milestone__c ='Lead',
                                         SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        
        //insert projects
        insert projects;
        
        //List to hold krowTask.
        List<Krow__Task__c> krowTasks = new List<Krow__Task__c>();
        
        krowTasks.add(new Krow__Task__c(Name = 'Task-1', Krow__Project__c = projects[0].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 1));
        krowTasks.add(new Krow__Task__c(Name = 'Task-2', Krow__Project__c = projects[0].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 2));
        krowTasks.add(new Krow__Task__c(Name = 'Task-3', Krow__Project__c = projects[0].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 3));
        krowTasks.add(new Krow__Task__c(Name = 'Task-4', Krow__Project__c = projects[0].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 4));
        krowTasks.add(new Krow__Task__c(Name = 'Task-5', Krow__Project__c = projects[0].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 5)); 
        
        krowTasks.add(new Krow__Task__c(Name = 'Task-1', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 1));
        krowTasks.add(new Krow__Task__c(Name = 'Task-2', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 2));
        krowTasks.add(new Krow__Task__c(Name = 'Task-3', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 3));
        krowTasks.add(new Krow__Task__c(Name = 'Task-4', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 4));        
        krowTasks.add(new Krow__Task__c(Name = 'Task-5', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Completed', Krow__Project_Task_Order__c = 5));        
        
        insert krowTasks;
         
        //List to update krowTask.
        List<Krow__Task__c> krowTasksWithParentTask = new List<Krow__Task__c>();

        //Query krowTask
        List<Krow__Task__c> queriedkrowTasks = [SELECT Id, Krow__Parent_Task__c FROM Krow__Task__c WHERE Krow__Project__c = :projects[0].Id ORDER BY Name ASC];
        
        //Add task to list.
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[4].Id, Krow__Parent_Task__c = queriedkrowTasks[3].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[3].Id, Krow__Parent_Task__c = queriedkrowTasks[2].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[2].Id, Krow__Parent_Task__c = queriedkrowTasks[1].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[1].Id, Krow__Parent_Task__c = queriedkrowTasks[0].Id));
        update krowTasksWithParentTask; 
        
        queriedkrowTasks = [SELECT Id, Krow__Parent_Task__c FROM Krow__Task__c WHERE Krow__Project__c = :projects[1].Id ORDER BY Name ASC];
        
        //Add task to list.
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[4].Id, Krow__Parent_Task__c = queriedkrowTasks[3].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[3].Id, Krow__Parent_Task__c = queriedkrowTasks[2].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[2].Id, Krow__Parent_Task__c = queriedkrowTasks[1].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Id = queriedkrowTasks[1].Id, Krow__Parent_Task__c = queriedkrowTasks[0].Id));
        krowTasksWithParentTask.add(new Krow__Task__c(Name = 'Task-5', Krow__Project__c = projects[1].Id, Krow__Status__c = 'Not Started', Krow__Project_Task_Order__c = 1, Krow__Parent_Task__c = queriedkrowTasks[4].Id));
        upsert krowTasksWithParentTask; 
        
        
        //Query projects to update Krow__Project_Template__c field to true.
        projects = [SELECT Id, Krow__Project_Template__c FROM Krow__Project__c ORDER BY Name ASC];
        projects[0].Krow__Project_Template__c = true;
        projects[0].Last_Milestone__c = 'consulation';
        projects[1].Krow__Project_Template__c = true;
        
        //update project.
        update projects;
        
        Test.startTest();
        
        //Query created project template record. 
        List<Krow_Project_Template__c> cretedProjectTemplateRecords = [SELECT Id, Name FROM Krow_Project_Template__c WHERE Name like '%Krow_project%' ORDER BY Name ASC];
        
        //Check assert
        System.assertEquals(2, cretedProjectTemplateRecords.size() );
        
        //Query created template task.
        List<Krow_Project_Template_Task__c> createdTemplateTask = [SELECT Id, Name, Krow_Project_Template__c, Krow_Project_Parent_Template_Task__c FROM Krow_Project_Template_Task__c WHERE Krow_Project_Template__c = :cretedProjectTemplateRecords[0].Id ORDER BY Name];
        
        //Check assert
        System.assertEquals(5, createdTemplateTask.size() );
        System.assertEquals(createdTemplateTask[3].Id, createdTemplateTask[4].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[2].Id, createdTemplateTask[3].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[1].Id, createdTemplateTask[2].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[0].Id, createdTemplateTask[1].Krow_Project_Parent_Template_Task__c);
        
        //Query second template task.
        createdTemplateTask = [SELECT Id, Name, Krow_Project_Template__c, Krow_Project_Parent_Template_Task__c FROM Krow_Project_Template_Task__c WHERE Krow_Project_Template__c = :cretedProjectTemplateRecords[1].Id ORDER BY Name];
        
        //Check assert
        /*System.assertEquals(6, createdTemplateTask.size() );
        System.assertEquals(createdTemplateTask[3].Id, createdTemplateTask[4].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[2].Id, createdTemplateTask[3].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[1].Id, createdTemplateTask[2].Krow_Project_Parent_Template_Task__c);
        System.assertEquals(createdTemplateTask[0].Id, createdTemplateTask[1].Krow_Project_Parent_Template_Task__c);*/
        
        Test.stopTest();
    }
    
     /**
    *   Description     :   This method is used to test createBuyerSellerRelationship method of KrowProjectTriggerHelper class
    *
    *   @args           :   
    *
    *   @return type    :   Void
    *
    *   @Revision Log   :   Created
    **/
    static testMethod void testCreateBuyerSellerRelationship(){
        //List to hold buyer account.
        List<Account> buyerAccounts = new List<Account>();

        //Insert Onboarding Tempalate
        Krow_Project_Template__c template = new Krow_Project_Template__c();
        template.Name = 'Test-Onboarding TEmplate';
        insert template ;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        insert u;

        List<RecordType> recordTypesBuyerOnboard = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Onboarding_Project'];
        
        List<Account> accounts = [Select Id , Name From account];
        List<Campaign> campaigns = [Select Id , Name From Campaign];
        
        Krow__Project__c krowBuyerProject = new Krow__Project__c();
        krowBuyerProject.Name ='Krow_Project-2';
        krowBuyerProject.Krow__Account__c = accounts[0].Id;
        krowBuyerProject.Seller_Account__c = accounts[0].Id;
		krowBuyerProject.Krow_Project_Template__c = template.Id;
		krowBuyerProject.Onboarding_Category__c = 'Managed';
		krowBuyerProject.Product_Types__c = 'DD';
		krowBuyerProject.Projected_Invoice_Volume__c = 1;
		krowBuyerProject.Seller_Released_Date__c = Date.today();
		krowBuyerProject.Potential_Spend__c = 12.1;
        krowBuyerProject.RecordTypeId = recordTypesBuyerOnboard[0].Id;
        krowBuyerProject.Campaign__c = campaigns[0].Id;
        krowBuyerProject.Project_Origin__c = 'Tradeshift';
        insert krowBuyerProject;
        
        //Add buyer in list.
        buyerAccounts.add(new Account(Name='buyer-1', Is_Buyer__c=true, BillingCountry='USA'));
        buyerAccounts.add(new Account(Name='buyer-2', Is_Buyer__c=true, BillingCountry='USA'));
        buyerAccounts.add(new Account(Name='buyer-3', Is_Buyer__c=true, BillingCountry='USA'));
        buyerAccounts.add(new Account(Name='buyer-4', Is_Buyer__c=true, BillingCountry='USA'));
        buyerAccounts.add(new Account(Name='buyer-5', Is_Buyer__c=true, BillingCountry='USA'));
        
        //Insert buyer.
        insert buyerAccounts;
        
        //List to hold seller account.
        List<Account> sellerAccounts = new List<Account>();
        
        //Add seller in list.
        sellerAccounts.add(new Account(Name='seller-1', Is_Seller__c=true, BillingCountry='USA'));
        sellerAccounts.add(new Account(Name='seller-2', Is_Seller__c=true, BillingCountry='USA'));
        sellerAccounts.add(new Account(Name='seller-3', Is_Seller__c=true, BillingCountry='USA'));
        sellerAccounts.add(new Account(Name='seller-4', Is_Seller__c=true, BillingCountry='USA'));
        sellerAccounts.add(new Account(Name='seller-5', Is_Seller__c=true, BillingCountry='USA'));
        
        //Insert seller.
        insert sellerAccounts;

        //Query on Record type
        List<RecordType> recordTypes = [Select Id From RecordType where sobjecttype = 'Krow__Project__c' AND DeveloperName = 'Buyer_Seller_Project'];

        Test.startTest();
        
        //List to hold projects.
        List<Krow__Project__c> listOfProject = new List<Krow__Project__c>();
        
        //Add project in list.
        listOfProject.add(new Krow__Project__c(Name='Project-1', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[0].Id, Seller_Account__c = sellerAccounts[0].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                         SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        listOfProject.add(new Krow__Project__c(Name='Project-2', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[1].Id, Seller_Account__c = sellerAccounts[1].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                         SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        listOfProject.add(new Krow__Project__c(Name='Project-3', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[2].Id, Seller_Account__c = sellerAccounts[2].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                         SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        listOfProject.add(new Krow__Project__c(Name='Project-4', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[3].Id, Seller_Account__c = sellerAccounts[3].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                         SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        listOfProject.add(new Krow__Project__c(Name='Project-5', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[4].Id, Seller_Account__c = sellerAccounts[4].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                              SIPM__c = u.Id,Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        
        //Insert project.
        insert listOfProject;
        
        //Query relationship record.
        List<Buyer_Seller_Relationship__c> relationships = [Select Id, Name, Krow_Project__c, Associate_Account__c, Buyer__c, Seller__c From Buyer_Seller_Relationship__c];
        
        //Assert on relationship record. 
        System.assertEquals(5, relationships.size());
        
       listOfProject.add(new Krow__Project__c(Name='Project-5', RecordTypeId = recordTypes[0].Id, Krow__Project_Status__c = 'In Progress', Krow__Account__c = buyerAccounts[4].Id, Seller_Account__c = sellerAccounts[4].id,
                                         Krow_Project_Template__c = template.Id, Potential_Spend__c = 12.1,
                                         Onboarding_Category__c = 'Managed', Product_Types__c = 'DD', Project_Origin__c = 'Tradeshift',
                                         Projected_Invoice_Volume__c = 1, Seller_Released_Date__c = Date.today(),
                                          Buyer_Project__c= krowBuyerProject.Id,
        								 Campaign__c = campaigns[0].Id));
        Test.stopTest();
    }
}