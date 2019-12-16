/** 
*    Description     :      This class is used as a controller page for the adjust product button
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      10/07/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                      
**/
public with sharing class AdjustProductController {
    
    
    //List to hold the all Subscription product
    public Integer lineKey;

    //To hold the quote line ID
    public String quoteId{get; set;}
    
    public AdjustProductController() {
        //Getting the quote ID from the page parameter
        quoteId =  ApexPages.currentPage().getParameters().get('id');
        lineKey = [Select ID From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: quoteId AND SBQQ__SegmentLabel__c != null ].size() + 2;
        System.debug('quoteId  :: '+quoteId);
    }
    
    //Usedd to redirect to product config screen
    public PageReference init(){
        Pagereference URLProductConfig;
        
        if(quoteId != null){
            CPQ_BaseURL__c CPQbaseURL = [Select URL__c From CPQ_BaseURL__c LIMIT 1];
            String URL = CPQbaseURL.URL__c.removeEndIgnoreCase('/');  
            URLProductConfig = new Pagereference('https://'+URL+'/apex/sbqq__sb?id='+quoteId+'#/product/pc?lineKey='+lineKey+'&qId='+quoteId+'&ignoreCache=true');
            return URLProductConfig;
        }
        return null;
    }
}