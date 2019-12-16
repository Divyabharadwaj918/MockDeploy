/**
* Description     -   This is controller class for MassProjectResourceAssignment page.
* 
* Created by      -   
* 
* Created Date    -   03/24/2019
*
* Revision log    -   V_1.0
*                   
*/
public class MassProjectAssignmentController {
    
    //Variable to hold page size.
    private final Integer PAGE_SIZE = 25;
    
    //List to hold resource wrapper.
    @TestVisible
    private List<ResourceWrapper> resources;
    
    //List of list to hold wrapper data by indexing.
    @TestVisible
    private List<List<ResourceWrapper>> listOfListResourceWrapper;
    
    //List to hold filter wrapper of resource.
    private List<ResourceWrapper> filteredResourceWrapper;
    
    //List of list of projects.
    public List<List<ProjectWrapper>> listOfListKrowProjects {get; set;}
    
    //Boolean to display Spinner
    public String defaultValue{get;set;} 
    
    //Instance to hold filter Object
    public Filter__c filterRecord {get; set;}
    
    //Filter Records
    public List<SelectOption> options {get;set;}
    
    //variable to hold select resource.
    private ResourceWrapper selectedResource;
    
    //List to hold projectWrapper.
    @TestVisible
    private List<ProjectWrapper> projectsWrapper;
    
    
    //Variable for page number.
    public Integer pageNumber {get; set;}
    public Integer totalNoOfPageResource {get; set;}
    
    //Variable for page number for project.
    public Integer pageNumberProject {get; set;}
    public Integer totalNoOfPageProject {get; set;}
    
    //variable to hold project id.
    public String wrapperType {get; set;}
    
    //id to hold selected resource id.
    public Id selectedResourceId {get; set;}
    
    //List to hold selected project id.
    public List<Id> selectedProjectId {get; set;}
    
    public Map<Id, Filter__c> mapFilter {get;set;}
    
    //Variable to check alert.
    public Boolean isAlertShown {get; set;}
    public Filter__c filterRecordResource{get;set;}
    
    //Size of List
    public Integer filterSize{get;set;}
    
    //Project assignment instance.
    public projectAssignWrapper projectAssignment {get; set;}
    public boolean resourceScreen {get; set;}
    //Map of role.
    private Map<Id, Krow__Krow_Role__c> mapOfRoles;
    
    public String arrowDirection {get;set;}
    
    public String sortField {get;set;}
    //to hold id of filter
    String filterId;
    
    //Variable to hold Screen type
    String type;
    //constructor
    public MassProjectAssignmentController(){
        sortField ='Name';
        //Initialize wrapper list.
        projectAssignment = new projectAssignWrapper();
        mapOfRoles = new Map<Id, Krow__Krow_Role__c>();
        arrowDirection = 'arrowdown';
        filterRecord = new Filter__c();
        resourceScreen =false;
        filterRecordResource = new Filter__c();
        //set page no.
        pageNumber = 0;
        pageNumberProject = 0;
        totalNoOfPageProject = 0;
        totalNoOfPageResource =0;
        isAlertShown = false;
        //call method to get krow projects.
        getkrowProjects();
    }
    
