/**
* @author Pratibh Prakash
* @date 26-July-2018
* @description 
*/
public class PrimaryOpportunityContactRoleController {
	
    //class variable
    private String oppId;
    
    
    //Constructor
    public PrimaryOpportunityContactRoleController(ApexPages.StandardController sc){
        oppId = sc.getId();
    }
    
    /*
    ** Method to determine and set Primary Contact Role as Primary Contact on Opportunity
    */
    public void populatePrimaryContact(){
        OpportunityContactRole[] primaryContactRole = [Select OpportunityId, Opportunity.Primary_Contact__c, ContactId 
                                                       	from OpportunityContactRole
                                                      	where OpportunityId=:oppId
                                                      	and IsPrimary=true];
        
        if(primaryContactRole.size()>0 && primaryContactRole[0].Opportunity.Primary_Contact__c!=primaryContactRole[0].ContactId){
            Opportunity tempOpp = new Opportunity(Id=primaryContactRole[0].OpportunityId, Primary_Contact__c=primaryContactRole[0].ContactId);
            update tempOpp;
        }
    }
}