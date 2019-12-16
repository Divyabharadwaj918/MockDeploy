/**
* Description     -     This class is helper class for trigger on Krow Project Assignemnt object.
* 
* Created by      -   
* 
* Created Date    -     2/21/2019
*
* Revision log    -     Created
*                   
*/
public class KrowProjectAssignmentTriggerHelper {
    
    /**
*  @description    :    This method is used to Change the "Project Status" from Queued to In Progress,
*                       If Krow Project assignemnt has role = SIPM or role = Solution Integration Engineer, 
*
*  @args           :    List , Map
*
*  @return         :    void
* 
**/
    public static void changeProjectStatus(List<Krow__Project_Assignment__c> krowProjectAssignments, Map<Id, Krow__Project_Assignment__c> oldMapOfKrowProjectAssignment){
        
        //Set to hold Krow Project Id
        set<Id> setOfKrowProjectIds = new set<Id>();
        set<Id> setOfKrowRoles = new set<Id>();
        
        //Loop over Krow Project Assignemts
        for(Krow__Project_Assignment__c projectAssignment : krowProjectAssignments){
            
            //Check for Insert and update
            if((oldMapOfKrowProjectAssignment == null  || (oldMapOfKrowProjectAssignment != null && (projectAssignment.Krow__Role__c != oldMapOfKrowProjectAssignment.get(projectAssignment.Id).Krow__Role__c) || 
                                                           (projectAssignment.Krow__Krow_Project__c != oldMapOfKrowProjectAssignment.get(projectAssignment.Id).Krow__Krow_Project__c)))
               && projectAssignment.Krow__Krow_Project__c != null && projectAssignment.Krow__Role__c != null) {
                   
                   //Add the id of Krow Project 
                   setOfKrowProjectIds.add(projectAssignment.Krow__Krow_Project__c);
                   setOfKrowRoles.add(projectAssignment.Krow__Role__c);
               }
        }
        
        //Check for Size
        if(setOfKrowProjectIds.size() >0 && setOfKrowRoles.size()>0) {
            
            //Query the Krow Role
            Map<Id,Krow__Krow_Role__c> mapOfKrowRoles = new Map<Id, Krow__Krow_Role__c>([Select Id , Name From Krow__Krow_Role__c where Id IN:setOfKrowRoles AND 
                                                                                         (Name like '%SIPM%' OR Name like '%SIE%')]);
            //Query the Krow Project
            Map<Id,Krow__Project__c > mapOfKrowProjects = new Map<Id,Krow__Project__c>([Select Id, Krow__Project_Status__c From Krow__Project__c where Id IN: setOfKrowProjectIds AND Krow__Project_Status__c != null AND ((Krow__Project_Status__c ='Queued for Triage') OR (Krow__Project_Status__c = 'Queued for Engineering') OR (Krow__Project_Status__c = 'Queued for SIPM') OR (Krow__Project_Status__c = 'Queued for Assignment'))]);
            
            //Check for Map size
            if(mapOfKrowProjects.size()>0 && mapOfKrowRoles.size() >0) {
                //loop over 
                for(Krow__Project_Assignment__c projectAssignment : krowProjectAssignments) {
                    
                    //Check for Map size
                    //SOT-159 Date:4/10/2019
                    if(mapOfKrowProjects.containsKey(projectAssignment.Krow__Krow_Project__c) && mapOfKrowRoles.containsKey(projectAssignment.Krow__Role__c)){
                        //mapOfKrowProjects.get(projectAssignment.Krow__Krow_Project__c).Krow__Project_Status__c = 'In Progress';
                        mapOfKrowProjects.get(projectAssignment.Krow__Krow_Project__c).Krow__Project_Status__c = 'Lead';
                    }
                }
                update mapOfKrowProjects.values();
            }
        }
    }
    /**
*  @description    :    This method is used to Change the Project Owner to User
*
*  @args           :    List
*
*  @return         :    void
* 
**/
    public static void changeProjectOwnerToUser(List<Krow__Project_Assignment__c> krowProjectAssignments, Map<Id, Krow__Project_Assignment__c> oldMapOfKrowProjectAssignment) {
        
        //Set to hold user Id
        set<Id> userIds = new set<Id>();
        List<Krow__Project__c> projectToBeupdate = new List<Krow__Project__c>();
        
        //Loop over Krow Project Assignemnt
        for(Krow__Project_Assignment__c projectAssignment : krowProjectAssignments) {
            system.debug('old map = '+oldMapOfKrowProjectAssignment);
            system.debug('projectAssignment.Krow__User__c  = '+projectAssignment.Krow__User__c );
            system.debug('projectAssignment.Krow__IsOwner__c  = '+projectAssignment.Krow__IsOwner__c );
            system.debug('projectAssignment.Krow__Krow_Project__c  = '+projectAssignment.Krow__Krow_Project__c);
            
            //Check for Insert and Update case
            if((oldMapOfKrowProjectAssignment == null || ( oldMapOfKrowProjectAssignment != null && projectAssignment.Krow__Krow_Project__c != 	oldMapOfKrowProjectAssignment.get(projectAssignment.Id).Krow__Krow_Project__c
                                                          || 	projectAssignment.Krow__User__c != oldMapOfKrowProjectAssignment.get(projectAssignment.Id).Krow__User__c)
               ) && projectAssignment.Krow__User__c != null && projectAssignment.Krow__IsOwner__c == true && projectAssignment.Krow__Krow_Project__c != null ) {
                   projectToBeupdate.add(new Krow__project__c(Id = projectAssignment.Krow__Krow_Project__c, OwnerId = projectAssignment.Krow__User__c ));
                   
               }
        }
        
        //Check for Size
        if(projectToBeupdate.size() >0)
            update projectToBeupdate;
    }
    /**
*  @description    :    This method is used to Update TIE and SIPM user on Project
*
*  @args           :    List
*
*  @return         :    void
* 
**/
    public static void  updateTIEandSIPM(List<Krow__Project_Assignment__c> krowProjectAssignments, Map<Id, Krow__Project_Assignment__c> oldMapOfKrowProjectAssignment) {
        try{
        //To hold Id of Krow Project
        Set<Id> krowProjectId = new Set<Id>();
        
        //Map to hold Related roles
        Map<Id, Krow__Krow_Role__c> krowRole = new  Map<Id, Krow__Krow_Role__c>([Select Id , Name from 	Krow__Krow_Role__c where Name ='TIE (Technical Integration Engineer)' OR  Name ='SIPM (Seller Integration Project Manager)' ]) ;
        
        //Query on Record type
        map<Id, RecordType> mapOfrecordTypes = new Map<Id,RecordType>();
        
        for(Krow__Project_Assignment__c assignments : krowProjectAssignments){
            krowProjectId.add(assignments.Krow__Krow_Project__c);
        }
        
        //Loop over Record type
        for(RecordType rType : [Select Id, DeveloperName From RecordType where sobjecttype = 'Krow__Project__c' AND  DeveloperName = 'Buyer_Seller_Project']) {
            
            //Add Values to Map
            mapOfrecordTypes.put(rType.Id,rType);
        }
        
        //to hold the parent krow project deatils
        Map<Id,Krow__Project__c> krowProject = new Map<Id,Krow__Project__c>([Select Id, Name, RecordTypeId from Krow__Project__c where Id In:krowProjectId ]);
        
        for(Krow__Project_Assignment__c assignments : krowProjectAssignments){
            
            if((oldMapOfKrowProjectAssignment == null || ( oldMapOfKrowProjectAssignment != null && assignments.Krow__Krow_Project__c != 	oldMapOfKrowProjectAssignment.get(assignments.Id).Krow__Krow_Project__c
                                                          || 	assignments.Krow__User__c != oldMapOfKrowProjectAssignment.get(assignments.Id).Krow__User__c)
               ) && assignments.Krow__User__c != null && assignments.Krow__Role__c!= null && assignments.Krow__Krow_Project__c != null ) {
                   
                   if( krowRole != null && krowRole.containsKey(assignments.Krow__Role__c) && krowRole.get(assignments.Krow__Role__c).Name == 'TIE (Technical Integration Engineer)' )
                       krowProject.get(assignments.Krow__Krow_Project__c).TIE__c = assignments.Krow__User__c;
                   
                   if(mapOfrecordTypes.containsKey(krowProject.get(assignments.Krow__Krow_Project__c).RecordTypeId) &&  krowRole != null && krowRole.containsKey(assignments.Krow__Role__c) && krowRole.get(assignments.Krow__Role__c).Name == 'SIPM (Seller Integration Project Manager)' )
                       krowProject.get(assignments.Krow__Krow_Project__c).SIPM__c =  assignments.Krow__User__c;
               }
            
        }
        
        if(krowProject.size()>0)
            update krowProject.values();
        }
        catch(exception ex){
            system.debug(ex.getMessage()+'--'+ex.getLineNumber());
        }
    }
    
