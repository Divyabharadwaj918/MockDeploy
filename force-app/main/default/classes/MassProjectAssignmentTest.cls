/**
 * This class contains unit tests for validating the behavior of Apex classes
  and triggers.
 
  Unit tests are class methods that verify whether a particular piece
  of code is working properly. Unit test methods take no arguments,
  commit no data to the database, and are flagged with the testMethod
  keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
  to a production organization to confirm correctness, ensure code
  coverage, and prevent regressions. All Apex classes are
  required to have at least 75% code coverage in order to be deployed
  to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
  methods. Classes defined with the @isTest annotation do not count against
  the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/**
*   Description 	:   This class is used for code coverage of massProjectAssignmentContorller class.
*
*   Created by      :   
*
*   Created Date    :   04/05/2019
*
*   Revision Log    :   V1.0 - Created
*
*	Coverage		:  
**/
@isTest(SeeAllData=false)
public class MassProjectAssignmentTest {
    
    /* 
    *	Description     :	test setup method to define data.
    *
    *	@argument		:		
    *
    *	Revision Logs   : 	V_1.0 - Created
    */
    @testSetup
    static void testData(){
        
        
        List<Filter__c> filters = new List<Filter__c>();
        filters.add(new Filter__c(Name ='Project-1',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =true, type_of_filter__c ='Project'));
        filters.add(new Filter__c(Name ='Project-2',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =false,type_of_filter__c ='Project'));
 		filters.add(new Filter__c(Name ='resource-1',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =true,type_of_filter__c ='Resource'));
        filters.add(new Filter__c(Name ='resource-2',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =false, type_of_filter__c ='Resource'));

        //Insert filters
        insert filters;
        //List of role to insert.
        List<Krow__Krow_Role__c> roles = new List<Krow__Krow_Role__c>();
        
        roles.add(new Krow__Krow_Role__c(Name='Seller Onboarding Manager', Krow__Active__c = true));
        roles.add(new Krow__Krow_Role__c(Name='SIPM (Seller Integration Project Manager)', Krow__Active__c = true));
        roles.add(new Krow__Krow_Role__c(Name='SIE (Seller Integration Engineer)', Krow__Active__c = true));
        roles.add(new Krow__Krow_Role__c(Name='Consultant', Krow__Active__c = true));
        roles.add(new Krow__Krow_Role__c(Name='Buyer Onboarding Manager', Krow__Active__c = true));
        
        //insert roles.
        insert roles;
        
        //List of project to insert.
        List<Krow__Project__c> projects = new List<Krow__Project__c>();
        
        projects.add(new Krow__Project__c(Name='Test Project1', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project2', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project3', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project4', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project5', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project6', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project7', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project8', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project9', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project10', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project11', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project12', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project13', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project14', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project15', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project16', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project17', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project18', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project19', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project20', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project21', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project22', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project23', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project24', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project15', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project26', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project27', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project28', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project29', Krow__Project_Status__c = 'Queued for SIPM'));
        projects.add(new Krow__Project__c(Name='Test Project30', Krow__Project_Status__c = 'Queued for SIPM'));
        
        //insert project.
        insert projects;
        
        //insert user record.
        List<User> usersRecord = new List<User>();
        usersRecord.add(new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LastName = 'last',Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',Title = 'title',Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US'));
        
