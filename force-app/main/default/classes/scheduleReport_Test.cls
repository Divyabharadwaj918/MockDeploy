@isTest(SeeAllData=true) 
public class scheduleReport_Test{
 
  private static testMethod void test_execute_UseCase1(){
 
  LIST<Report> reportlist=[SELECT CreatedById,CreatedDate,Description,DeveloperName,FolderName,Id,Name,OwnerId FROM Report ]; 
                               System.debug('===repostlist is'+reportlist);
                                System.debug('===repostlist is'+reportlist.size());
   // System.assertEquals(true,reportlist.size()>0);
      scheduleReport  obj01 = new scheduleReport ();
      obj01.execute(null);
      
      ScheduleResourceManagementReport  obj02 = new ScheduleResourceManagementReport ();
      obj02.execute(null);
      ScheduleM5_GoLiveReport  obj03 = new ScheduleM5_GoLiveReport ();
      obj03.execute(null);
    
  }
  
}