@isTest
public class TestFilterTriggerHelper {
   @testSetup
    static void testData(){
        
        List<Filter__c> filters = new List<Filter__c>();
        filters.add(new Filter__c(Name ='Project-1',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =true, type_of_filter__c ='Project'));
        filters.add(new Filter__c(Name ='Project-2',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =false,type_of_filter__c ='Project'));
 		filters.add(new Filter__c(Name ='resource-1',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =true,type_of_filter__c ='Resource'));
        filters.add(new Filter__c(Name ='resource-2',Project_Name__c ='Pro',User__c=UserInfo.getUserId(), Default__c =false, type_of_filter__c ='Resource'));

        //Insert filters
        insert filters;
        
    }        
        
        static testMethod void testFilters(){
             Test.StartTest();
            Filter__c filters = [Select Id,Default__c from Filter__c where Name ='Project-2' limit 1 ] ;
            
            system.assertEquals(false,filters.Default__c);
            
            filters.Default__c = true;
            update filters;
           
            Test.stopTest(); 
            

    }
    static testMethod void deleteFilters(){
          Test.startTest();
            List<Filter__c>  filters = [Select Id,Default__c from Filter__c where type_of_filter__c='Resource'] ;
        		system.assertequals(true,filters[0].Default__c);
        		system.assertEquals(false,filters[1].Default__c);
        Delete filters[0];
        Test.stopTest(); 
            Filter__c filt2 =[Select Id,Default__c from Filter__c where type_of_filter__c='Resource' limit 1];
            
        system.assertEquals(true,filt2.Default__c);
    }
    static testMethod void deleteFilters2(){
         List<Filter__c> filter = [Select Id,Default__c from Filter__c where type_of_filter__c='Project'  ];
            system.assertequals(false,filter[1].Default__c);
            system.assertEquals (true,filter[0].Default__c);
            Filter__c fil = new Filter__c();
            fil.Id = filter[0].Id;
            fil.Default__c = false;

            update  fil;
              List<Filter__c> filter1 = [Select Id,Name,Default__c from Filter__c where type_of_filter__c='Project'  ];
            system.debug('filter1'+filter1);
            system.assertEquals(true, filter[0].Default__c);
        
    }
}