    /**
*  @description    :   This method is used to set selected resource id. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void setSelectedResource(){
        //create instance.
        selectedResource = new ResourceWrapper();
        
        //loop over resource wrapper.
        for(ResourceWrapper res : resources){
            //check selected.
            if(res.recordId  == selectedResourceId){ 
                selectedResource = res;
                res.isSelect = true;
            }
            else{
                res.isSelect = false;
            }
        }
    }
    
    /**
*  @description    :   This method is used to fetch all project details. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public List<SelectOption> getRoles(){
        //Initialize list
        List<SelectOption> roles = new List<SelectOption>();
        
        //query projectRole.
        for(Krow__Krow_Role__c projectRoles : [Select Id, Name From Krow__Krow_Role__c Where Krow__Active__c = true]){
            //add role in list.
            roles.add(new SelectOption(projectRoles.Id, projectRoles.Name));
            mapOfRoles.put(projectRoles.Id, projectRoles);
        }
        
        return roles;
    }
    /**
*  @description    :   This method is used to fetch filters details. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public List<SelectOption> getItems() {
        system.debug('resourceScreen--'+resourceScreen);
        defaultValue ='';
        system.debug('UserInfo.getUserId()'+UserInfo.getUserId()) ;
        
        type = resourceScreen ? 'Resource' :'Project';
        system.debug('type--'+type);
        options = new List<SelectOption>();
        mapFilter =new Map<Id, Filter__c>([Select Id, Name,Project_Name__c,Status__c, Default__c,Type_of_Filter__c, Priority__c, risk__c,Region__c,Buyer_Account__c from Filter__c where User__c =: UserInfo.getUserId() and Type_of_Filter__c =:type]);
        system.debug('mapFilter--'+mapFilter);
        for(Filter__c filter :mapFilter.values()){
            if(filter.Default__c == true )
                defaultValue = filter.Id;
            
            options.add(new SelectOption(filter.Id, filter.Name));
        }   
        options.add(new SelectOption('--none--','--none--'));
        
        if(string.isNotBlank(filterId) )
            defaultValue =filterId;
        
        if(String.isBlank(defaultValue))
            defaultValue = '--none--';
        system.debug('defaultValue'+defaultValue); 
        onfilterSelection();
        filterSize = options.size();
        system.debug('options--'+options);
        return options;
    }
    /**
*  @description    :   This method is used to fetch filters details. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void onfilterSelection(){
        filterRecord = new Filter__c();
        filterRecordResource = new Filter__c();
        filterId = Apexpages.currentPage().getParameters().get('filterID') != null ? Apexpages.currentPage().getParameters().get('filterID') : defaultValue;
        defaultValue = filterId;
        if(String.isnotBlank(filterId) && filterId != '--none--'&& mapFilter.get(filterId) != null){
            if(resourceScreen == false){
                filterRecord.Id = filterId;
                filterRecord.Name = mapFilter.get(filterId).Name;
                filterRecord.Project_Name__c = mapFilter.get(filterId).Project_Name__c;
                filterRecord.Status__c =mapFilter.get(filterId).Status__c;
                filterRecord.Buyer_Account__c= mapFilter.get(filterId).Buyer_Account__c;
                filterRecord.Priority__c =mapFilter.get(filterId).Priority__c;
                filterRecord.Risk__c = mapFilter.get(filterId).Risk__c;
                filterRecord.Region__c =mapFilter.get(filterId).Region__c;
                filterRecord.Default__c = mapFilter.get(filterId).Default__c;
                filterRecord.Type_of_Filter__c = type;
                onSearchProject();
                system.debug(filterRecord);
            }
            
            else{
                filterRecordResource.Id = filterId;
                filterRecordResource.Name = mapFilter.get(filterId).Name;
                filterRecordResource.Project_Name__c = mapFilter.get(filterId).Project_Name__c;
                filterRecordResource.Status__c =mapFilter.get(filterId).Status__c;
                filterRecordResource.Buyer_Account__c= mapFilter.get(filterId).Buyer_Account__c;
                filterRecordResource.Priority__c =mapFilter.get(filterId).Priority__c;
                filterRecordResource.Risk__c = mapFilter.get(filterId).Risk__c;
                filterRecordResource.Region__c =mapFilter.get(filterId).Region__c;
                filterRecordResource.Default__c = mapFilter.get(filterId).Default__c;
                filterRecordResource.Type_of_Filter__c = type;
                onSearch();
            }
        }
        else{
            if(resourceScreen == false)
                getKrowProjects();
            
            else
            {
                getAllResourcePlanner();                  
            }
            
        }
        
        
    }
    /**
*  @description    :   This method is used to fetch all project details. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void getKrowProjects(){
        resourceScreen =false;
        //set wrapper type.
        wrapperType = 'Project';
        sortField =  Apexpages.currentPage().getParameters().get('sortField') != null ?  Apexpages.currentPage().getParameters().get('sortField') :'Name';
        arrowDirection = arrowDirection == 'arrowdown' ? 'arrowup':'arrowdown';
        //SOT-159 Date:4/10/2019
        String query = 'Select Id, Name, Krow__Project_Status__c,Krow__Account__r.Name,Country__c,Priority__c,Risk__c, Krow__Project_Start_Date__c, Krow__Project_End_Date__c From Krow__Project__c Where Krow__Project_Status__c = \'Queued for SIPM\' OR Krow__Project_Status__c =  \'Queued for Engineering\' OR Krow__Project_Status__c =  \'Queued for Triage\' OR Krow__Project_Status__c =  \'Queued for Assignment \' Order by '+sortField +' ';
        system.debug('sortField--'+sortField);
        query +=  arrowDirection == 'arrowdown' ? 'desc' :'ASC ' ;
        // system.assert(false,'query--'+query );
        system.debug('query--'+query);
        //Query project which status is in queue.
        List<Krow__Project__c> krowProjects =  database.query(query);
        
        
        //List to hold projectWrapper.
        projectsWrapper = new List<ProjectWrapper>();
        
        //Loop over projects and fill wrapper
        for( Krow__Project__c project : krowProjects ){  
            
            //create instance of project wrapper.
            ProjectWrapper pw = new ProjectWrapper();
            pw.projectId = project.Id;
            pw.projectName = project.Name;
            pw.buyerAccount = project.Krow__Account__r.Name;
            pw.priority = project.Priority__c;
            pw.risk = project.Risk__c;
            pw.country = project.country__c;
            pw.startDate = project.Krow__Project_Start_Date__c != null ? project.Krow__Project_Start_Date__c.format() : '';
            pw.endDate = project.Krow__Project_End_Date__c != null ?project.Krow__Project_End_Date__c.format() : '';
            pw.status = project.Krow__Project_Status__c;
            
            //add project wrpper in list.
            projectsWrapper.add(pw); 
        }
        if(filterId != '--none--'){
            getItems();
            //onSearchProject();
        }
        else
            fillKrowProjects(projectsWrapper);
        
    }
    
    /**
*  @description    :   This method is used to search project.
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void onSearchProject(){
        //set pageNumber to 0.
        pageNumberProject = 0;
        
        //List to hold filter project.  
        List<ProjectWrapper> filterKrowProjects = new List<ProjectWrapper>();
        
        //Loop over proejcts
        for( ProjectWrapper projectWrp : projectsWrapper ) {
            Boolean isSearchMatch;
            if( String.isNotBlank(filterRecord.Project_Name__c) || String.isNotBlank(filterRecord.Status__c) || String.isNotBlank(filterRecord.Priority__c)|| String.isNotBlank(filterRecord.Risk__c) || String.isNotBlank(filterRecord.Buyer_Account__c) || String.isNotBlank(filterRecord.Region__c)) {
                
                if( ( String.isNotBlank(filterRecord.Project_Name__c) ? projectWrp.projectName.containsIgnoreCase(filterRecord.Project_Name__c) : true) &&  (String.isNotBlank(filterRecord.Status__c) ? projectWrp.status != null &&  projectWrp.status.containsIgnoreCase(filterRecord.Status__c) : true) && (String.isNotBlank(filterRecord.Priority__c) ? projectWrp.priority != null &&  projectWrp.priority.containsIgnoreCase(filterRecord.Priority__c) : true) &&
                   (String.isNotBlank(filterRecord.Risk__c) ? projectWrp.risk != null &&  projectWrp.risk.containsIgnoreCase(filterRecord.Risk__c) : true) && (String.IsNotBlank(filterRecord.Region__c)  ? projectWrp.country != null && projectWrp.country.containsIgnoreCase(filterRecord.Region__c) : true) && (String.isNotBlank(filterRecord.Buyer_Account__c) ? projectWrp.buyerAccount != null &&  projectWrp.buyerAccount.containsIgnoreCase(filterRecord.Buyer_Account__c) : true)){
                       isSearchMatch = true;
                   } else {
                       isSearchMatch = false;
                   }
            } else {  
                isSearchMatch = true;  
            }
            
            //if found search item than add in list.
            if(isSearchMatch ) {
                filterKrowProjects.add(projectWrp);
            }
        }
        
        //call method to fill listOfListKrowProject.
        fillKrowProjects(filterKrowProjects);
        totalNoOfPageProject = listOfListKrowProjects.size() - 1;
    }
    
    
    /**
*  @description    :   This method is used to fill listOfListkrowProject list. 
*
*  @args           :   List<Krow__Proejct__c>
*
*  @return         :   
* 
**/
    public void fillKrowProjects(List<ProjectWrapper> projects){
        system.debug('Hello');
        //Initialize list.
        listOfListKrowProjects = new List<List<ProjectWrapper>>();
        
        //Add list.
        listOfListKrowProjects.add(new List<ProjectWrapper>());
        
        //Counter for no of data in each list.
        Integer counter = 0;
        
        //Loop over map data
        for(ProjectWrapper pro : projects){
            
            //Check counter and add blank list and set counter to .
            if(counter == PAGE_SIZE){
                counter = 0;
                listOfListKrowProjects.add(new List<ProjectWrapper>());
            }
            
            //Add data in list.
            listOfListKrowProjects[listOfListKrowProjects.size() - 1].add(pro);
            counter++;
        }
    }
    
