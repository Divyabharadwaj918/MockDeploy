/*
* Description   :   Trigger will fire on before insert, before update, after insert, after update, before delete
*
* Created By    :   Akshay Bagrecha
*
* Created Date  :   21/02/2019
*
* Version       :   V1.0 Created
*               :   V1.1 Update By Akshay Bagrecha 07/18/2019
*             
*/
trigger Trigger_Quote on SBQQ__Quote__c (before insert, before update, after insert, after update, before delete, after delete) {
    CustomTriggers__c cT =CustomTriggers__c.getOrgDefaults();
    if(cT.Active_Custom_Trigger_on_Quote__c){
        try { 
            //Checks for before trigger
            if(Trigger.isBefore) {
                
                //Checks for insert operation
                if(Trigger.isInsert) {
                    
                    //Calling Tigger helper class method
                    /* This method is used to update Quote values after amendment */
                    QuoteTriggerHelper.updateQuoteAfterAmendment(Trigger.new);
                    
                    /* This method is used to update Quote values after renewals */
                    /* Commenting due to being deployed in production without this method.*/
                    QuoteTriggerHelper.updateQuoteAfterRenewal(Trigger.new);
                    
                    /* This method is used to update Subscription Term on Quote */
                    //QuoteTriggerHelper.updateSubscriptionTerm(Trigger.new);
                    
                    /* This method is used populate the SBQQ__StartDate__c from Effective_Date__c */
                    QuoteTriggerHelper.updateStartDate(Trigger.new, Trigger.oldMap);
                    
                    /* This method is used to populate the currency code from opportunity to quote */
                    QuoteTriggerHelper.updateCurrencyAsOpp(Trigger.new);
                    
                    /* */
                    //QuoteTriggerHelper.updateSubscriptionTermWithDays(Trigger.new, Trigger.oldMap);
                    
                    /*Calling method to set quote as Primary, if it the inserted quote is the only quote for the related Opportuinty*/
                    QuoteTriggerHelper.setFirstQuoteAsPrimary(trigger.new);
                    
                    /*Method to get the company address from the metadata*/ 
                    QuoteTriggerHelper.updateCompanyAddress(Trigger.new, Trigger.oldMap);
                }
                
                if(trigger.isUpdate){
                    
                    /* Method to update the subscription term */
                    QuoteTriggerHelper.updateSubscriptionTermWithDays(Trigger.new, Trigger.newMap); 
                    
                    /*Method to get the company address from the metadata*/ 
                    QuoteTriggerHelper.updateCompanyAddress(Trigger.new, Trigger.oldMap); 
                    
                }
                if(Trigger.isUpdate ) {
                    //Method calling
                    /* This method is used to check, if Dynamic Discount/Invoice Compliance/Pay Product are related to the Quote */ 
                    QuoteTriggerHelper.isDynamicDiscountOrICProductExist(Trigger.new);
                    
                    
                }
                //Check for the Update operation 
                if(Trigger.isUpdate && !QuoteTriggerHelper.BYPASS_OPPORTUNITY_TRIGGER) {
                    
                    /* This method is used  update Difference_Amount__c to 0 when there is no quote line items*/
                    QuoteTriggerHelper.udpdateQuoteFields(Trigger.new);
                    
                    /* This method is used populate the SBQQ__StartDate__c from Effective_Date__c */
                    QuoteTriggerHelper.updateStartDate(Trigger.new, Trigger.oldMap);
                }
            }
            
            //Check for after insert, update operation
            if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
                
                //Method calling
                /* This method is used update the value of the Opportunity field like ACV, TCV, Update from. */
                QuoteTriggerHelper.updateOpportunityDetails(Trigger.new, Trigger.oldMap);  
                
                /* This method is used to update Start and End Date on The Opportunity */
                QuoteTriggerHelper.updateOpportunityDate(Trigger.new, Trigger.oldMap);       
            }
            //Check for after update operation
            if(Trigger.isAfter && Trigger.isUpdate ){  
                
                //Method calling 
                
                /* This method is used Calulate the ACV value for the quoteLines */
                QuoteTriggerHelper.updateAverageACV(Trigger.new, Trigger.oldMap); 
                
                /* This is method is used calulate the average deviation. */
                QuoteTriggerHelper.updateAverageDeviation(Trigger.new, Trigger.oldMap); 
            }
            
            //Check for the after delete operation
            if(trigger.isAfter && trigger.isDelete) {
                
                //Method calling
                /* Method to restrict user, not to delete the primary Quote */
                QuoteTriggerHelper.changePrimaryQuoteOnDelete(trigger.old);  
            }
        }catch (Exception e) {
            System.debug('Exception' + e.getMessage());
        }
    }
}