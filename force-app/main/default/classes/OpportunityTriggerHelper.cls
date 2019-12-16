/** 
*    Description     :      This class is used as a helper of the Opportunity trigger
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      21/02/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                    :      V1.1 Updated By Akshay Bagrecha 07/18/2019
*                      
**/
public class OpportunityTriggerHelper {
    
    static final String OPPORTUNITY_OBJECT = 'Opportunity';
    public static Boolean byOppTrigger = true ; 
    /*
    * Description   :  This method is used auto populate the tigger value
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   21/02/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateTrigger(List<Opportunity> newOppList){

        //Set to hold the amended contract value
        Set<Id> amendedContractIDs = new Set<Id>();

        //Loop over the new list of Opportunity
        for(Opportunity opp : newOppList){
            
            //Null Check for the amended contract value
            if(opp.SBQQ__AmendedContract__c != null)
                
                //Adding into set
                amendedContractIDs.add(opp.SBQQ__AmendedContract__c);
        }
        //Size check for the set "amendedContractIDs"
        if(amendedContractIDs.size() > 0) {
            
            //Map to hold the ID with contract
            Map<ID, Contract> mapOfIdWithContract = new Map<Id,Contract>([Select Id, SBQQ__Opportunity__r.Trigger__c From Contract where ID IN: amendedContractIDs]);
    
            //Map size check
            if(mapOfIdWithContract.size() > 0){
                
                //Loop over the new list of the Opportunity
                for(Opportunity opp : newOppList){
    
                    //Updating the value of the Trigger field of the Opportunity
                    opp.Trigger__c = mapOfIdWithContract.get(opp.SBQQ__AmendedContract__c).SBQQ__Opportunity__r.Trigger__c ;
                }
            }
        }
    }
    /*
    * Description   :  This method is update the Update From picklist field
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   01/05/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateACVAndTCV(List<Opportunity> newOpp, Map<Id, Opportunity> mapOfOpp){

        //Check for the by pass variable
        if(!QuoteTriggerHelper.BYPASS_OPPORTUNITY_TRIGGER){

            //Loop over the 
            for(Opportunity opp : newOpp){
    
                //Check for the Opportunity having the primary quote or not  Platform_Forecasted2__c
                /* Modified By Akshay Bagrecha - 09/27/2019 - CPQ-269 - isChange condition for the PPlatform Saas Amount.*/ 
                if(String.isNotBlank(opp.SBQQ__PrimaryQuote__c)){
    				
                    if((opp.ACV2__c != null && opp.ACV2__c != mapOfOpp.get(opp.Id).ACV2__c) 
                        || (opp.TCV2__c != null && opp.TCV2__c != mapOfOpp.get(opp.Id).TCV2__c)
                        ||  (opp.Platform_ACV__c != null && opp.Platform_ACV__c != mapOfOpp.get(opp.Id).Platform_ACV__c)
                        ||  (opp.Total_Service_Amount2__c != null && opp.Total_Service_Amount2__c != mapOfOpp.get(opp.Id).Total_Service_Amount2__c)
                        ||  (opp.Platform_Forecasted2__c != null && opp.Platform_Forecasted2__c != mapOfOpp.get(opp.Id).Platform_Forecasted2__c)
                        ||  (opp.Platform_SaaS_Amount__c != null && opp.Platform_SaaS_Amount__c != mapOfOpp.get(opp.Id).Platform_SaaS_Amount__c) ){
                
                        opp.Updated_From__c = OPPORTUNITY_OBJECT;
                    }
                }
            }
        }
    }
    
    /*
    * Description   :   This method is used for field update of Opportuity according to Process Builder
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/17/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateFieldAsProcessBuilder(List<Opportunity> opportunities, Map<Id, Opportunity> mapOfOpportunities){
        
        //Loop on New list of Opportunity 
        for(Opportunity opp : opportunities){
            
            //Check for necessary condition
            if(opp.Deal_Review_Request__c == true && (mapOfOpportunities == null || opp.Deal_Review_Request__c != mapOfOpportunities.get(opp.Id).Deal_Review_Request__c)){
                
                //Deal Desk Fields Update
                //Update Global Deal Desk fields
                opp.Submission_Date__c = System.Now();
                opp.Deal_Desk_Approval_Status__c = 'Open';
                opp.IT_Security_Approval__c = 'Open';
                opp.Legal_Finance_Approval__c = 'Open';
                opp.Product_Approval__c = 'Open';
                opp.Services_Approval__c = 'Open';
            }
            
            //IT/Security Approval Process
            //Check for necessay condition
            if(opp.IT_Security_Approval__c != null && (opp.IT_Security_Approval__c == 'Approved' || opp.IT_Security_Approval__c == 'Rejected') 
            && (mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).IT_Security_Approval__c != opp.IT_Security_Approval__c)){
                
                opp.IT_Security_Approved_Rejected_Date__c = System.now();
            }
            
            //Lead Source Populated on Opportunity
            //Check for necessay condition
            if(opp.LeadSource == null && (mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).LeadSource != opp.LeadSource)){
                
                opp.LeadSource = 'Marketing';
            }
            
            //Legal/Finance Approval Process
            //Check for necessay condition
            if(opp.Legal_Finance_Approval__c != null && (opp.Legal_Finance_Approval__c == 'Approved' || opp.Legal_Finance_Approval__c == 'Rejected') 
            && (mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).Legal_Finance_Approval__c != opp.Legal_Finance_Approval__c)){
                
                opp.Legal_Finance_Approved_Rejected_Date__c = System.now();
            }
            
            //Mark Platform Only Opportunities
            //Check for necessay condition
            if(opp.Platform__c&& !opp.Pay__c && !opp.Buy__c && !opp.Go__c && !opp.China__c && !opp.Supply_Chain_Finance__c && !opp.Dynamic_Discounting__c
                && (mapOfOpportunities == null 
                    || mapOfOpportunities.get(opp.Id).Platform__c != opp.Platform__c 
                    || mapOfOpportunities.get(opp.Id).Pay__c != opp.Pay__c
                    || mapOfOpportunities.get(opp.Id).Buy__c != opp.Buy__c
                    || mapOfOpportunities.get(opp.Id).Go__c != opp.Go__c
                    || mapOfOpportunities.get(opp.Id).China__c != opp.China__c
                    || mapOfOpportunities.get(opp.Id).Supply_Chain_Finance__c != opp.Supply_Chain_Finance__c
                    || mapOfOpportunities.get(opp.Id).Dynamic_Discounting__c != opp.Dynamic_Discounting__c)){
                        
                        opp.Platform_Only__c = true;
            }
            
            //Product Approval Process
            //Check for necessay condition
            if(opp.Product_Approval__c != null && (opp.Product_Approval__c == 'Approved' || opp.Product_Approval__c == 'Rejected') 
            && (mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).Product_Approval__c != opp.Product_Approval__c)){
                
                opp.Product_Approved_Rejected_Date__c = System.now();
            }
            
            //Services Approval Process
            //Check for necessay condition
            if(opp.Services_Approval__c != null && (opp.Services_Approval__c == 'Approved' || opp.Services_Approval__c == 'Rejected') 
            && (mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).Services_Approval__c != opp.Services_Approval__c)){
                
                opp.Services_Approved_Rejected_Date__c = System.now();
            }
            
            
            //Update Trigger to SDR if Blank
            //Check for necessay condition
            /*if(opp.Trigger__c != null && ( mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).Trigger__c != opp.Trigger__c )){
                
                opp.Trigger__c = 'SDR';
            }*/
            
            //Update Quote To Ordered
            //Check for necessay condition
            if(opp.StageName == '7 - Closed/Won' && opp.SBQQ__PrimaryQuote__c != null && ( mapOfOpportunities == null || mapOfOpportunities.get(opp.Id).StageName != opp.StageName )){
                
                opp.SBQQ__Contracted__c = true;
            }
            
            //Deal Desk Status and Date
            //Check for necessay condition IT_Security_Approval__c
            if((opp.Legal_Finance_Approval__c == 'Approved' || opp.Legal_Finance_Approval__c == 'N/A')
               && (opp.Product_Approval__c == 'Approved' || opp.Product_Approval__c == 'N/A')
               && (opp.Services_Approval__c == 'Approved' || opp.Services_Approval__c == 'N/A')
               && (opp.IT_Security_Approval__c == 'Approved' || opp.IT_Security_Approval__c == 'N/A')
               && (mapOfOpportunities == null 
                    || opp.IT_Security_Approval__c != mapOfOpportunities.get(opp.Id).IT_Security_Approval__c
                    || opp.Services_Approval__c != mapOfOpportunities.get(opp.Id).Services_Approval__c
                    || opp.Product_Approval__c != mapOfOpportunities.get(opp.Id).Product_Approval__c
                    || opp.Legal_Finance_Approval__c != mapOfOpportunities.get(opp.Id).Legal_Finance_Approval__c)){
                
                //Set Approval date to system.now
                opp.Approval_Date__c = System.now();
                
                //Set Deal desk Approval status to Approved
                opp.Deal_Desk_Approval_Status__c = 'Approved';
                
            }
            
            
            //Deal Desk Status and Date
            //Check for necessay condition IT_Security_Approval__c
            else if(opp.Legal_Finance_Approval__c == 'Rejected'
               || opp.Product_Approval__c == 'Rejected' 
               || opp.Services_Approval__c == 'Rejected' 
               || opp.IT_Security_Approval__c == 'Rejected'
               && (mapOfOpportunities == null 
                    || opp.IT_Security_Approval__c != mapOfOpportunities.get(opp.Id).IT_Security_Approval__c
                    || opp.Services_Approval__c != mapOfOpportunities.get(opp.Id).Services_Approval__c
                    || opp.Product_Approval__c != mapOfOpportunities.get(opp.Id).Product_Approval__c
                    || opp.Legal_Finance_Approval__c != mapOfOpportunities.get(opp.Id).Legal_Finance_Approval__c)){
                
                //Set Approval date to null
                opp.Approval_Date__c = null ;
                
                //Set Deal desk Approval status to Rejected
                opp.Deal_Desk_Approval_Status__c = 'Rejected';
                
            }
            
            //Deal Desk Status and Date
            //Check for necessay condition IT_Security_Approval__c
           else if(opp.Legal_Finance_Approval__c == 'Pending'
               || opp.Product_Approval__c == 'Pending' 
               || opp.Services_Approval__c == 'Pending' 
               || opp.IT_Security_Approval__c == 'Pending'
               && (mapOfOpportunities == null 
                    || opp.IT_Security_Approval__c != mapOfOpportunities.get(opp.Id).IT_Security_Approval__c
                    || opp.Services_Approval__c != mapOfOpportunities.get(opp.Id).Services_Approval__c
                    || opp.Product_Approval__c != mapOfOpportunities.get(opp.Id).Product_Approval__c
                    || opp.Legal_Finance_Approval__c != mapOfOpportunities.get(opp.Id).Legal_Finance_Approval__c)){
                
                //Set Approval date to null
                opp.Approval_Date__c = null ;
                
                //Set Deal desk Approval status to Pending
                opp.Deal_Desk_Approval_Status__c = 'Pending';
                
            }
            
            //Deal Desk Status and Date
            //Check for necessay condition IT_Security_Approval__c
            else if((opp.Legal_Finance_Approval__c == 'Approved' || opp.Legal_Finance_Approval__c == 'N/A' || opp.Legal_Finance_Approval__c == 'Open')
               && (opp.Product_Approval__c == 'Approved' || opp.Product_Approval__c == 'N/A' || opp.Product_Approval__c == 'Open')
               && (opp.Services_Approval__c == 'Approved' || opp.Services_Approval__c == 'N/A' || opp.Services_Approval__c == 'Open')
               && (opp.IT_Security_Approval__c == 'Approved' || opp.IT_Security_Approval__c == 'N/A' || opp.IT_Security_Approval__c == 'Open')
               && (mapOfOpportunities == null 
                    || opp.IT_Security_Approval__c != mapOfOpportunities.get(opp.Id).IT_Security_Approval__c
                    || opp.Services_Approval__c != mapOfOpportunities.get(opp.Id).Services_Approval__c
                    || opp.Product_Approval__c != mapOfOpportunities.get(opp.Id).Product_Approval__c
                    || opp.Legal_Finance_Approval__c != mapOfOpportunities.get(opp.Id).Legal_Finance_Approval__c)){
                
                //Set Deal desk Approval status to Open
                opp.Deal_Desk_Approval_Status__c = 'Open';
                
            }
        } 
    }
    
    /*
    * Description   :   This method is get the Lead source value from primary contact
    *               :   Opportunity Lead Source Process(Process Builder) 
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/16/2019
    *
    * Version       :   V1.0 Created
    *             
    */
     public static void updateOpportunityLeadSource(List<Opportunity> opportunities, Map<Id, Opportunity> mapOfOldOpportunities){
        
        //Set to hold the ID of Primary Contact
        Set<Id> contactIds = new Set<Id>();
        
        //Loop on new list of Opportunity
        for(Opportunity opp : opportunities){
            
            if(opp.Primary_Contact__c != null && (mapOfOldOpportunities == null || opp.Primary_Contact__c != mapOfOldOpportunities.get(opp.Id).Primary_Contact__c)){
                contactIds.add(opp.Primary_Contact__c);     
            }
        }
        
        //Size check for the set "contactIds"
        if(contactIds.size()  >0 ){
            
            //Map to hold the Primary COntact
            Map<Id, Contact> mapOfContacts = new Map<Id, Contact>([Select ID, LeadSource, Lead_Source_2__c, Lead_Source_3__c From Contact Where Id IN: contactIds ]);
            
            //Size check for the Map "mapOfContacts"
            if(mapOfContacts.size() > 0){
                
                //Loop on new list of Opportunity
                for(Opportunity opp : opportunities){ 
                    
                    //Map contains Check
                    if(mapOfContacts.containsKey(opp.Primary_Contact__c)){
                        opp.LeadSource = mapOfContacts.get(opp.Primary_Contact__c).LeadSource != null ? mapOfContacts.get(opp.Primary_Contact__c).LeadSource : '';
                        opp.Lead_Source_2__c = mapOfContacts.get(opp.Primary_Contact__c).Lead_Source_2__c != null ? mapOfContacts.get(opp.Primary_Contact__c).Lead_Source_2__c : '';
                        opp.Lead_Source_3__c = mapOfContacts.get(opp.Primary_Contact__c).Lead_Source_3__c != null ? mapOfContacts.get(opp.Primary_Contact__c).Lead_Source_3__c : '';
                    }
                }
            }
        }
    }
    
    /*
    * Description   :   This method is get the Lead source value from primary contact
    *               :   Update Contract Status(Process Builder) 
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/16/2019
    *
    * Version       :   V1.0 Created
    *             
    */
     public static void updateContractStatus(List<Opportunity> opportunities, Map<Id, Opportunity> mapOfOldOpportunities){
        
        //Set to hold the Opportunity Id
        Set<Id> opportunityIds = new Set<Id>();
        
        //Loop on new list of Opportunity
        for(Opportunity opp : opportunities){
            
            if(opp.StageName == '8 - Closed/Won (Locked)' && (mapOfOldOpportunities == null || opp.StageName != mapOfOldOpportunities.get(opp.Id).StageName)){
                    
                //Adding Opportunity Id in set  
                opportunityIds.add(opp.Id); 
            }
        }
        
        //Size check for the set  "opportunityIds"
        if(opportunityIds.size() > 0){
            
            //List of contract to be update
            List<Contract> contractsToBeUpddated = new List<Contract>();
            
            //Loop on the Contract
            for(Contract cont : [Select ID, Status From COntract Where SBQQ__Opportunity__c IN: opportunityIds]){
                
                contractsToBeUpddated.add(new Contract(Id = cont.Id, Status = 'Activated'));
            }
            
            //Size chec for the list "contractsToBeUpddated"
            if(contractsToBeUpddated.size() > 0)
                update contractsToBeUpddated;
        }
    }
    
    /*
    * Description   :   This method is to update the quote order to true
    *               :   Update Quote To Ordered(Process Builder) 
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/18/2019
    *
    * Version       :   V1.0 Created
    *             
    */
     public static void updateQuoteOrdered(List<Opportunity> opportunities, Map<Id, Opportunity> mapOfOldOpportunities){
        
        //To hold the primary quote
        Set<Id> primaryQuoteIds = new Set<Id>();
        
        //Loop on new list of Opportunity
        for(Opportunity opp : opportunities){
            
            if(opp.StageName == '7 - Closed/Won' && (mapOfOldOpportunities == null || opp.StageName != mapOfOldOpportunities.get(opp.Id).StageName)){
                
                if(opp.SBQQ__PrimaryQuote__c != null)
                    
                    //Adding quote Id in set    
                    primaryQuoteIds.add(opp.SBQQ__PrimaryQuote__c); 
            }
        }
        
        //Size check for the set "primaryQuoteIds"
        if(primaryQuoteIds.size() > 0){
            
            //List to hold the Quote
            List<SBQQ__Quote__c> quotesToBeUpdate = new List<SBQQ__Quote__c>();
            
            //Loop on the Quote
            for(SBQQ__Quote__c qt : [Select Id, SBQQ__Ordered__c From SBQQ__Quote__c Where Id IN: primaryQuoteIds]){
                quotesToBeUpdate.add(new SBQQ__Quote__c(Id = qt.Id, SBQQ__Ordered__c = true));
            }
            
            //Size check for the list "quotesToBeUpdate"
            if(quotesToBeUpdate.size() > 0)
                update quotesToBeUpdate;
        }
    }
    /*
    * Description   :   This method is used to update the triger value after renewal 
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/02/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateTriggerAfterRenewal(List<Opportunity> opportunities){
       /* 
        //Set to hold the amended contract value
        Set<Id> renewalContractIDs = new Set<Id>();

        //Loop over the new list of Opportunity
        for(Opportunity opp : opportunities){
            
            //Null Check for the amended contract value
            if(opp.SBQQ__RenewedContract__c != null)
                
                //Adding into set
                renewalContractIDs.add(opp.SBQQ__RenewedContract__c);
        }
        //Size check for the set "renewalContractIDs"
        if(renewalContractIDs.size() > 0) {
            
            //Map to hold the ID with contract
            Map<ID, Contract> mapOfIdWithContract = new Map<Id,Contract>([Select Id, SBQQ__Opportunity__r.Trigger__c From Contract where ID IN: renewalContractIDs]);
    
            //Map size check
            if(mapOfIdWithContract.size() > 0){
                
                //Loop over the new list of the Opportunity
                for(Opportunity opp : opportunities){
    
                    //Updating the value of the Trigger field of the Opportunity
                    opp.Trigger__c = mapOfIdWithContract.get(opp.SBQQ__RenewedContract__c).SBQQ__Opportunity__r.Trigger__c ;
                }
            }
        }*/
         //Loop over the new list of Opportunity
        for(Opportunity opp : opportunities){
            
            //Null Check for the amended contract value
            if(opp.SBQQ__RenewedContract__c != null & opp.Trigger__c == null)

                //Update Trigger__c to Customer Value
                opp.Trigger__c = 'Customer Value';    
        }
    }
}