    public void moveToProjectPage(){
        wrapperType= 'Project';
        selectedResource = null;
        resourceScreen = false;
        filterId ='';
        getItems();
    }
    
    /**
*  @description    :   This method is used to fetch all project resource details. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void getAllResourcePlanner(){
        
        //List to hold selected project id.
        selectedProjectId = new List<Id>();
        
        //loop over prject wrapper.
        for(ProjectWrapper proWrapper : projectsWrapper){
            
            //check project select.
            if(proWrapper.isSelect)
                selectedProjectId.add(proWrapper.projectId);
        }
        
        //check size of list.
        if(selectedProjectId.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select atleast one project.'));
            return;
        }
        
        
        //set wrapperType
        wrapperType = 'resource';
        
        //initialize resourcewrapperlist
        resources = new List<ResourceWrapper>();
        sortField =  Apexpages.currentPage().getParameters().get('sortResourceField') != null ?  Apexpages.currentPage().getParameters().get('sortResourceField') :'Name';
        
        String query  = 'Select Id,Krow__Region__r.Name, (Select Id, Krow__Krow_Project__c, Krow__Krow_Project__r.Name, Krow__Krow_Project__r.Krow__Project_Status__c, krow__krow_Project__r.Krow_Project_Template__c, krow__krow_Project__r.Krow_Project_Template__r.Name From krow__Project_Assignments__r ORDER BY Krow__Krow_Project__r.Krow__Project_Status__c ASC Limit 600), Name, Krow__Project_Role__c, Krow__Project_Role__r.Name From Krow__Project_Resources__c Where Krow__Active__c = true AND Krow__Project_Role__c != Null Order BY '+sortField+' ';
        query +=  arrowDirection == 'arrowdown' ? 'desc' :'ASC ' ;
        //List to hold project resource data
        List<Krow__Project_Resources__c> projectResources = database.query(query);
        
        //Null and size check of list.
        if(projectResources != null && projectResources.size() > 0){ 
            
            //Loop over projectResource data.
            for(Krow__Project_Resources__c resource : projectResources){
                //Added 13/05/19
                Map<Id, workflowTemplate> mapOfWorkflowTamplateByTemplateId = new Map<Id, workflowTemplate>();
                
                //create instance of wrapper.
                ResourceWrapper wrp = new ResourceWrapper();
                wrp.recordId = resource.Id;
                wrp.Name = resource.Name;
                wrp.role = resource.Krow__Project_Role__r.Name;
                wrp.roleId = resource.Krow__Project_Role__c;
                wrp.region =resource.Krow__Region__r.Name;
                wrp.totalProject = resource .krow__Project_Assignments__r.size();
                wrp.projects = new List<ProjectWrapper>();
                wrp.workflowTemplateList = new List<workflowTemplate>();// Added 13/05/19
                //loop over project assignment 
                for(Krow__Project_Assignment__c projectAssignment : resource.krow__Project_Assignments__r){
                    
                    //create instance of project wrpper.
                    ProjectWrapper pwrp = new ProjectWrapper();
                    pwrp.projectId = projectAssignment.Krow__Krow_Project__c;
                    pwrp.projectName = projectAssignment.Krow__Krow_Project__r.Name;
                    pwrp.status = projectAssignment.Krow__Krow_Project__r.Krow__Project_Status__c;
                    pwrp.templateName = String.isBlank(projectAssignment.krow__krow_Project__c) ? 'None' :projectAssignment.krow__krow_Project__r.Krow_Project_Template__r.Name;
                    
                    //add projects.
                    wrp.projects.add(pwrp);
                    
                    //Added 13/05/19
                    if(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c != null && !mapOfWorkflowTamplateByTemplateId.containsKey(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c))
                        mapOfWorkflowTamplateByTemplateId.put(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c, new WorkflowTemplate(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c, projectAssignment.krow__krow_Project__r.Krow_Project_Template__r.Name, 1));
                    
                    else if(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c != null && mapOfWorkflowTamplateByTemplateId.containsKey(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c))
                        mapOfWorkflowTamplateByTemplateId.get(projectAssignment.krow__krow_Project__r.Krow_Project_Template__c).noOfProject++;
                }
                
                //Added 13/05/19
                //size check.
                if(mapOfWorkflowTamplateByTemplateId.size() > 0){
                    //loop over map.
                    for(workflowTemplate template : mapOfWorkflowTamplateByTemplateId.values()){
                        wrp.workflowTemplateList.add(template);
                    }
                }
                
                //Add data in list.
                resources.add(wrp);
            }
            resourceScreen =true;
            
            //call method to fill resource wrapper list.
            if(filterId != '--none--'){
                filterId ='';
                getItems();
            }
            else{
                filteredResourceWrapper = new List<ResourceWrapper>();
                filteredResourceWrapper.addAll(resources);
                fillResourceWrapper();
            }
            
        }          
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There is no active project record found.'));
        }
    }
    
    /**
*  @description    :   This method is used to filter project resources.
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void onSearch(){
        //set pageNumber to 0.
        pageNumber = 0;
        //Initialize list.
        filteredResourceWrapper = new List<ResourceWrapper>();
        
        //Loop over resource wrapper
        for( ResourceWrapper resourceWrp : resources ) {
            Boolean isSearchMatch;
            if( String.isNotBlank(filterRecordResource.Project_Name__c) || String.isNotBlank(filterRecordResource.Status__c) || String.isNotBlank(filterRecordResource.Region__c) ) {
                if((String.isNotBlank(filterRecordResource.Project_Name__c) ? resourceWrp.Name.containsIgnoreCase(filterRecordResource.Project_Name__c ) : true) &&  ( String.isNotBlank(filterRecordResource.Status__c) ? resourceWrp.role.containsIgnoreCase(filterRecordResource.Status__c) : true)
                   && (String.isNotBlank(filterRecordResource.Region__c) ? resourceWrp.region !=null && resourceWrp.region.containsIgnoreCase(filterRecordResource.Region__c): true) ){
                       isSearchMatch = true;
                   } else {
                       isSearchMatch = false;
                   }
            } else {
                isSearchMatch = true;
            }
            
            //if found search item than add in list.
            if(isSearchMatch ) {
                filteredResourceWrapper.add(resourceWrp);
            }
        }
        
        //call method to fill listOfListResourceWrapper
        fillResourceWrapper();
        totalNoOfPageResource = listOfListResourceWrapper.size() -1;
    }
    
    /**
*  @description    :   This method is used to fill listOfListResourceWrapper list. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void fillResourceWrapper(){
        
        //Initialize list.
        listOfListResourceWrapper = new List<List<ResourceWrapper>>();
        
        //Add list.
        listOfListResourceWrapper.add(new List<ResourceWrapper>());
        
        //Counter for no of data in each list.
        Integer counter = 0;
        
        //Loop over map data
        for(ResourceWrapper wrp : filteredResourceWrapper){
            
            //Check counter and add blank list and set counter to .
            if(counter == PAGE_SIZE){
                counter = 0;
                listOfListResourceWrapper.add(new List<ResourceWrapper>());
            }
            
            //Add data in list.
            listOfListResourceWrapper[listOfListResourceWrapper.size() - 1].add(wrp);
            counter++;
        }
    }
    
    
    /**
*  @description    :   This getter setter used for bind wrapper data on page. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public List<ProjectWrapper> tempListOfProject{
        get{
            //Null check of page number.
            if(pageNumberProject == null)
                pageNumberProject = 0;
            
            //Null check for list of list.
            if(listOfListKrowProjects == null){
                listOfListKrowProjects = new List<List<ProjectWrapper>>();
                listOfListKrowProjects.add(new List<ProjectWrapper>());
            }
            return listOfListKrowProjects[pageNumberProject]; 
        }
        set;
    }
    
    /**
*  @description    :   This getter setter used for bind project data on page. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public List<ResourceWrapper> tempListOfResource{
        get{
            //Null check of page number.
            if(pageNumber == null)
                pageNumber = 0;
            
            //Null check for list of list.
            if(listOfListResourceWrapper == null){
                listOfListResourceWrapper = new List<List<ResourceWrapper>>();
                listOfListResourceWrapper.add(new List<ResourceWrapper>());
            }
            return listOfListResourceWrapper[pageNumber];
        }
        set;
    }
    
    /**
*  @description    :   This method is used for pagination. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void first(){
        if(wrapperType.equalsIgnoreCase('Project'))
            pageNumberProject = 0;
        else if(wrapperType.equalsIgnoreCase('resource')) 
            pageNumber = 0;
    }
    
    /**
*  @description    :   This method is used for pagination. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void previous(){
        if(wrapperType.equalsIgnoreCase('Project'))
            pageNumberProject -= 1;
        else if(wrapperType.equalsIgnoreCase('resource'))
            pageNumber -= 1;
    }
    
    /**
*  @description    :   This method is used for pagination.
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void next(){
        if(wrapperType.equalsIgnoreCase('Project'))
            pageNumberProject += 1;
        else if(wrapperType.equalsIgnoreCase('resource'))
            pageNumber += 1;
        
    }
    
    
    /**
*  @description    :   This method is used for pagination. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void last(){
        if(wrapperType.equalsIgnoreCase('Project'))
            pageNumberProject  = listOfListKrowProjects.size() - 1;
        else if(wrapperType.equalsIgnoreCase('resource'))
            pageNumber = listOfListResourceWrapper.size() - 1;
    }
    
    
    /**
*  @description    :   This method is used for disable first and pre button in pagination. 
*
*  @args           :   
*
*  @return         :   
* 
**/ 
    public Boolean getFirstButtonDisabled() {
        if(wrapperType.equalsIgnoreCase('Project'))
            return pageNumberProject == 0;
        else
            return pageNumber == 0;
        
        
    }
    
