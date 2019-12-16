/*
* Description   :   Trigger will fire on before and after
*
* Created By    :   Akshay Bagrecha
*
* Created Date  :   25/02/2019
*
* Version       :   V1.0 Created
*               :   V1.1 Updated By Akshay Bagrecha 07/18/2019
*             
*/
trigger Trigger_QuoteLine on SBQQ__QuoteLine__c (before update, before insert,after insert, after update) {
   	CustomTriggers__c cT =CustomTriggers__c.getOrgDefaults();
    if(cT.Active_Custom_Trigger_on_QuoteLine__c){
        try {
            
            //if(!QuoteLineTriggerHelper.callingFromQuoteLine && !QuoteTriggerHelper.callingFromQuote) {
            if(true) {  
                //Before Event
                if(Trigger.isBefore ){
                    
                    //Update Operation
                    if(Trigger.isUpdate){
                        
                        //Method Calling   
                        QuoteLineTriggerHelper.updateInvoiceCompliance(Trigger.new);    
                    }
                }
            }
            
            QuoteLineTriggerHelper.callingFromQuoteLine = true;
            QuoteLineTriggerHelper.count++ ;
        }catch (Exception e) {
            System.debug('Exception ' + e.getMessage());
        }
    }
}