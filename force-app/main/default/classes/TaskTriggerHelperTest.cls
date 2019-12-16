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
*   Description 	:   This class is used to cover the Task Trigger.
*
*   Created by      :   
*
*   Created Date    :   06/05/2019
*
*   Revision Log    :   V1.0 - Created
*  
*	Coverage		:  100%
**/
@isTest(seeAllData = false)
public class TaskTriggerHelperTest {

     /**
	*	@description	:	This method is used to create test data.
	*						
	*	@args			:	
	*
	*	@return			:	void  
	*/
    @testSetup
    public static void testData(){
        Contact con = new Contact(LastName = 'contact1', LeadSource = 'Marketing');
        //insert contact.
        insert con;
            
        //List is used to hold opportunity record.
        List<opportunity> listOfOpp = new List<opportunity>();
        
        listOfOpp.add(new Opportunity(Name = 'opp1',CloseDate = date.today(), Primary_Contact__c = con.Id,Trigger__c= 'Sales', StageName = '1 - Identify' , Type = 'New Business', TradeShift_Category__c = 'Closed', Region_Override__c = 'EMEA'));

        //Insert opportunity record.
        insert listOfOpp;
        
        //List to hold task record.
        List<Task> listOfTask = new List<Task>();
        
         List<RecordType> record =[Select Id  from RecordType where SobjectType ='TASK'];

        listOfTask.add(new Task(subject = 'task1', whatId = listOfOpp[0].Id, Priority = 'Normal', Status = 'Qualified',recordtypeId= record[0].Id));
        listOfTask.add(new Task(subject = 'task2', whatId = listOfOpp[0].Id, Priority = 'Normal', Status = 'Completed', recordtypeId= record[1].Id));
        listOfTask.add(new Task(subject = 'task3', whatId = listOfOpp[0].Id, Priority = 'Normal', Status = 'Open', recordtypeId= record[2].Id));
        listOfTask.add(new Task(subject = 'task4', whatId = listOfOpp[0].Id, Priority = 'Normal', Status = 'Not Started	', recordtypeId= record[3].Id));
        listOfTask.add(new Task(subject = 'task5', whatId = listOfOpp[0].Id, Priority = 'Normal', Status = 'In Progress	', recordtypeId= record[4].Id));
        
        //Insert task.
        insert listOfTask;
    }
    
     /**
	*	@description	:	This method is used to create test data.
	*						
	*	@args			:	
	*
	*	@return			:	void  
	*/
    public Static testMethod void testCreateTaskStatusTrackingRecord(){
        
        Test.startTest();
        
        //Query on Task_Status_Tracking__c
        List<Task_Status_Tracking__c> taskTrackings = [Select Id, Name From Task_Status_Tracking__c ];
        
        //chekc assert
        System.assertEquals(5, taskTrackings.size());
        
        //Query on task record to update one of them.
        List<Task> tasks = [Select Id, Status From Task Where Status = 'Not Started'];
        tasks[0].Status = 'Open';
        
        //update task
        update tasks;
        
		taskTrackings = [Select Id, Name From Task_Status_Tracking__c ];    
        System.assertEquals(6, taskTrackings.size());
        
        Test.stopTest();
        system.assertEquals(1, Limits.getEmailInvocations());
    }
}