    /**
*  @description    :   This method is used for disable next and last button in pagination. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public Boolean getLastButtonDisabled() {
        if(wrapperType.equalsIgnoreCase('Project'))
            return pageNumberProject == listOfListKrowProjects.size() -1;
        else
            return pageNumber == listOfListResourceWrapper.size() -1;
    }
    
    /**
*  @description    :   This method is used to reset all list and getter setter. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void backToHome(){
        //clear page message.
        ApexPages.getMessages().clear();
        
        //Initialize wrapper list.
        projectAssignment = new projectAssignWrapper();
        
        //set wrapper type.
        wrapperType = 'Project';
        
        //set page no.  
        pageNumber = 0;
        pageNumberProject = 0;
        isAlertShown = false;
        filterId = '';
        resourceScreen =false;
        //call method to get krow projects.
        getkrowProjects();
    }
    
    /**
*  @description    :   This method is used to navigate assignement section. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void moveToProjectAssignment(){
        isAlertShown = false;
        if(selectedResource == null){
            isAlertShown = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select a Project resource.'));
            return;
        }
        projectAssignment.roleId = selectedResource.roleId;
        //clear page message.
        ApexPages.getMessages().clear();
        system.debug('isAlertShown--'+isAlertShown);
    }
    /**f
*  @description    :   This method is used to create project assignement record. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    
    public void assignProject(){
        
        try{
            
            isAlertShown = false;
            
            //List to insert project assignemnt record.
            List<Krow__Project_Assignment__c> projectAssignmentsToInsert = new List<Krow__Project_Assignment__c>();
            
            //check size of selected project.
            if(selectedProjectId.size() > 0){
                
                //loop over selected project id.
                for(Id projectId : selectedProjectId){
                    
                    //create instance of project assignment.
                    Krow__Project_Assignment__c tempProjectAssignment = new Krow__Project_Assignment__c();
                    tempProjectAssignment.Krow__Krow_Project__c = projectId;
                    tempProjectAssignment.Krow__Project_Resource__c = selectedResource.recordId;
                    tempProjectAssignment.Krow__Start_Date__c = projectAssignment.startDate;
                    tempProjectAssignment.Krow__End_Date__c = projectAssignment.endDate;
                    tempProjectAssignment.Krow__Role__c = projectAssignment.roleId;
                    tempProjectAssignment.Krow__IsOwner__c = projectAssignment.isOwner;
                    
                    //Add in list.
                    projectAssignmentsToInsert.add(tempProjectAssignment);
                }
                
                //check size of list.
                if(projectAssignmentsToInsert.size() > 0){
                    insert projectAssignmentsToInsert;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Projects are assigned to '+ '<a href="/'+selectedResource.recordId+'" target="_blank" style="margin:0px;" >'+selectedResource.name+'</a>'));
                }
            }
            
        }
        catch(Exception e){
            if(e.getMessage().contains('Duplicate resource with role found in project.'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, selectedResource.name+' is already assigned to the selected projects as role '+mapOfRoles.get(projectAssignment.roleId).Name+'. Either please manually change the Queued status of this project, or assign a different user to the role.'));
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            
            isAlertShown = true;
        }
    }
    
    /**
*  @description    :   This method is used to create project assignement record. 
*
*  @args           :   
*
*  @return         :   
* 
**/
    public void saveFilters(){
        try{
            Filter__c filters = new Filter__c();
            if(filterId != null && filterId instanceof Id)
                filters.Id = filterId;
            if(resourceScreen == false){
                if( String.isNotBlank(filterRecord.Project_Name__c) || String.isNotBlank(filterRecord.Status__c) || String.isNotBlank(filterRecord.Buyer_Account__c)
                   || String.isNotBlank(filterRecord.Priority__c) || String.isNotBlank(filterRecord.Risk__c) || String.isNotBlank(filterRecord.Region__c)) {
                       
                       filters.Name =filterRecord.Name;
                       filters.Project_Name__c = filterRecord.Project_Name__c;
                       filters.Risk__c = filterRecord.Risk__c;
                       filters.Priority__c = filterRecord.Priority__c;
                       filters.Status__c = filterRecord.Status__c;
                       filters.Buyer_Account__c =filterRecord.Buyer_Account__c;
                       filters.Region__c = filterRecord.Region__c;
                       filters.Default__c =filterRecord.Default__c;
                       filters.User__c = UserInfo.getUserId();
                       filters.Type_of_Filter__c = 'Project';
                       
                       
                   }
            }
            else{
                if(String.isNotBlank(filterRecordResource.Project_Name__c) || String.isNotBlank(filterRecordResource.Status__c) || String.isnotBlank(filterRecordResource.Region__c)) 
                    filters.Name =filterRecordResource.Name;
                filters.Project_Name__c = filterRecordResource.Project_Name__c;
                filters.Status__c = filterRecordResource.Status__c;
                filters.Region__c = filterRecordResource.Region__c;
                filters.Default__c =filterRecordResource.Default__c;
                filters.User__c = UserInfo.getUserId();
                filters.Type_of_Filter__c = 'Resource';
            }
            upsert filters ;
            filterId = filters.Id;
            getItems();  
        }
        catch(exception ex){
            system.debug(ex.getMessage());
        }
        
    }
    
