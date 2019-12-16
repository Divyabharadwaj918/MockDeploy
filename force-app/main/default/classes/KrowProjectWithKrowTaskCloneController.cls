/**
 *  Description     :   Controller class for KrowProjectWithKrowTaskClone VF page.
 * 						This class will hold all the logics to clone the krow project and its related Krow tasks and first level of Parent Krow Task.
 *
 *  Created By      :  
 *
 *  Created Date    :   01/31/2019
 *
 *  Revision Logs   :   Created
 * 
 **/
public with sharing class KrowProjectWithKrowTaskCloneController {

    //Initialised the Variable
    Krow__Project__c krowProject; 

    //Constructor For KrowProjectWithKrowTaskCloneController
    public KrowProjectWithKrowTaskCloneController(ApexPages.StandardController controller) {

        //Get Current Krow project Record
        krowProject = (Krow__Project__c)controller.getRecord();

    }
    /**
     *  @description    :   This method is used to clone Krow Project and Its Related Task
     *                      
     *  @args           :   
     *
     *  @return         :   PageReference
     *
     *  @revision Log   :   Created
     *
     **/
    public PageReference clonekrowProject() {
 
        //SavePoint
        Savepoint sp = Database.setSavepoint();

        try {

            //Set to hold Krow Project Ids
            Set<Id> setKrowProjectsIds = new Set<Id>();
            
            //Check for detail page record (Detail Page clone case)
            if(krowProject != null && krowProject.Id != null)
                setKrowProjectsIds.add(krowProject.Id);

            //Global describe
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    
            //Map to hold krow projecttobeclone as Id and cloned Project as values
            Map<Id,Krow__Project__c> mapOfKrowProjects = new Map<Id,Krow__Project__c>();

            //Map to hold Krow Parent Task to be clone as Id and cloned Krow Parent Task as value
            Map<Id,Krow__Task__c> mapOfKrowParentTasks = new Map<Id,Krow__Task__c>();
            
            //Query through the Proposal
            List<Krow__Project__c> krowProjectToBeClone = (List<Krow__Project__c>)Database.query(buildSOQL(globalDescribe, 'Krow__Project__c') + ' Where Id IN :setKrowProjectsIds');

            //Check for the size
            if(krowProjectToBeClone.size() > 0) {

                //Cloned the Project
                List<Krow__Project__c> krowProjectCloned = krowProjectToBeClone.deepClone(false,false);

                //Loop over cloned project
                for(integer i= 0 ; i < krowProjectCloned.size() ;i++){
                
                    //Add to map
                    mapOfKrowProjects.put(krowProjectToBeClone[i].Id,krowProjectCloned[i]);
                }
                //Insert Cloned Krow Projects
                insert mapOfKrowProjects.values();

                for( Krow__Project__c kProject : krowProjectToBeClone){
                    kProject.Krow__Project_Template__c = true;
                }
                update krowProjectToBeClone;
            }

            //Set to hold Id
            set<Id> setOfKrowParentTask = new set<Id>();
            
            //Loop over
            for(Krow__Task__c krowTask : [Select Id, Krow__Parent_Task__c , Krow__Predecessor__c, Krow__Project__c From Krow__Task__c where Krow__Project__c IN:setKrowProjectsIds]) {

                //Check for child Krow Task
                if(krowTask.Krow__Parent_Task__c != null) {
                    setOfKrowParentTask.add(krowTask.Krow__Parent_Task__c);
                }

            }
            //Query on Krow Task
            List<Krow__Task__c> krowParentTaskTobeCloned = (List<Krow__Task__c>)Database.query(buildSOQL(globalDescribe, 'Krow__Task__c') + ' Where Krow__Project__c IN :setKrowProjectsIds AND ID IN:setOfKrowParentTask ');

            //Check for the size
            if(krowParentTaskTobeCloned.size() >0) {

                //Clone the Krow Project
                List<Krow__Task__c> krowParentTaskCloned = krowParentTaskTobeCloned.deepClone(false,true);
                
                //Loop over Parent Krow Task
                for(integer i= 0 ; i < krowParentTaskCloned.size() ;i++){
                    
                    krowParentTaskCloned[i].Krow__Project_Phase__c = false;
                    krowParentTaskCloned[i].Krow__Project__c = mapOfKrowProjects.get(krowParentTaskCloned[i].Krow__Project__c).Id;

                    //Add to map
                    mapOfKrowParentTasks.put(krowParentTaskTobeCloned[i].Id,krowParentTaskCloned[i]);
                }
                //Insert Cloned Krow Projects
                insert mapOfKrowParentTasks.values();
            }
            set<Id> parentTasks = mapOfKrowParentTasks.keyset();
            //Query on Krow Task
            List<Krow__Task__c> krowTaskTobeCloned = (List<Krow__Task__c>)Database.query(buildSOQL(globalDescribe, 'Krow__Task__c') + ' Where Krow__Project__c IN :setKrowProjectsIds AND Id NOT IN:setOfKrowParentTask');

            //Check for Parent Task
            if(krowTaskTobeCloned.size() >0){

                //Cloned the Project
                List<Krow__Task__c> krowTaskCloned = krowTaskTobeCloned.deepClone(false,true);
                
                //Loop over cloned project
                for(Krow__Task__c krowT :krowTaskCloned){

                    //Check for Parent
                    if(krowT.Krow__Parent_Task__c != null && mapOfKrowParentTasks.containsKey(krowT.Krow__Parent_Task__c)) {
                        krowT.Krow__Parent_Task__c = mapOfKrowParentTasks.get(krowT.Krow__Parent_Task__c).Id; 
                        
                    }

                    krowT.Krow__Project_Phase__c = false;
                    
                    //Process if condition is true
                    if(krowT.Krow__Project__c !=null && mapOfKrowProjects.containsKey(krowT.Krow__Project__c))
                        krowT.Krow__Project__c = mapOfKrowProjects.get(krowT.Krow__Project__c).Id;

                 }
                //Insert
                insert krowTaskCloned;
            }
            //Return
            return new PageReference('/'+mapOfKrowProjects.get(krowProject.Id).id);
         } 
        catch (Exception e){

            //Roll Back changes
            Database.rollback(sp);

            //Add error on pages
            ApexPages.addMessages(e);
         }
        
        //Return
        return null;
    }
    /**
     *  @description    :   This method is used to build the SOQL query string.
     *
     *  @args           :   Map<String, Schema.SObjectType>, String
     *
     *  @return         :   String
     *
     **/
    public String buildSOQL(Map<String, Schema.SObjectType> globalDescribe, String objName) {
        
        //SOQL query
        String SOQL = 'Select ';
        
        //Get the field of the object'
        for(String field : globalDescribe.get(objName).getDescribe().fields.getMap().keySet())
            SOQL += field + ',';
        
        //Remove extra elements and add object
        SOQL = SOQL.removeEnd(',') + ' From ' + objName;
        
        //Return 
        return SOQL;
        
    }
}