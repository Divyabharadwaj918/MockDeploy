/**
* @author Pratibh Prakash
* @date 15-Mar-2017
* @description Utility Class contains method to create KROW Project and related data
* @last modified by 
*/
public with sharing class KrowUtility {
    
    //CONSTANTS
    public static final String defaultTemplate = 'Final UAT Project Template';
    
    //Class Variables
    public static Map<Id,Krow__Project__c> krowTemplateProjectById = new Map<Id,Krow__Project__c>(); //template project 
    public static Map<Id,Krow__Project__c> cloneProjectByTemplateId = new Map<Id,Krow__Project__c>(); // clone project by template project id  
    public static Map<Id,Krow__Task__c> cloneTaskByTemplateTaskId = new Map<Id,Krow__Task__c>(); // clone tasks by template task id
    public static Map<Id,Krow__Task__c> templateKrowTasksById = new Map<Id,Krow__Task__c>(); // template projects tasks  
    public static final Set<String> WEEKEND_DAYS = new Set<String> {'Sat','Sun'};
    public static set<String> newRootTaskIdSet = new set<String>();
    public static map<Id,Krow__Task__c> taskByIdForChild = new map<Id,Krow__Task__c>();
    public static Map<String,set<String>> childsByParentId = new map<String,set<String>>();
    public static String selectedTemplateId; //Vairable is set by Accept/Reject page controller, the value is the template selected by user.
    public static String newProjectId; // Static variable set by Utilty method which is used by Accept/Reject controller to return user to Krow Project detail page.
    public static Boolean projectExists = false; //Flag is set to true by Accept/Reject page controller when Project is already created for Opportunity,
	

    
    //Wrapper class to Krow Project
    public class KrowWrapper{
    	public String projectName;
    	public String description;
    	public Date startDate;
    	public String accountId;
    	public String opportunityId;
    	public String projectCurrency;
    	public String projectOwnerId;
    	public String projectTemplateId;
    	public String projectTemplateName;
    	public String accountExecutiveId;
    	public String serviceAccountManagerId;
    	public String solutionConsultantId;
    }
    
    /*
    Method to retrieve Project Templates
    */
    public static void retrieveTemplates(){	
    	krowTemplateProjectById = new Map<Id,Krow__Project__c>([Select id,Name,Krow__Billable__c,Krow__Project_Budget__c,Krow__Color__c,
                                                    			Krow__Description__c,Krow__Expected_Revenue__c,Krow__Planned_Hours__c,Krow__Project_Start_Date__c,
                                                    			Krow__Project_End_Date__c,Krow__Project_Status__c,Krow__Project_Type__c,Krow__Rate_Card__c                                                    
                                                    			,(select Krow__User__c,Krow__Project_Resource__c,Krow__Role__c,
                                                      			Krow__Mon__c,Krow__Tue__c,Krow__Wed__c,Krow__Thu__c,Krow__Fri__c,Krow__Sat__c,Krow__Sun__c 
                                                      			from Krow__ProjectAssignments__r
                                                      			where Krow__Project_Resource__c != null                                                      
                                                      			and Krow__IsOwner__c = false)
			                                                    from Krow__Project__c
			                                                    where Krow__Public_Project_Template__c = true
			                                                    and Krow__Project_Template__c = true
			                                                    order by CreatedDate asc]);
	}
	
	
	/*
	Method to create KROW Projects
	*/
	public static void createKrowProjects(List<KrowWrapper> krowWrpObjList){
		/*Condition when Project is already created for an Opportunity, this flag is set to true by Accept/Reject page controller.*/
		if(projectExists){
			return;
		}
		retrieveTemplates();
		
		Map<String,Krow__Project__c> templateKrowProjectByName = new Map<String,Krow__Project__c>();
		if(!krowTemplateProjectById.isEmpty()){
            for(Krow__Project__c krowProject : krowTemplateProjectById.values()){
                templateKrowProjectByName.put(krowProject.Name,krowProject);
            }
        }  
        
        String sourceProjectName  = '';  
        for(KrowWrapper wrpObj : krowWrpObjList){  
        	//Krow__Project__c templateProjectForClone = templateKrowProjectByName.get('Final UAT Project Template');
        	Krow__Project__c templateProjectForClone = krowTemplateProjectById.get(selectedTemplateId);
        	
        	if(templateProjectForClone != null){
            	Krow__Project__c  newClonedProject =  new Krow__Project__c(Name = wrpObj.projectName,
                                                                OwnerId = wrpObj.projectOwnerId,
                                                                Krow__Project_Start_Date__c = wrpObj.startDate,
                                                                Krow__Account__c = wrpObj.accountId,
                                                                Opportunity__c = wrpObj.opportunityId,
                                                                Account_Executive__c = wrpObj.accountExecutiveId,
                                                                Service_Account_Manager__c = wrpObj.serviceAccountManagerId,
                                                                Solution_Consultant__c = wrpObj.solutionConsultantId,
                                                                Project_Category__c = 'PS Sales');
                                                                
                newClonedProject.Krow__Description__c = templateProjectForClone.Name;
                newClonedProject.Krow__Billable__c = templateProjectForClone.Krow__Billable__c;
                newClonedProject.Krow__Project_Budget__c = templateProjectForClone.Krow__Project_Budget__c;
                newClonedProject.Krow__Color__c = templateProjectForClone.Krow__Color__c;
                newClonedProject.Krow__Description__c = templateProjectForClone.Krow__Description__c;
                newClonedProject.Krow__Expected_Revenue__c = templateProjectForClone.Krow__Expected_Revenue__c;
                newClonedProject.Krow__Planned_Hours__c = templateProjectForClone.Krow__Planned_Hours__c;
                newClonedProject.Krow__Project_Status__c = templateProjectForClone.Krow__Project_Status__c;
                newClonedProject.Krow__Project_Type__c = templateProjectForClone.Krow__Project_Type__c;
                newClonedProject.Krow__Rate_Card__c = templateProjectForClone.Krow__Rate_Card__c;
                
                cloneProjectByTemplateId.put(templateProjectForClone.Id,newClonedProject);
            }
        }
        
        if(!cloneProjectByTemplateId.isEmpty()){
            insert cloneProjectByTemplateId.values();
            
            createProjectOwnerAssignment();
            
            /* Clone Project Teams */
            cloneProjectTeams();
            
            /* Clone Tasks */
            cloneKrowTasks();
            newProjectId = cloneProjectByTemplateId.values()[0].Id;
            
            /* Copy Opportunity Contact Roles*/
            copyContactRoles();
        }
        
	}
	
	public static void createProjectOwnerAssignment(){
		List<Krow__Project_Assignment__c> ownerAssignmentList = new List<Krow__Project_Assignment__c>();
        try{
            for(Krow__Project__c project : cloneProjectByTemplateId.values()){
                ownerAssignmentList.add(getNewProjectAssignmentRowForOwner(project.Id,project.OwnerId));
            }
            system.debug('ownerAssignmentList===>'+ownerAssignmentList);
            if(!ownerAssignmentList.isEmpty()){
                insert ownerAssignmentList;
            }
        }catch(Exception ex){
            system.debug('exception in createProjectOwnerAssignment===>'+ex.getMessage()+' at line '+ex.getLineNumber());
        }
	}
	
	
	public static Krow__Project_Assignment__c getNewProjectAssignmentRowForOwner(String projectId, String projectOwnerId){
        
        Krow__Project_Assignment__c projectAssignmentObj = new Krow__Project_Assignment__c();
        projectAssignmentObj.Krow__Krow_Project__c = projectId;
        projectAssignmentObj.Krow__User__c = projectOwnerId != null ? projectOwnerId : UserInfo.getUserId();
        projectAssignmentObj.Krow__IsOwner__c = true;
        
        return projectAssignmentObj;
        
    }
    
    public static void cloneProjectTeams(){
        List<Krow__Project_Assignment__c> projectTeamsToInsert = new List<Krow__Project_Assignment__c>();
        try{
            for(Id templateId : cloneProjectByTemplateId.keySet()){
                Krow__Project__c templateProject = krowTemplateProjectById.get(templateId);
                Krow__Project__c cloneProject = cloneProjectByTemplateId.get(templateId);
                
                if(!templateProject.Krow__ProjectAssignments__r.isEmpty()){
                    
                    for(Krow__Project_Assignment__c teamMember : templateProject.Krow__ProjectAssignments__r){
                        
                        Krow__Project_Assignment__c cloneProjectTeamMember = new Krow__Project_Assignment__c();
                        cloneProjectTeamMember.Krow__Project_Resource__c = teamMember.Krow__Project_Resource__c;
                        cloneProjectTeamMember.Krow__IsOwner__c = false;
                        cloneProjectTeamMember.Krow__Krow_Project__c = cloneProject.Id;
                        cloneProjectTeamMember.Krow__User__c = teamMember.Krow__User__c;
                        cloneProjectTeamMember.Krow__Role__c = teamMember.Krow__Role__c;
                        cloneProjectTeamMember.Krow__Mon__c = teamMember.Krow__Mon__c;
                        cloneProjectTeamMember.Krow__Tue__c = teamMember.Krow__Tue__c;
                        cloneProjectTeamMember.Krow__Wed__c = teamMember.Krow__Wed__c;
                        cloneProjectTeamMember.Krow__Thu__c = teamMember.Krow__Thu__c;
                        cloneProjectTeamMember.Krow__Fri__c = teamMember.Krow__Fri__c;
                        cloneProjectTeamMember.Krow__Sat__c = teamMember.Krow__Sat__c;
                        cloneProjectTeamMember.Krow__Sun__c = teamMember.Krow__Sun__c;
                        projectTeamsToInsert.add(cloneProjectTeamMember);
                    }
                }
            }
            system.debug('projectTeamsToInsert===>'+projectTeamsToInsert);
            if(!projectTeamsToInsert.isEmpty()){
                insert projectTeamsToInsert;
            }
        }catch(Exception ex){
            system.debug('Exception in cloneProjectTeams>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
    }
    
    
    public static void cloneKrowTasks(){
        cloneTaskByTemplateTaskId = new Map<Id,Krow__Task__c>();
        Map<Id,List<Krow__Task__c>> krowTasksByTemplateProjectId = new Map<Id,List<Krow__Task__c>>();
        
         set<Id> oldRootTaskIdSet = new set<Id>();
         set<Id> oldChildTaskIds = new set<Id>();
         
        try{
            templateKrowTasksById = new Map<Id,Krow__Task__c>([select id,name,Krow__Priority__c,Krow__Due_date__c, Krow__Duration__c, Krow__Include_Weekends__c,
                                                            Krow__Start_Date__c,Krow__Project__c, Krow__Project__r.name,ownerid,owner.name,Krow__Assigned_By__c,Krow__Parent_task__c,
                                                            Krow__Parent_Task__r.name,Krow__Percent_Complete__c, Krow__Parent_Name_Track__c,Krow__Root__c,Krow__Root__r.Name,Krow__Status__c,
                                                            Krow__Milestone__c,Krow__Parent_Track__c,Krow__Start_Time__c,Krow__End_Time__c,Krow__Duration_Scale__c,
                                                            (select id,Krow__Source_Task__c,Krow__Target_Task__c,Krow__Type__c from Krow__Source_Tasks__r),
                                                            (select Id,Krow__Project_Resource__c,Krow__User__c
                                                             from Krow__Task_Assignments__r
                                                             where Krow__IsOwner__c = false
                                                             and Krow__Project_Resource__c != null)
                                                            from Krow__Task__c
                                                            where Krow__Project__c IN : cloneProjectByTemplateId.keySet()]);
                                                            
            system.debug('templateKrowTasksById===>'+templateKrowTasksById);                                                
            if(!templateKrowTasksById.isEmpty()){
                for(Krow__Task__c task : templateKrowTasksById.values()){
                    List<Krow__Task__c> templateProjectTaskList = krowTasksByTemplateProjectId.get(task.Krow__Project__c);
                    if(templateProjectTaskList == null){
                        templateProjectTaskList = new List<Krow__Task__c>();
                        krowTasksByTemplateProjectId.put(task.Krow__Project__c,templateProjectTaskList);
                    }
                    templateProjectTaskList.add(task);
                }
                
                
                for(Id templateId : cloneProjectByTemplateId.keySet()){
                    List<Krow__Task__c> templateTaskList = krowTasksByTemplateProjectId.get(templateId);
                    system.debug('templateTaskList===>'+templateTaskList);                                                
                    if(templateTaskList != null && !templateTaskList.isEmpty()){
                        Krow__Project__c cloneProject = cloneProjectByTemplateId.get(templateId);
                        for(Krow__Task__c templateTask : templateTaskList){
                            system.debug('templateTask ===>'+templateTask);                                                
                            Krow__Task__c newCloneTask = new Krow__Task__c();
                            newCloneTask.Name = templateTask.Name;
                            newCloneTask.Krow__Project__c = cloneProject.Id;
                            newCloneTask.Opportunity__c = cloneProject.Opportunity__c;
                            
                            if(templateTask.Krow__Root__c == null){
                                oldRootTaskIdSet.add(templateTask.id);
                            }
                            if(templateTask.Krow__Parent_Task__c != null){
                               oldChildTaskIds.add(templateTask.Id);
                            }
                            
                            newCloneTask.Krow__Priority__c = templateTask.Krow__Priority__c;
                            newCloneTask.OwnerId = templateTask.OwnerId;
                            newCloneTask.Krow__Assigned_By__c =  templateTask.Krow__Assigned_By__c;
                            newCloneTask.Krow__Priority__c = templateTask.Krow__Priority__c;
                            newCloneTask.Krow__Include_Weekends__c = templateTask.Krow__Include_Weekends__c;
                            newCloneTask.Krow__Percent_Complete__c = templateTask.Krow__Percent_Complete__c;
                            newCloneTask.Krow__Status__c = templateTask.Krow__Status__c;
                            newCloneTask.Krow__Milestone__c = templateTask.Krow__Milestone__c;
                            newCloneTask.Krow__Start_Time__c = templateTask.Krow__Start_Time__c;
                            newCloneTask.Krow__End_Time__c = templateTask.Krow__End_Time__c;
                            newCloneTask.Krow__Priority__c = templateTask.Krow__Priority__c;
                            
                            newCloneTask.Krow__Start_Date__c = cloneProject.Krow__Project_Start_Date__c != null ? cloneProject.Krow__Project_Start_Date__c : system.today();
                            newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Start_Date__c;
                            /*Integer sourceTaskDuration = templateTask.Krow__Duration__c != null ? Integer.valueOf(templateTask.Krow__Duration__c) : 0;
                            if(sourceTaskDuration > 0){
                                newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Include_Weekends__c 
                                                    ? newCloneTask.Krow__Start_Date__c.addDays((sourceTaskDuration - 1))
                                                    : calculateEndDateForTask(newCloneTask.Krow__Start_Date__c, sourceTaskDuration);
                            }
                            */
                            try{
                                if(templateTask.Krow__Duration_Scale__c == 'Day'){
                                    Integer sourceTaskDuration = templateTask.Krow__Duration__c != null ? Integer.valueOf(templateTask.Krow__Duration__c) : 0;
                                    /*
                                        The Task Due Date should be Task Start Date (Project Start Date) + Duration from the template
                                    */
                                    newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Start_Date__c;
                                    if(sourceTaskDuration > 0){
                                        newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Include_Weekends__c 
                                                            ? newCloneTask.Krow__Start_Date__c.addDays((sourceTaskDuration - 1))
                                                            : calculateEndDateForTask(newCloneTask.Krow__Start_Date__c, sourceTaskDuration);
                                    }
                                }else{
                                    
                                    if(newCloneTask.Krow__Include_Weekends__c){
                                        Integer duration = getDuration(newCloneTask.Krow__Include_Weekends__c, templateTask.Krow__Start_Date__c, templateTask.Krow__Due_Date__c);
                                        duration = duration > 0 ? duration - 1 : duration;//we can't add same days in the start date, because we are counting from start date.
                                        newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Start_Date__c.addDays(duration);
                                    } else{
                                        if(templateTask.Krow__Start_Date__c == null || templateTask.Krow__Due_Date__c == null){
                                            newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Start_Date__c;
                                        } else {
                                            Integer dayDiff = templateTask.Krow__Start_Date__c.daysBetween(templateTask.Krow__Due_Date__c);
                                            //dayDiff = dayDiff > 0 ? dayDiff - 1 : dayDiff;
                                            newCloneTask.Krow__Due_Date__c = newCloneTask.Krow__Start_Date__c.addDays(dayDiff);
                                        }
                                    }
                                    newCloneTask.Krow__Duration__c = templateTask.Krow__Duration__c;
                                }
                            }catch(Exception ex){system.debug('calculation duration in task==>'+newCloneTask+'=>'+ex.getMessage()+' at line '+ex.getLineNumber());}
                            //copy duration 
                            newCloneTask.Krow__Total_Duration__c = newCloneTask.Krow__Duration__c;
                            System.debug('--------------'+templateTask.Id+'---'+templateTask.Name);
                            System.debug('--------Clone------'+templateTask.Id+'---'+newCloneTask.Name);
                            cloneTaskByTemplateTaskId.put(templateTask.Id,newCloneTask);
                        }
                    }
                }
            }
            //system.debug('cloneTaskByTemplateTaskId===>'+cloneTaskByTemplateTaskId);                                                
            if(!cloneTaskByTemplateTaskId.isEmpty()){
                createOrUpdateKrowProcessSetting(false,true,true,false);
                insert cloneTaskByTemplateTaskId.values();
                createOrUpdateKrowProcessSetting(false,false,false,false);
                createOrUpdateKrowProcessSetting(true,false,false,true);
                /* create owner assignment */
                createOwnerAssignment();
                /* Task Teams */
                cloneTaskTeams();
                /* Task Link for Gantt chart */
                createTaskLink();
                createOrUpdateKrowProcessSetting(false,false,false,false);
                /* filter root task */
                filterRootTask(oldRootTaskIdSet);
                /* update parent and child relationship on new task based on old task */
                createOrUpdateKrowProcessSetting(true,false,false,false);
                updateRelationshipOnTask(oldRootTaskIdSet,oldChildTaskIds);
                
                /* delete child task from section */                
                deleteTasksJunction();
                
                /* here clone section and task under section */
                cloneProjectSectionWithTask();
            }
            
        }catch(Exception ex){
            system.debug('Exception in cloneKrowTasks>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
        createOrUpdateKrowProcessSetting(false,false,false,false);
    }
    
    public static void createOwnerAssignment(){
        try{
            Map<Id,Krow__Task_Assignment__c> ownerTaskAssignmentByTemplateTaskId = getOwnerTaskAssignmentsByTaskId(templateKrowTasksById.keySet());
            if(!ownerTaskAssignmentByTemplateTaskId.isEmpty()){
                copyOwnerTaskAssignmentOnOldToNewTask(ownerTaskAssignmentByTemplateTaskId);
            }
        }catch(Exception ex){
            system.debug('Exception in createOwnerAssignment>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
    }
    
    public static Map<Id,Krow__Task_Assignment__c> getOwnerTaskAssignmentsByTaskId(Set<Id> taskIds){
        Map<Id,Krow__Task_Assignment__c> ownerTaskAssignmentListByTaskId = new Map<Id,Krow__Task_Assignment__c>();
        
        List<Krow__Task__c> taskList = new List<Krow__Task__c>([select id,Name,
                                   (select id,Krow__Project_Resource__c,Krow__User__c,Krow__IsOwner__c
                                    from Krow__Task_Assignments__r
                                    where Krow__IsOwner__c = true
                                    and Krow__Project_Resource__c != null
                                    limit 1) 
                                   from Krow__Task__c
                                   where Id IN:taskIds]); 
                                   
        if(!taskList.isEmpty()){
            for(Krow__Task__c krowTask : taskList){
                if(!krowTask.Krow__Task_Assignments__r.isEmpty()){
                    ownerTaskAssignmentListByTaskId.put(krowTask.Id,krowTask.Krow__Task_Assignments__r.get(0));
                }
            }
        }
        return ownerTaskAssignmentListByTaskId;
    }
    
    public static void copyOwnerTaskAssignmentOnOldToNewTask(Map<Id,Krow__Task_Assignment__c> ownerTaskAssignmentByTemplateTaskId){
        List<Krow__Task_Assignment__c> ownerAssignmentForInsert = new List<Krow__Task_Assignment__c>();
        if(!cloneTaskByTemplateTaskId.isEmpty() && !ownerTaskAssignmentByTemplateTaskId.isEmpty()){
            
            for(Id oldTaskId : cloneTaskByTemplateTaskId.keySet()){
                
                Krow__Task__c oldTask = templateKrowTasksById.get(oldTaskId);
                Krow__Task__c newTask = cloneTaskByTemplateTaskId.get(oldTaskId);
                if(newTask.Krow__Assigned_By__c != null){
                    Krow__Task_Assignment__c ownerAssignment = ownerTaskAssignmentByTemplateTaskId.get(oldTaskId);
                    Krow__Task_Assignment__c newOwner = new Krow__Task_Assignment__c();
                    newOwner.Krow__Krow_Task__c = newTask.Id;
                    newOwner.Krow__IsOwner__c =  true;
                    
                    if(ownerAssignment.Krow__User__c == null){
                        newOwner.Krow__Project_Resource__c = ownerAssignment.Krow__Project_Resource__c;
                    }else{
                        newOwner.Krow__User__c = newTask.OwnerId != null ? newTask.OwnerId : userinfo.getuserid();
                        newOwner.Krow__Project_Resource__c = ownerAssignment.Krow__Project_Resource__c;
                    }
                    ownerAssignmentForInsert.add(newOwner);
                }                
            }
        }
        if(!ownerAssignmentForInsert.isEmpty()){
            insert ownerAssignmentForInsert;
        }
        
    }
    
    /*
    * Method to clone task teams
    */
    public static void cloneTaskTeams(){
        List<Krow__Task_Assignment__c> taskTeamsToInsert  = new List<Krow__Task_Assignment__c>(); 
        try{
            for(Id templateTaskId : cloneTaskByTemplateTaskId.keySet()){
                Krow__Task__c templateTask = templateKrowTasksById.get(templateTaskId);
                Krow__Task__c cloneTask = cloneTaskByTemplateTaskId.get(templateTaskId);
                
                if(templateTask != null && !templateTask.Krow__Task_Assignments__r.isEmpty()){
                    for(Krow__Task_Assignment__c templateTaskTeamMember : templateTask.Krow__Task_Assignments__r){
                        Krow__Task_Assignment__c cloneTeamMember = new Krow__Task_Assignment__c();
                        cloneTeamMember.Krow__Krow_Task__c = cloneTask.Id;
                        cloneTeamMember.Krow__Project_Resource__c = templateTaskTeamMember.Krow__Project_Resource__c;
                        
                        taskTeamsToInsert.add(cloneTeamMember);
                    }
                }
            }
            
            if(!taskTeamsToInsert.isEmpty()){
                insert taskTeamsToInsert;
            }
        }catch(Exception ex){
            system.debug('Exception in cloneTaskTeams>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
    }
    
    /* 
	* Method to create link between new created task based on old task.
    * save the tasks dependencies for Gantt chart
    */
    public static void createTaskLink(){
        List<Krow__Task_Link__c> taskLinkListForInsert = new List<Krow__Task_Link__c>();
        for(Krow__Task__c templateTask : templateKrowTasksById.values()){
            if(!templateTask.Krow__Source_Tasks__r.isEmpty()){
                for(Krow__Task_Link__c link : templateTask.Krow__Source_Tasks__r){
                    Id templateSourceTaskId = link.Krow__Source_Task__c;
                    Id templateTargetTaskId = link.Krow__Target_Task__c;
                    Krow__Task__c newCloneSourceTask = cloneTaskByTemplateTaskId.get(templateSourceTaskId);
                    Krow__Task__c newCloneTargetTask =  cloneTaskByTemplateTaskId.get(templateTargetTaskId);
                    if(newCloneSourceTask != null && newCloneTargetTask != null){
                        taskLinkListForInsert.add(new Krow__Task_Link__c(Krow__Source_Task__c = newCloneSourceTask.Id,Krow__Target_Task__c = newCloneTargetTask.Id,Krow__Type__c = link.Krow__Type__c));
                    }
                }
            }
        }
        if(!taskLinkListForInsert.isEmpty()){
            insert taskLinkListForInsert;
        }
    }
    
    public static void filterRootTask(set<Id> oldRootTaskIdSet){
        
        if(!oldRootTaskIdSet.isEmpty()){
            for(Id templateRootTaskId : oldRootTaskIdSet){
                Krow__Task__c newTask = cloneTaskByTemplateTaskId.get(templateRootTaskId);
                
                newRootTaskIdSet.add(newTask.Id);
            }
        }
        
    }
    
    public static void updateRelationshipOnTask(set<Id> oldRootTaskIdSet,set<Id> oldChildTaskIds){
        List<Krow__Task__c> childTaskToUpdate = new List<Krow__Task__c>();
        List<Krow__Task__c> immediateChildTaskToUpdate = new List<Krow__Task__c>();
        try{
            for(String oldTaskId : oldChildTaskIds){
                Krow__Task__c oldTask = templateKrowTasksById.get(oldTaskId);
                Krow__Task__c newTask = cloneTaskByTemplateTaskId.get(oldTaskId);
                
                Id newParentId = cloneTaskByTemplateTaskId.get(oldTask.Krow__Parent_Task__c) != null ? cloneTaskByTemplateTaskId.get(oldTask.Krow__Parent_Task__c).Id : null;
                if(newTask != null && newTask.Id != null && newParentId != null){
                    childTaskToUpdate.add(new Krow__Task__c(id= newTask.Id,Krow__Parent_Task__c = newParentId,Krow__Parent_Name_Track__c = oldTask.Krow__Root__r.Name));
                }
            }
            
            
            if(!childTaskToUpdate.isEmpty()){
                childTaskToUpdate = updateParentTrack(childTaskToUpdate,newRootTaskIdSet);
                update childTaskToUpdate;
            }
        }catch(Exception ex){
            system.debug('Exception in updateRelationshipOnTask>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
    }
    
    private static List<Krow__Task__c> updateParentTrack(List<Krow__Task__c> tasks,set<String> rootIds){
        taskByIdForChild =  new map<Id,Krow__Task__c>(tasks);
        try{
        for(Krow__Task__c t :tasks){
            set<String> childTasks = childsByParentId.get(t.Krow__Parent_Task__c);
            if(childTasks == null){
                childTasks = new set<String>();
                childsByParentId.put(t.Krow__Parent_Task__c,childTasks);
            }
            childTasks.add(t.id);
        }
        // update immediate Child
        for(String rootID : rootIds){
            set<String> childIds = childsByParentId.get(rootID);
            if(childIds != null){
                traverseChilds(childIds,rootID);
            }
            
        }
        }catch(Exception ex){system.debug('Exception in updateParentTrack==>'+ex + 'at line '+ex.getLineNumber());}
        return taskByIdForChild.values();
    }
    
    public static void deleteTasksJunction(){
        try{
        		
        	Map<Id,Krow__Project__c> cloneProjectById = new Map<Id,Krow__Project__c>(cloneProjectByTemplateId.Values());
        	
        	Krow__Task_Section__c[] existingSection_NONDEFAULT = [Select Id from Krow__Task_Section__c where Krow__Section_Type__c!=null and Krow__Project__c IN: cloneProjectById.keySet()];
        	delete existingSection_NONDEFAULT;
            
            if(!cloneProjectById.isEmpty() && !cloneProjectById.keySet().isEmpty()){
                Map<Id,Krow__Task__c> childTasks = new Map<Id,Krow__Task__c>([select id 
                                                                      from Krow__Task__c
                                                                      where Krow__Project__c IN : cloneProjectById.keySet()]);
                if(!childTasks.isEmpty()){
                    List<Krow__Task_Section_Junction__c> cloneProjectDefaultJunctionsEntry = new List<Krow__Task_Section_Junction__c>([select id 
                                                                                                                                       from Krow__Task_Section_Junction__c
                                                                                                                                       where Krow__Task__c IN: childTasks.keySet()
                                                                                                                                       and Krow__Task_Section__r.Krow__Section_Type__c = null
                                                                                                                                       and Krow__Task_Section__r.Krow__Project__c IN: cloneProjectById.keySet()]); 
                                                                                                                                       
                    delete cloneProjectDefaultJunctionsEntry;
                }
            }
        }catch(Exception ex){
            system.debug('Exception in deleteTasksJunction>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }
        
    }
    
    public static void traverseChilds(set<String> childList,String rootID){
        for(String cId : childList){
            Krow__Task__c childTask = taskByIdForChild.get(cId);
            Krow__Task__c parentTask = taskByIdForChild.get(childTask.Krow__Parent_Task__c);
            childTask.Krow__Parent_Track__c = (parentTask != null && parentTask.Krow__Parent_Track__c != null) ?(childTask.Krow__Parent_Task__c+','+parentTask.Krow__Parent_Track__c) : childTask.Krow__Parent_Task__c;
            childTask.Krow__Root__c = rootID;
            taskByIdForChild.put(childTask.Id,childTask); 
            set<String> childs =  childsByParentId.get(cId);
            if(childs != null){
                traverseChilds(childs,rootID);
            }
        }
    }
    
    public static Boolean isWorkingDay(DateTime sourceDT){
        return !WEEKEND_DAYS.contains(sourceDT.format('EEE'));
    }
    
    public static Date calculateEndDateForTask(Date taskStartDate, Integer duration){
        Datetime endDate = Datetime.newInstance(taskStartDate, Time.newInstance(0, 0, 0, 0));
        
        while(duration > 0){
            if(isWorkingDay(endDate)){
                duration--;
            }
            endDate = endDate.addDays(1);
        }
        endDate = endDate.addDays(-1);
        return endDate.date(); 
    }
    
    public static Integer getDuration(Boolean isWeekEndInclude, Date startDate, Date endDate){
        //save some calculations when the number of working days is 0
        if(startDate == null || endDate == null) {
            return 0;
        } 
        else {
            Integer difference = startDate.daysBetween(endDate); 
            if(difference == 0) {
                //If the 2 dates are the same day check if the day is a working day or not              
                return (isWorkingDay(startDate) || isWeekEndInclude) ? 1 : 0;
            } 
            else if(isWeekEndInclude) {
                //when every day is a working day return the difference
                return difference+1;
            } 
            else {
                // here we don't count sat,sunday in duration
                Integer workingDays = 0 ;
                for(Integer i=0; i<=difference; i++ ){
                    Date currentDate = startDate.addDays(i);
                    if(isWorkingDay(currentDate))
                        workingDays++;
                }
                return workingDays;
            }
        }
    }
    
    public static void cloneProjectSectionWithTask(){
    	System.debug('------------krowTemplateProjectById.values()='+krowTemplateProjectById.values());
        List<Krow__Task_Section_Junction__c> taskSectionJunctionCloneToInsert =  new List<Krow__Task_Section_Junction__c>();
        Map<Id,Krow__Task_Section__c> cloneSectionByTemplateSectionId = new Map<Id,Krow__Task_Section__c>();
        Map<Id,Id> oldProjectDefaultSectionIDByProjectId = new Map<Id,Id>();
        Map<Id,Id> defaultProjectSectionIdByProjectId = new Map<Id,Id>();
        try{
            Map<Id,List<Krow__Task_Section__c>> sectionListByProjectId = getSectionOfProjects(krowTemplateProjectById.keySet());
            if(!sectionListByProjectId.isEmpty()){
                for(Krow__Project__c tempateProject : krowTemplateProjectById.values()){
                    List<Krow__Task_Section__c> templateProjectSectionList = sectionListByProjectId.get(tempateProject.Id);
                    if(templateProjectSectionList != null){
                        Krow__Project__c cloneProject = cloneProjectByTemplateId.get(tempateProject.Id);
                        System.debug('----HERE----');
                        for(Krow__Task_Section__c ts : templateProjectSectionList){
                        	System.debug('----ts.Name='+ts.Name+'-----tempateProject.Name='+tempateProject.Name);
                            if(ts.Name != tempateProject.Name){ 
                                cloneSectionByTemplateSectionId.put(ts.Id,new Krow__Task_Section__c(Name = ts.Name,Krow__Project__c = cloneProject.Id,Krow__Sequence__c = ts.Krow__Sequence__c));
                            }else{
                                oldProjectDefaultSectionIDByProjectId.put(tempateProject.Id,ts.Id);
                            }
                        } 
                    }
                    
                }
                System.debug('-------------cloneSectionByTemplateSectionId.size()='+cloneSectionByTemplateSectionId);
                if(!cloneSectionByTemplateSectionId.isEmpty()){
                    insert cloneSectionByTemplateSectionId.values();
                    Set<Id> rootTasksId = new Set<Id>();
                    
                    Map<Id,List<Krow__Task_Section_Junction__c>> junctionBySection = getTaskSectionJunctionBySectionId(cloneSectionByTemplateSectionId.keySet());
                    system.debug('junctionBySection===>'+junctionBySection);
                    
                    if(!junctionBySection.isEmpty()){
                        /* START loop over section */
                        for(Id templateSectionId : junctionBySection.keySet()){
                            Id newSectionId = cloneSectionByTemplateSectionId.get(templateSectionId).Id;
                            system.debug('junctionBySection===>'+newSectionId); 
                            if(newSectionId != null){
                                List<Krow__Task_Section_Junction__c> tsjList = junctionBySection.get(templateSectionId);
                                system.debug('tsjList===>'+tsjList); 
                                if(tsjList != null && !tsjList.isEmpty()){
                                    Decimal lastSequence = 0; 
                                    List<Krow__Task_Section_Junction__c> unOrderTaskJunctions = new List<Krow__Task_Section_Junction__c>(); 
                                    for(Krow__Task_Section_Junction__c tsj :tsjList){
                                        Id newTaskId = cloneTaskByTemplateTaskId.get(tsj.Krow__task__c).Id;
                                        if(newTaskId != null){
                                            taskSectionJunctionCloneToInsert.add(new Krow__Task_Section_Junction__c(Krow__task__c = newTaskId,Krow__Task_Section__c = newSectionId,Krow__Sequence__c = tsj.Krow__Sequence__c));
                                        } 
                                    }
                                }
                                
                            }
                        }
                        system.debug('taskSectionJunctionCloneToInsert===>'+taskSectionJunctionCloneToInsert); 
                        if(!taskSectionJunctionCloneToInsert.isEmpty()){
                            insert taskSectionJunctionCloneToInsert;
                        }
                        /* END Section*/ 
                    }
                    
                    taskSectionJunctionCloneToInsert =  new List<Krow__Task_Section_Junction__c>();
                    /*START  Default section */
                    defaultProjectSectionIdByProjectId = getDefaultSectionListByProjects(cloneProjectByTemplateId.values());
                    Map<Id,List<Krow__Task_Section_Junction__c>> oldDefaultJunctionBySection = getTaskSectionJunctionBySectionId(new set<ID>(oldProjectDefaultSectionIDByProjectId.values()));
                    Map<Id,Decimal> lastSequenceByProjectId = new Map<Id,Decimal>();
                    for(Id templateProjectId : cloneProjectByTemplateId.keySet()){
                        Krow__Project__c cloneProject = cloneProjectByTemplateId.get(templateProjectId);
                        Id cloneDefaultSectionId = defaultProjectSectionIdByProjectId.get(cloneProject.Id);
                        List<Krow__Task_Section_Junction__c> defaultSectionJunctionList = oldDefaultJunctionBySection.get(oldProjectDefaultSectionIDByProjectId.get(templateProjectId));
                        if(cloneDefaultSectionId != null && !defaultSectionJunctionList.isEmpty()){
                            Decimal lastSequence = 0; 
                            List<Krow__Task_Section_Junction__c> unOrderTaskJunctions = new List<Krow__Task_Section_Junction__c>(); 
                            for(Krow__Task_Section_Junction__c tsj :defaultSectionJunctionList){
                                system.debug(tsj.Krow__Task__r.Name+'<===default section==>'+tsj);
                                Id newTaskId = cloneTaskByTemplateTaskId.get(tsj.Krow__task__c).Id;
                                if(newTaskId != null){
                                    taskSectionJunctionCloneToInsert.add(new Krow__Task_Section_Junction__c(Krow__Task__c = newTaskId,Krow__Task_Section__c = cloneDefaultSectionId,Krow__Sequence__c = tsj.Krow__Sequence__c));                                    
                                } 
                            }
                        } 
                        
                    }
                }
            }
            if(!taskSectionJunctionCloneToInsert.isEmpty()){                    
                    insert taskSectionJunctionCloneToInsert;
            }
        }catch(Exception ex){
            system.debug('Exception in cloneProjectSectionWithTask>>'+ex.getMessage() + ' at line '+ex.getLineNumber());
        }        
    }
    
    public static Map<Id,List<Krow__Task_Section__c>> getSectionOfProjects(Set<ID> projectIDs){  
        Map<Id,List<Krow__Task_section__c>> sectionsByProjectId = new Map<Id,List<Krow__Task_Section__c>>();
        try{
            List<Krow__Task_section__c> projectSections = new List<Krow__Task_Section__c>([select id,Name,Krow__Project__c,Krow__Sequence__c 
                                                                                           from Krow__Task_Section__c 
                                                                                           where Krow__Project__c IN : projectIDs
                                                                                           //and Krow__Section_Type__c = null
                                                                                           order by Krow__Project__c asc,Krow__Sequence__c asc]);
            if(!projectSections.isEmpty()){
                for(Krow__Task_Section__c ts :  projectSections){
                    List<Krow__Task_section__c> taskSections = sectionsByProjectId.get(ts.Krow__Project__c);
                    if(taskSections == null){
                        taskSections = new List<Krow__Task_Section__c>();
                        sectionsByProjectId.put(ts.Krow__Project__c,taskSections);
                    }
                    taskSections.add(ts);
                }
            }
        }catch(Exception ex){}
        return sectionsByProjectId;
    }
    
    public static Map<Id,List<Krow__Task_Section_Junction__c>> getTaskSectionJunctionBySectionId(Set<Id> sectionIDs){
        Map<Id,List<Krow__Task_Section_Junction__c>> junctionBySectionId = new Map<Id,List<Krow__Task_Section_Junction__c>>();
        try{ 
            List<Krow__Task_Section_Junction__c> taskSectionJunctionList = new List<Krow__Task_Section_Junction__c>([select id,Krow__Task__c,Krow__Task__r.Name,Krow__Task_Section__c,Krow__Sequence__c 
                                                                                                       from Krow__Task_section_Junction__c where Krow__Task_Section__c IN : sectionIDs
                                                                                                       order by Krow__Task_Section__c asc NULLS LAST ,Krow__Sequence__c asc NULLS LAST]);
            
            if(!taskSectionJunctionList.isEmpty()){
                for(Krow__Task_Section_Junction__c tsj : taskSectionJunctionList){
                    
                    List<Krow__Task_Section_Junction__c> tsjList = junctionBySectionId.get(tsj.Krow__Task_Section__c);
                    if(tsjList == null){
                        tsjList = new List<Krow__Task_Section_Junction__c>();
                        junctionBySectionId.put(tsj.Krow__Task_Section__c,tsjList);
                    }
                    tsjList.add(tsj);
                }
            }
        }catch(Exception ex){system.debug('Exception in getTaskSectionJunctionBySectionId=>'+ex);}
        
        return junctionBySectionId;
    }
    
    public static Map<Id,Id> getDefaultSectionListByProjects(List<Krow__Project__c> projectList){
        Map<Id,Id> defaultProjectSectionIdByProjectId = new Map<Id,Id>();
        try{
            if(projectList != null && !projectList.isEmpty()){
                String projectIDs = '('; 
                String sectioNamesStr ='(';
                for(Krow__Project__c p : projectList){       
                    sectioNamesStr += '\''+p.Name+'\',';
                    projectIDs += '\''+p.id+'\',';
                }
                sectioNamesStr = sectioNamesStr.substring(0,sectioNamesStr.length() -1);
                sectioNamesStr += ')';
                projectIDs = projectIDs.substring(0,projectIDs.length() -1);
                projectIDs += ')';
                String query = 'SELECT Id, Name, Krow__Project__c ';
                query += ' FROM Krow__Task_Section__c';
                query += ' Where Name IN '+sectioNamesStr;
                query += ' And Krow__Project__c != null ';
                query += ' and Krow__Project__c IN '+projectIDs; 
            
                List<Krow__Task_Section__c> sectionList = Database.query(query);
                Map<Id,List<Krow__Task_Section__c>> projectSectionsByProjectId = new Map<Id,List<Krow__Task_Section__c>>();
                if(sectionList != null && !sectionList.isEmpty()){
                    for(Krow__Task_Section__c ts : sectionList){
                        List<Krow__Task_Section__c> projectSections = projectSectionsByProjectId.get(ts.Krow__Project__c);
                        if(projectSections == null){
                            projectSections = new List<Krow__Task_Section__c>();
                            projectSectionsByProjectId.put(ts.Krow__Project__c,projectSections);
                        }
                        projectSections.add(ts);
                    }
                    for(Krow__Project__c p : projectList){
                        List<Krow__Task_Section__c> projectSections = projectSectionsByProjectId.get(p.id);
                        if(projectSections != null && !projectSections.isEmpty()){
                            for(Krow__Task_Section__c ts : projectSections){
                                if(ts.Name.toLowerCase() == p.Name.toLowerCase() && ts.Krow__Project__c == p.Id){
                                    defaultProjectSectionIdByProjectId.put(p.id,ts.Id);
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){system.debug(e.getMessage()+' at line number '+e.getLineNumber());}
        return defaultProjectSectionIdByProjectId;
    }
    
    /*
    Method to update Krow setting during automations
    */
    public static void createOrUpdateKrowProcessSetting(Boolean notRecursive,Boolean unAssignedTask,
                                                        Boolean stopCreateTaskOwnerAssignment,Boolean stopTaskStatusUpdate){
        
        Krow__Trigger_Settings__c krowTriggerSetting = Krow__Trigger_Settings__c.getValues('Default');
        if(krowTriggerSetting == null){
            krowTriggerSetting = new Krow__Trigger_Settings__c(Name = 'Default');
            
        }
        krowTriggerSetting.Krow__Disable_Krow_Task_Trigger__c = notRecursive;
        krowTriggerSetting.Krow__Disable_Task_Assignment_If_Unassigned__c = unAssignedTask;
        krowTriggerSetting.Krow__Disable_Default_Task_Owner_Assignment__c = stopCreateTaskOwnerAssignment;
        krowTriggerSetting.Krow__Disable_Section_Change_on_Status_Change__c = stopTaskStatusUpdate;
        upsert krowTriggerSetting;
        
    }
    
    /*
    Method to copy Opportunity Contact Roles to Project.
    */
    public static void copyContactRoles(){
    	Set<String> opportunityIds = new Set<String>();
    	
    	for(Integer i=0; i<cloneProjectByTemplateId.values().size(); i++){
    		opportunityIds.add(cloneProjectByTemplateId.values()[i].Opportunity__c);
    	}
    	
    	Map<String, List<OpportunityContactRole>> opportunity_ContactRoleMap = new Map<String, List<OpportunityContactRole>>();
    	
    	OpportunityContactRole[] opportunityContactRoles = [Select Role, OpportunityId, IsPrimary, ContactId 
    														from OpportunityContactRole 
    														where OpportunityId in:opportunityIds];
    				
    	for(Integer i=0; i<opportunityContactRoles.size(); i++){
    		if(!opportunity_ContactRoleMap.containsKey(opportunityContactRoles[i].OpportunityId)){
    			opportunity_ContactRoleMap.put(opportunityContactRoles[i].OpportunityId, new List<OpportunityContactRole>());
    		}
    		opportunity_ContactRoleMap.get(opportunityContactRoles[i].OpportunityId).add(opportunityContactRoles[i]);
    	}		
    	
    	List<Project_Contact_Roles__c> projectContactRoleForInsert = new List<Project_Contact_Roles__c>();
    	
    	
    	for(Integer i=0; i<cloneProjectByTemplateId.values().size(); i++){
    		if(opportunity_ContactRoleMap.get(cloneProjectByTemplateId.values()[i].Opportunity__c)!=null){
    			for(OpportunityContactRole contactRoleObj: opportunity_ContactRoleMap.get(cloneProjectByTemplateId.values()[i].Opportunity__c)){
    				Project_Contact_Roles__c tempObj = new Project_Contact_Roles__c();
		    		tempObj.Contact__c = contactRoleObj.ContactId;
		    		tempObj.Krow_Project__c = cloneProjectByTemplateId.values()[i].Id;
		    		tempObj.Role__c = contactRoleObj.Role;
		    		tempObj.Is_Primary__c = contactRoleObj.IsPrimary;
		    		projectContactRoleForInsert.add(tempObj);
    			}
    		}
    	}
    	
    	if(opportunityContactRoles.size()>0){
    		insert projectContactRoleForInsert;
    	}
    }
    
}