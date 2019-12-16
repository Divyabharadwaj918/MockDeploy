/** 
*    Description     :      This class is used as a helper of the quoteline trigger
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      05/03/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                    :      V_1.1 - Updated By Akshay Bagrecha 07/18/2019
*                      
**/
public class QuoteLineTriggerHelper {
    
    public static Integer count = 0;
    //By pass variable
    public static Boolean byPassTrigger = true;
    public static Boolean byPassQuoteLineUpdateBasePrice = true;
    public static Boolean bypassLineTrigger = false;
    public static Boolean trueFromTrigger = false;
    public static Boolean callingFromQuoteLine = false;
    
    
    //To bypass the quote trigger method.
    public static Boolean isBreak = false;
    
    //Set to hold the product bundles.
    public static Set<String> productBundles = new Set<String>();
    
    //Map to hold the quote ID with quoteLine
    public static Map<Id, SBQQ__QuoteLine__c> mapOfQuoteLines = new Map<Id, SBQQ__QuoteLine__c>();

    //for invoice compliance 
    public static void updateInvoiceCompliance(List<SBQQ__QuoteLine__c> newQuoteLines){

        //Loop over the new list of the Quote lines
        for(SBQQ__QuoteLine__c qt : newQuoteLines){
            
            //Checks for the Invoice compliance only
            if(qt.SBQQ__ProductName__c == Constants.INVOICE_COMPLIANCE_NAME){
                
                //Updating the Values
                qt.SBQQ__ListPrice__c = ((qt.Post_audit_India__c != null ? qt.Post_audit_India__c : 0) + (qt.Clearance_Italy__c != null ? qt.Clearance_Italy__c : 0) + (qt.Clearance_Turkey__c != null ? qt.Clearance_Turkey__c : 0) + (qt.Clearance_Argentina__c != null ? qt.Clearance_Argentina__c : 0) + (qt.Clearance_Rest_of_Latin_America__c != null ? qt.Clearance_Rest_of_Latin_America__c : 0) + (qt.China_GTS__c != null ? qt.China_GTS__c: 0)) / qt.SBQQ__ProrateMultiplier__c ;

                qt.SBQQ__NetPrice__c = (qt.Post_audit_India__c + qt.Clearance_Italy__c + qt.Clearance_Turkey__c + qt.Clearance_Argentina__c + qt.Clearance_Rest_of_Latin_America__c + qt.China_GTS__c 
                                       - ( qt.SBQQ__TotalDiscountRate__c > 0 ? (qt.SBQQ__TotalDiscountRate__c/ 100) * (qt.Post_audit_India__c + qt.Clearance_Italy__c + qt.Clearance_Turkey__c + qt.Clearance_Argentina__c + qt.Clearance_Rest_of_Latin_America__c + qt.China_GTS__c) : 0))
                                       + (((qt.Post_audit_India__c != null ? qt.Post_audit_India__c : 0) + (qt.Clearance_Italy__c != null ? qt.Clearance_Italy__c : 0) + (qt.Clearance_Turkey__c != null ? qt.Clearance_Turkey__c : 0) + (qt.Clearance_Argentina__c != null ? qt.Clearance_Argentina__c : 0) + (qt.Clearance_Rest_of_Latin_America__c != null ? qt.Clearance_Rest_of_Latin_America__c : 0) + (qt.China_GTS__c != null ? qt.China_GTS__c: 0)) * qt.UpliftPercent__c ) / 100 ;
                
            }
        }
    }
}