        usersRecord.add(new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LastName = 'last1',Email = 'puser1000@amamama.com', Username = 'puser1000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST1',Title = 'title1',Alias = 'alias1', TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US'));
        
        usersRecord.add(new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LastName = 'last2',Email = 'puser2000@amamama.com', Username = 'puser2000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST1',Title = 'title1',Alias = 'alias1', TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US'));
        insert usersRecord;
        
        //List of resource to insert.
        List<Krow__Project_Resources__c> resource = new List<Krow__Project_Resources__c>();
        resource.add(new Krow__Project_Resources__c(Name = 'Resource1', Krow__Project_Role__c = roles[0].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource2', Krow__Project_Role__c = roles[1].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource3', Krow__Project_Role__c = roles[2].Id, Krow__Active__c=true, Krow__User__c = usersRecord[2].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource4', Krow__Project_Role__c = roles[3].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource5', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource6', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource7', Krow__Project_Role__c = roles[0].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource8', Krow__Project_Role__c = roles[1].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource9', Krow__Project_Role__c = roles[2].Id, Krow__Active__c=true, Krow__User__c = usersRecord[2].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource10', Krow__Project_Role__c = roles[3].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource11', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource12', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource13', Krow__Project_Role__c = roles[0].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource14', Krow__Project_Role__c = roles[1].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource15', Krow__Project_Role__c = roles[2].Id, Krow__Active__c=true, Krow__User__c = usersRecord[2].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource16', Krow__Project_Role__c = roles[3].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource17', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource18', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource19', Krow__Project_Role__c = roles[0].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource20', Krow__Project_Role__c = roles[1].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource21', Krow__Project_Role__c = roles[2].Id, Krow__Active__c=true, Krow__User__c = usersRecord[2].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource22', Krow__Project_Role__c = roles[3].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource23', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource24', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource25', Krow__Project_Role__c = roles[0].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource26', Krow__Project_Role__c = roles[1].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource27', Krow__Project_Role__c = roles[2].Id, Krow__Active__c=true, Krow__User__c = usersRecord[2].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource28', Krow__Project_Role__c = roles[3].Id, Krow__Active__c=true, Krow__User__c = usersRecord[0].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource29', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        resource.add(new Krow__Project_Resources__c(Name = 'Resource30', Krow__Project_Role__c = roles[4].Id, Krow__Active__c=true, Krow__User__c = usersRecord[1].Id));
        
        //insert resource.
        insert resource;
        
        //insert projectAssignment Record.
        List<Krow__Project_Assignment__c> projectAssignment = new List<Krow__Project_Assignment__c>();
        projectAssignment.add(new Krow__Project_Assignment__c(Krow__Krow_Project__c = projects[7].Id, Krow__Role__c = roles[0].Id, Krow__Project_Resource__c = resource [0].Id, Krow__IsOwner__c = true));
        
        insert projectAssignment; 
        
     }
    
    /* 
    *	Description     :	This method is used test massProjectAssignment controller.
    *
    *	@argument		:		
    *
    *	Revision Logs   : 	V_1.0 - Created
    */
	 static testMethod void testMassProjectAssignment(){
		Test.startTest();
		
		MassProjectAssignmentController controller = new MassProjectAssignmentController();
		
		//======================================ProjectTest=============================
		//check assert
		system.assertEquals('Project', controller.wrapperType);
		system.assertEquals(2, controller.listOfListKrowProjects.size());
		system.assertEquals(true, controller.getFirstButtonDisabled());
		system.assertEquals(false, controller.getLastButtonDisabled());
		
		controller.next();
		controller.last();
		system.assertEquals(true, controller.getLastButtonDisabled());
		
		controller.previous();
		controller.first();
		system.assertEquals(true, controller.getFirstButtonDisabled());
		
		controller.filterRecord.Name = 'Test Project2';
		controller.saveFilters();
		controller.deleteSelectedFilter();
		system.assertEquals(2, controller.listOfListKrowProjects.size());
		system.assertEquals(true, controller.getFirstButtonDisabled());
		
		
		//======================================ResourceTest=============================
		controller.getAllResourcePlanner();
		
		//check assert
		system.assert(ApexPages.getMessages().size() == 1); 
    	system.assert(ApexPages.getMessages().get(0).getDetail() == 'Please select atleast one project.');
    	
		//select the projects
		controller.projectsWrapper[0].isSelect = true;
		controller.projectsWrapper[1].isSelect = true;
		controller.projectsWrapper[2].isSelect = true;
		controller.projectsWrapper[3].isSelect = true;
		
		
		controller.getAllResourcePlanner();
		system.assertEquals(4, controller.selectedProjectId.size());
		system.assertEquals(2, controller.listOfListResourceWrapper.size());
	
		controller.next();
		system.assertEquals(true, controller.getLastButtonDisabled());
		
		controller.first();
		system.assertEquals(true, controller.getFirstButtonDisabled());
        controller.last();
        controller.previous();
		
		system.assertEquals(true, controller.getFirstButtonDisabled());
		system.assertEquals(false, controller.getLastButtonDisabled());
		
		controller.filterRecordResource.Name = 'Resource3';
		controller.onSearch();
		
		//Select a resource.
		controller.selectedResourceId = controller.resources[2].recordId;
		controller.setSelectedResource();
		controller.moveToProjectPage();
		//===================================fill projectAssign=========================================
		
		Id roleId = [Select Id, Name From Krow__Krow_Role__c Where Name='SIPM (Seller Integration Project Manager)'].Id;
		controller.projectAssignment.roleId = roleId;
		controller.projectAssignment.startDate =  Date.newInstance(2019, 11, 9);
		controller.projectAssignment.endDate =  Date.newInstance(2019, 12, 9);
		controller.projectAssignment.isOwner = true;
		
		controller.assignProject();
		//system.assertEquals(false, controller.isAlertShown);
       
        List<Krow__Project_Assignment__c> projectAssignments = [Select Id, Name From Krow__Project_Assignment__c];
        
        system.assertEquals(1, projectAssignments.size());
        system.assert(ApexPages.getMessages().size() == 2); 
    	//system.assert(ApexPages.getMessages().get(1).getDetail().contains('Projects are assigned to'));
    	
    	//============================================back to home================
    	controller.backToHome();
		system.assertEquals('Project', controller.wrapperType);
        //system.assert(controller.projectsWrapper.size() == 26);
		system.assertEquals(2, controller.listOfListKrowProjects.size());
		system.assertEquals(true, controller.getFirstButtonDisabled());
		system.assertEquals(false, controller.getLastButtonDisabled());
		
		List<SelectOption> rolesOption = controller.getRoles();
		system.assertEquals(5, rolesOption.size());
		Test.stopTest();
	}	
}