            /**
    *  @description    :    This method is used to send email notification to resource
    *
    *  @args           :    Map
    *
    *  @return         :    void
    * 
    **/
    
    /*public static void sendNotificationToProjectResource(Map<Id,Krow__Project_Assignment__c> newProjectAssignments){
        
        //Query on project assignemtn to get useremail and project record type.
        List<Krow__Project_Assignment__c> projectAssignment = [Select Id, Name, krow__krow_Project__c, krow__krow_Project__r.Name, krow__Krow_Project__r.RecordTypeId, 
                                                            Krow__Project_Resource__r.Krow__User__r.Name, Krow__Project_Resource__r.Krow__User__r.Email 
                                                            From Krow__Project_Assignment__c Where Id IN :newProjectAssignments.keySet()];
        
        //Query record type of krow project.
        Id RecordTypeId = [select Id, developerName From RecordType Where SobjectType = 'Krow__Project__c' and developerNAME = 'Buyer_Seller_Project' ].Id;
        
        //List of singleEmailMessage to send email.
        List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
        
        for(Krow__Project_Assignment__c pa : projectAssignment){
            //check for recordtypeId of buyer-seller 
            if(pa.krow__Krow_Project__r.RecordTypeId == RecordTypeId && pa.Krow__Project_Resource__r.Krow__User__c != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new String[] {pa.Krow__Project_Resource__r.Krow__User__r.Email}; 
                    
                    mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Tradeshift Support');
                
                mail.setSubject('Project Assigned');
                
                String htmlBody = 'Hi '+pa.Krow__Project_Resource__r.Krow__User__r.Name+'<br/>';
                htmlBody += 'You\'ve been assigned to project <a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'+ pa.krow__krow_Project__c+'>'+pa.krow__krow_Project__r.Name+'</a>. Please login to review this project.';
                
                mail.setHtmlBody(htmlBody);
                
                listOfMail.add(mail);
            }
        }
        
        //check size of list.
        if(listOfMail.size() > 0)
            Messaging.sendEmail(listOfMail);
    }*/
}