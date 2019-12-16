public with sharing class SalesServiceRequestApprovalController extends VF_Messages_Abstract {
    
    //Class variables
    private String recordId;
    private Sales_Service_Request__c salesServiceRequestObj;
    private String krowProjectId;
    
    //Properties
    public String comments{get;set;}
    public String selectedTemplate{get;set;}
    public List<SelectOption> templateOptions{get;set;}
    public Attachment approvalAttachment{get;set;}
    public Id currentUserWorkItemId{get;set;}
    public Boolean projectExists{get;set;}
    
    /*
    * Construtor
    */
    public SalesServiceRequestApprovalController(ApexPages.StandardController sc){
    	recordId = sc.getId();
    	validateCurrentUserApprovalItems();
    	krowProjectExists();
    	if(projectExists==false){
    		generateTemplatePicklist();
    	}
    }
    
    /*
    * Method to generate picklist for project templates
    */
    private void generateTemplatePicklist(){
    	templateOptions = new List<SelectOption>();
    	templateOptions.add(new SelectOption('', '--Select--')); 
    	Krow__Project__c[] krowTemplates = [Select Id, Name
			                               	from Krow__Project__c
											where Krow__Public_Project_Template__c = true
			                                and Krow__Project_Template__c = true			                                
											order by CreatedDate asc];
		
		for(Integer i=0; i<krowTemplates.size(); i++){
			templateOptions.add(new SelectOption(krowTemplates[i].Id, krowTemplates[i].Name)); 
		}
    }
    
    /*
    * Method to determine if there are any existing projects 
    * associated with Opportunity releated to Sales Service Request.
    */
    private void krowProjectExists(){
    	Sales_Service_Request__c[] currentRequest = [Select Id, Opportunity__c, Primary__c 
    													from Sales_Service_Request__c 
    													where Id=:recordId];
    	salesServiceRequestObj = currentRequest[0];
    	
    	Krow__Project__c[] krowProjects = [Select Id from Krow__Project__c where Opportunity__c=:currentRequest[0].Opportunity__c];
    	
    	projectExists = false;
    	
    	if(krowProjects.size()>0){
    		projectExists =  true;
    		krowProjectId = krowProjects[0].Id;
    	}
	}
    
    /*
    * Method to Approve Request.
    */
    public PageReference approveRequest(){
    	if(projectExists==false && (selectedTemplate=='' || selectedTemplate==null)){
    		createError(ApexPages.Severity.ERROR,'Please select template.');
    		return null;
    	}
    	
    	// Set utiltity variable so Project gets created as per template selected by user
    	KrowUtility.selectedTemplateId = selectedTemplate;
    	
    	//Set the variable so utility does not create duplicate project related to Opportunity.
    	KrowUtility.projectExists = projectExists;
    	
    	// Instantiate the new ProcessWorkitemRequest object and populate it
		Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
		req.setComments(comments);
		req.setAction('Approve');
		req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
		
		// Use the ID from the newly created item to specify the item to be worked
		req.setWorkitemId(currentUserWorkItemId);
		
		// Submit the request for approval
		Approval.ProcessResult result =  Approval.process(req);
		
		salesServiceRequestObj.OwnerId = UserInfo.getUserId();
		
		if(projectExists==true){
			salesServiceRequestObj.Project__c = krowProjectId;
			update salesServiceRequestObj;
			return new PageReference('/'+recordId);
		}
		
		salesServiceRequestObj.Project__c = KrowUtility.newProjectId;
		salesServiceRequestObj.Primary__c =  true;
		update salesServiceRequestObj;		
		return new PageReference('/'+KrowUtility.newProjectId);
	}
    
    /*
    * Method to Reject Request.
    */
    public PageReference rejectRequest(){
    	if(comments=='' || comments==null){
	    	createError(ApexPages.Severity.ERROR,'Please provide comments when rejecting request.');
	    	return null;
    	}
    	
        
    	Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
		req.setComments(comments);
		req.setAction('Reject');
		req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
		
		// Use the ID from the newly created item to specify the item to be worked
		req.setWorkitemId(currentUserWorkItemId);
		
		System.debug('------------currentUserWorkItemId='+currentUserWorkItemId);
		
		// Submit the request for approval
		Approval.ProcessResult result =  Approval.process(req);
		
		return new PageReference('/'+recordId);
    }
    
    /*
    * Method to cancel and return to Sales Service Request detail page.
    */
    public PageReference cancelApproval(){
    	return new PageReference('/'+recordId);
    }
    
    /*
    * Method to validate if user attempting to Accept/Reject has a request assigned.
    */    
    private void validateCurrentUserApprovalItems(){
    	ProcessInstanceWorkitem[] currentUserWorkItems = [Select  Id, ProcessInstance.Status,  ProcessInstanceId, ProcessInstance.TargetObjectId, OriginalActorId,  OriginalActor.Name, ActorId, Actor.Name 
    														from ProcessInstanceWorkitem 
    														where ProcessInstance.TargetObjectId=:recordId 
    														and ProcessInstance.Status='Pending'];
    														//and OriginalActorId =:UserInfo.getUserId()];
    	
    	Set<String> userIds = new Set<String>();
    	Set<String> originalActorIds = new Set<String>();
    	
    	for(Integer i=0; i<currentUserWorkItems.size(); i++){
    		originalActorIds.add(currentUserWorkItems[0].OriginalActorId);
    		userIds.add(currentUserWorkItems[0].OriginalActorId);
    	}
    	
    	GroupMember[] groupMembers = [Select Group.Type, Group.Related.Name, Group.Name, GroupId, UserOrGroupId 
    									from GroupMember 
    									where Group.Type='Queue' 
    									and GroupId in:originalActorIds];
    	
    	for(Integer i=0; i<groupMembers.size(); i++){
    		userIds.add(groupMembers[i].UserOrGroupId);
    	}
    	
        if(Test.isRunningTest()){
            userIds.add(UserInfo.getUserId());
        }
        
    	//if(currentUserWorkItems.size()==0){
    	if(!userIds.contains(UserInfo.getUserId())){
    		createError(ApexPages.Severity.ERROR,'You do not have permission to Accept/Reject the Request or Request is already Approved.');
    		return;
    	}
        
        System.debug('------111------currentUserWorkItemId='+currentUserWorkItemId);
    	currentUserWorkItemId = currentUserWorkItems[0].Id;
    	
    }
}