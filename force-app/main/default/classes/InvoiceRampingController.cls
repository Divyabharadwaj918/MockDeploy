/** 
*    Description     :      This class is used for the invoice ramp page and its calculation part
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      16/01/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                      
**/
public without sharing class InvoiceRampingController {
    
    //String for Quote Id
    public String quoteId{get; set;}
    
    //Integer for year value
    public Integer totalYears{get; set;}
    
    //List to hold the year string
    public List<String> yearsValue{get; set;}
    
    //For subcription term value
    public Integer subcriptionTerm;
    
    public Integer test {get; set;}
    
    public List<InvoiceWrapper> invoicePerYear {get; set;}
    
    private String editionName ='';
    
    public Integer quoteStartingYear ;

    //
    Public Integer invoiceAmt{get; set;}

    //Duplicate list to hold the invoice per Year
    public List<Decimal> invoicePerYearDUP;
    
    public InvoiceRampingController() {
         invoicePerYear  = new List<InvoiceWrapper>();
            
         test = 0;
        invoicePerYearDUP = new List<Decimal>();
        //Initialise
        yearsValue= new List<String>();
        totalYears= 0;    
        quoteId= ApexPages.currentPage().getParameters().get('qid');

        InvoiceRamping(quoteId);
    }

     public InvoiceRampingController(String quoteIDIc){ 

         invoicePerYear  = new List<InvoiceWrapper>();
            
         test = 0;
        
        //Initialise
        yearsValue= new List<String>();
        totalYears= 0;    
        invoicePerYearDUP = new List<Decimal>();

        InvoiceRamping(quoteIDIc);



    }

  //Controller
    public void InvoiceRamping (String quoteIDIc){
        
        invoicePerYear  = new List<InvoiceWrapper>();
        
        test = 0;
        
        //Initialise
        yearsValue= new List<String>();
        totalYears= 0;
        
        //Getting from URL parameter
        quoteId=quoteIDIc;
        //Query on quote
        List<SBQQ__Quote__c> qt = [Select Name, SBQQ__SubscriptionTerm__c,SBQQ__StartDate__c,CreatedDate,SBQQ__EndDate__c , (SELECT Id,SBQQ__EndDate__c,SBQQ__StartDate__c, SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__Product__r.Edition__c, SBQQ__ProductName__c FROM SBQQ__LineItems__r WHERE SBQQ__ProductFamily__c != '')  From SBQQ__Quote__c Where Id =: quoteId.trim() Limit 1];
        
        //Checking necessary condition
        if(qt[0].SBQQ__SubscriptionTerm__c == null){
            
            //Apex page error message
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Subcription term value on Quote'));
        }
        else if(qt[0].SBQQ__LineItems__r.size() <= 0){
            //Apex page error
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please click the quick save button after adding products, Click cancel button to navigate back'));
        
        }
        else {
            editionName = qt[0].SBQQ__LineItems__r[0].SBQQ__Product__r.Edition__c;
            //For total year value
            quoteStartingYear = qt[0].SBQQ__StartDate__c == null ? qt[0].CreatedDate.Year() : qt[0].SBQQ__StartDate__c.Year();
            totalYears = Math.mod(Integer.ValueOf(qt[0].SBQQ__SubscriptionTerm__c), 12) == 0 ? Integer.valueOf(qt[0].SBQQ__SubscriptionTerm__c/12) : Integer.valueOf(qt[0].SBQQ__SubscriptionTerm__c/12+1) ;
        }
        //System.assert(false, qt[0].SBQQ__LineItems__r.size() + '---' + qt[0].SBQQ__LineItems__r);
        //List
       /* for(Integer i=1; i<= totalyears; i++) {
            yearsValue.add('Year ' +i);
            invoicePerYear.add(new InvoiceWrapper(0));
        }*/
        Integer i = 1; 
        
        for(SBQQ__QuoteLine__c qteLine : qt[0].SBQQ__LineItems__r) {
            
            if(i <= totalYears){
                if(qteLine.SBQQ__EndDate__c!= null && qteLine.SBQQ__EndDate__c.year()- quoteStartingYear  == i){
                    String yearAsKey = 'Year '+i;
                     yearsValue.add(yearAsKey);
                     invoicePerYear.add(new InvoiceWrapper(qteLine.SBQQ__Quantity__c, yearAsKey));
                    System.debug(yearAsKey+' : '+qteLine.SBQQ__Quantity__c);
                    invoicePerYearDUP.add(qteLine.SBQQ__Quantity__c);
                   i++;
                }
                else if(qteLine.SBQQ__EndDate__c!= null && qteLine.SBQQ__EndDate__c.month()- qteLine.SBQQ__StartDate__c.month()  > 0&& qteLine.SBQQ__EndDate__c.month()- qteLine.SBQQ__StartDate__c.month()  < 13 ){
                    String yearAsKey = 'Year '+i;
                     yearsValue.add(yearAsKey);
                     invoicePerYear.add(new InvoiceWrapper(qteLine.SBQQ__Quantity__c, yearAsKey));
                    System.debug(yearAsKey+' : '+qteLine.SBQQ__Quantity__c);
                    invoicePerYearDUP.add(qteLine.SBQQ__Quantity__c);
                   i++;
                }
            }
        }
        //
        //invoicePerYearDUP.addAll(invoicePerYear);
             
    }
    /**
    * Description   :   This method to perform the calculation and save quoteline 
    *
    * Arguments     :   null
    *
    * Return        :   PageReference
    *
    * Version       :   V1.0 Created
    *             
    **/
    public PageReference saveInvoiceRamp(){
        
        getInvoiceCompliance();

        //String for base URL
        String baseUrlList = System.URL.getSalesforceBaseUrl().getHost();
        System.debug('baseUrlList'+baseUrlList);
        List<String> baseUrl = new List<String>();
        String finalUrl;
        //Split method
        if(baseUrlList.contains('--c')){
            baseUrl = baseUrlList.split('--c'); 
            //FinalUrl with extra parameter
            finalUrl= 'https://'+baseUrl[0]+'--sbqq'+baseUrl[1]+'/apex/sb?scontrolCaching=1&id='+quoteId.trim();
        }
        else {
			finalURl = baseUrlList;          
        }
        System.debug('final url '+finalURl);
        
        //PAgeRefernce variable
        PageReference pR =  new PageReference(finalUrl);
        pR.setRedirect(true);
        
        //Return
        return pR;
    }
    /**
    * Description   :   This method to cancel page
    *
    * Arguments     :   null
    *
    * Return        :  
    *
    * Version       :   V1.0 Created
    *             
    **/
    public void getInvoiceCompliance(){

        //Set to hold the quoteline ID
        Set<Id> quoteLineIds = new Set<Id>();

        //List of the invoice compliance 
        Map<String, Map<String, List<Invoice_Compliance_Details__c>>> mapOfStringWithInvoiceCompliances = new Map<String, Map<String, List<Invoice_Compliance_Details__c>>>();

        //Index
        Integer index = 0;

        //To hold the change quantity year
        Set<String> years =  new Set<String>();

        //List of inovice compliance
        List<Invoice_Compliance_Details__c> updateInvoiceDetails = new List<Invoice_Compliance_Details__c>();

        //Compare calculation
        for(InvoiceWrapper wrap : invoicePerYear){
            index = Integer.valueOf(wrap.yearTerm.replaceAll('[^1-9]',''));
            if( wrap.quantity != invoicePerYearDUP[index-1]){
                years.add(String.valueOf(index));
            }
        }

        for( SBQQ__QuoteLine__c qtline : [Select Id From SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId.trim()]){
            quoteLineIds.add(qtline.ID);
        }
        //System.assert(false, [Select Name, Quote_Line__c, Value_in_Amount__c, Value_in_Percent__c, Year__c From Invoice_Compliance_Details__c Where Quote_Line__c IN: quoteLineIds Order By Year__c ASC].size());
        for(Invoice_Compliance_Details__c inComp : [Select Name, Quote_Line__c, Value_in_Amount__c, Value_in_Percent__c, Year__c From Invoice_Compliance_Details__c Where Quote_Line__c IN: quoteLineIds AND Year__c IN: years Order By Year__c ASC]){
            if(!mapOfStringWithInvoiceCompliances.containsKey(inComp.Name)){
                mapOfStringWithInvoiceCompliances.put(inComp.Name, new Map<String, List<Invoice_Compliance_Details__c>>());
                if(!mapOfStringWithInvoiceCompliances.get(inComp.Name).containsKey(inComp.Year__c))
                    mapOfStringWithInvoiceCompliances.get(inComp.Name).put(inComp.Year__c, new List<Invoice_Compliance_Details__c>());
                mapOfStringWithInvoiceCompliances.get(inComp.Name).get(inComp.Year__c).add(inComp);
            }
            else{
                if(!mapOfStringWithInvoiceCompliances.get(inComp.Name).containsKey(inComp.Year__c)){
                    mapOfStringWithInvoiceCompliances.get(inComp.Name).put(inComp.Year__c, new List<Invoice_Compliance_Details__c>());
                mapOfStringWithInvoiceCompliances.get(inComp.Name).get(inComp.Year__c).add(inComp);
                }
                else
                    mapOfStringWithInvoiceCompliances.get(inComp.Name).get(inComp.Year__c).add(inComp);
            }
        }
        //System.assert(false,mapOfStringWithInvoiceCompliances.size()+'=='+mapOfStringWithInvoiceCompliances);
        if(mapOfStringWithInvoiceCompliances.size() > 0){
            for(String compType : mapOfStringWithInvoiceCompliances.keySet()){
                for(List<Invoice_Compliance_Details__c> invoiceCompDetails : mapOfStringWithInvoiceCompliances.get(compType).values()){
                    for(Invoice_Compliance_Details__c invoiceComp : invoiceCompDetails){
                        invoiceComp.Value_in_Amount__c =  invoicePerYear[Integer.valueOf(invoiceComp.Year__c)-1].quantity * invoiceComp.Value_in_Percent__c / 100;
                        updateInvoiceDetails.add(invoiceComp);
                    }
                }
            }
        }
        //System.assert(false,updateInvoiceDetails);
        try{
            if(updateInvoiceDetails.size() > 0)
                update updateInvoiceDetails;
        }
        catch(Exception ex){
            System.assert(false, ex.getMessage()+'==='+ex.getLineNumber());

        }
    }

    /**
    * Description   :   This method to redriect to the previous page on hitting cancel page
    *
    * Arguments     :   null
    *
    * Return        :   PageReference
    *
    * Version       :   V1.0 Created
    *             
    **/
    public PageReference cancelInvoiceRamp(){
        
        //String for base URL
        String baseUrlList = System.URL.getSalesforceBaseUrl().getHost();
        System.debug('url'+baseUrlList);
        
        //Split method
        List<String> baseUrl = baseUrlList.split('--c'); 
        System.debug('base'+baseUrl);
        
        //FinalUrl with extra parameter
        String finalUrl = 'https://'+baseUrl[0]+'--sbqq'+baseUrl[1]+'/apex/sb?scontrolCaching=1&id='+quoteId.trim();
        System.debug('final url '+finalURl);
        
        //PAgeRefernce variable
        PageReference pR =  new PageReference(finalUrl);
        System.debug(pR);
        pR.setRedirect(true);
        
        //Return
        return pR;
    }
    public Class InvoiceWrapper {
        public String yearTerm{get; set;}
        public Integer quantity {get; set;}
        public InvoiceWrapper (Decimal quantity, String yearV) {
            this.quantity = Integer.valueOf(quantity);
            this.yearTerm = yearV;
        }
    }
    
}