    /**
*  @description    :   This Wrapper class is used to hold resource plan data. 
**/
    
    public class ResourceWrapper{
        public Id recordId {get; set;}
        public String name {get; set;}
        public String role {get; set;}
        public String region {get;set;}
        public Integer totalProject {get; set;}
        public List<ProjectWrapper> projects {get; set;}
        public Id roleId;
        public Boolean isSelect {get; set;}
        public List<workflowTemplate> workflowTemplateList {get; set;} //added 13/05/19
        
        public ResourceWrapper(){
            isSelect = false;
        }
    } 
    /*
*  @description    :   This method is used to create project assignement record. 
*
*  @args           :   String 
*
*  @return         :   null
* 
**/
    public void deleteSelectedFilter(){
        try{
            if(String.isNotBlank(defaultValue) && defaultValue instanceof Id){
                
                delete [SELECT Id from Filter__c WHERE Id =:defaultValue];
                filterId ='';
                getItems();  
            }
            
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }        
    }
    
    /**
*  @description    :   This Wrapper class is used to hold project data. 
**/
    
    public class ProjectWrapper{
        public Id projectId {get; set;}
        public String projectName {get; set;}
        public String priority {get; set;}
        public String risk {get; set;}
        public String buyerAccount {get; set;}
        public String country {get; set;}
        public String startDate {get; set;}
        public String endDate {get; set;}
        public String status {get; set;}
        public Boolean isSelect {get; set;}
        public String templateName {get; set;}//Added 13/05/19
        
        public ProjectWrapper(){
            isSelect = false;
        }
    }
    
    /**
*  @description    :   This Wrapper class is used to hold project assign data. 
**/ 
    
    public class ProjectAssignWrapper{
        public Id roleId {get; set;}
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public Boolean isOwner {get; set;}
        
        public projectAssignWrapper(){
            roleId = null;
            startDate = null;
            endDate = null;
            isOwner = false;
        }
    }
    
    //Added 13/05/19
    public class WorkflowTemplate{
        public Id templateId {get; set;}
        public String templateName {get; set;}
        public Integer noOfProject {get; set;}
        
        public workflowTemplate(Id templateId, String templateName, Integer noOfProject){
            this.templateId = templateId;
            this.templateName = templateName;
            this.noOfProject = noOfProject;
        }
    }
}