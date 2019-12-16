/*
* Description   :   Helper class of the Opportunity line item trigger
*
* Created By    :   Akshay Bagrecha
*
* Created Date  :   05/01/2019
*
* Version       :   V1.0 Created.
*               :   V1.1 Updated By Akshay Bagrecha 07/18/2019.
*               :   V1.2 Updated By Akshay Bagrecha 07/29/2019 for CPQ-202.
*             
*/
public class OpportunityLineItemTriggerHelper {

    //Method to update the product family, Product code, start date and end date from quote line
    public static void updateProductFamily(List<OpportunityLineItem> oppItems, Map<Id, OpportunityLineItem> mapOppItems){
    
        //Set to hold the Quote Line Item
        Set<Id> quoteItemIds = new Set<Id>();
        
        //Loop over the  Opportunity Line Item
        for(OpportunityLineItem oppLineItem : oppItems){
            
            //Checks for the null
            if(oppLineItem .SBQQ__QuoteLine__c != null && (mapOppItems == null || oppLineItem.SBQQ__QuoteLine__c != mapOppItems.get(oppLineItem.Id).SBQQ__QuoteLine__c)){
                
                //Adding Id into set
                quoteItemIds.add(oppLineItem.SBQQ__QuoteLine__c);
            }    
        }
        
        //Size check for the set "quoteItemIds"
        if(quoteItemIds.size() > 0){ 
            
            //Map to hold the Quote line item with ID
            Map<Id, SBQQ__QuoteLine__c> mapOfQuoteItems = new Map<Id, SBQQ__QuoteLine__c>([Select ID, SBQQ__ProductFamily__c, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__ProductCode__c From SBQQ__QuoteLine__c Where ID IN: quoteItemIds]);
            
            //Map size check
            if(mapOfQuoteItems.size() > 0){
                
                //Loop over the  Opportunity Line Item
                for(OpportunityLineItem oppLineItem : oppItems){
                    
                    //To update the product family, start date, end date and product code
                    oppLineItem.Product_Family1__c = mapOfQuoteItems.containsKey(oppLineItem.SBQQ__QuoteLine__c) ? mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).SBQQ__ProductFamily__c  : '' ;
                    oppLineItem.Start_Date__c = mapOfQuoteItems.containsKey(oppLineItem.SBQQ__QuoteLine__c) ? mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).SBQQ__StartDate__c  : null;
                    oppLineItem.End_Date__c = mapOfQuoteItems.containsKey(oppLineItem.SBQQ__QuoteLine__c) ? mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).SBQQ__EndDate__c  : null ;
                    oppLineItem.Product_Code__c = mapOfQuoteItems.containsKey(oppLineItem.SBQQ__QuoteLine__c) ? mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).SBQQ__ProductCode__c  : '';
                                                    
                }
            }
        }
    }
    
    /*
    * Description   :   This method is used update ACV from the quoteline.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   05/30/2019
    *
    * Version       :   V1.0 Created
    * 
    */
    public static void updateACVFromQL(List<OpportunityLineItem> oppItems, Map<Id, OpportunityLineItem> mapOppItems){
        
        //Set to hold the QUoteLineIds
        Set<ID> quoteLineIds = new Set<Id>();

        //Loop over the Opportunity line item
        for(OpportunityLineItem oppLineItem :oppItems){
            
            //Checks for the null
            if(oppLineItem.SBQQ__QuoteLine__c != null){
                quoteLineIds.add(oppLineItem.SBQQ__QuoteLine__c);
            }
        }

        //Size check for set "quoteLineIds"
        if(quoteLineIds.size() > 0){
            //Map to hold the Quote line item with ID
            Map<Id, SBQQ__QuoteLine__c> mapOfQuoteItems = new Map<Id, SBQQ__QuoteLine__c>([Select ID, ACV_amt__c From SBQQ__QuoteLine__c Where ID IN: quoteLineIds]);

            //Size check for map " mapOfQuoteItems "  
            if(mapOfQuoteItems.size() > 0){
                
                //Loop on new opportunitylineItem
                for(OpportunityLineItem oppLineItem :oppItems){

                    //Contains Check
                    if( mapOfQuoteItems.containsKey(oppLineItem.SBQQ__QuoteLine__c))
                        oppLineItem.ACV_amt__c = mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).ACV_amt__c != null ? mapOfQuoteItems.get(oppLineItem.SBQQ__QuoteLine__c).ACV_amt__c : 0;
                }
            } 
        }
    }     
}