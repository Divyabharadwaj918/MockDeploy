/** 
    *    Description     :      This class is used for the invoice compliance page
    *
    *    Created By      :      Akshay Bagrecha
    *
    *    Created Date    :      16/01/2019
    * 
    *    Revision Logs   :      V_1.0 - Created
    *                      
    **/
global without sharing class InvoiceComplianceController {
    
    //Wrapper List
    global List<invoiceWrapper> invoiceNumberWithvalues {get; set;}
   
    //To hold the quote line ID
    public String quoteLineId{get; set;}

     //To hold the quote line ID
    public String quoteId{get; set;}

    //To told the total  
    public Integer totalYears{get; set;}

    //To hold the invoice amount per year
    public List<Integer> yearsInvoiceValue{get; set;}
    
    //To hold the invoice amount per year
    public List<ScanningInvoice> yearsInvoiceValue1{get; set;}
    
    //For quote line with subcription term year
    public List<SBQQ__Quote__c> quote;

    //For quote line with invoicees per year per quoteline
    public List<SBQQ__QuoteLine__c> quoteLinesWithName;

    //Map to hold the compliance type per year
    public Map<String, Map<String, Invoice_Compliance_Details__c>> mapOfCompTypeWithalue{get; set;}

    //Map to hold the compliance type with List of wrapper
    public Map<String, List<invoiceWrapper>> mapWithCompTypeWithWrapper {get; set;}

    //Set to hold the quoteline ID
    public Set<Id> quoteLineIds = new Set<Id>();
    
    //Wrapper Map to hold the information for the Pay product
    public Map<String, QuoteLineInfo> mapOfWrapperForPay {get; set;}
    
    //To hold size of the map 'mapOfWrapperForPay'
    public Integer sizeOfmapOfWrapperForPay{get; set;}
    
    //To hold the minimum quantity
    public String minQuantity{get; set;}
    
    //To hold the maximum quantity
    public String maxQuantity{get; set;}
    
    //To hold the URL for to navigate to product configuration screen
    public String URLProductConfig{get; set;}
    
    //To hold the Avg Discount for the Pay product
    public String avgPayDiscount {get; set;}
    
    //To hold the Currency ISO code
    public String currenyISO{get; set;}
    
    //To hold the Identifier that discount is in percent or amount
    public String discountIdentify{get; set;}
    
    //To hold the Identifier that discount is in percent or amount
    public String upliftIdentify{get; set;}
    
    //To hold the name of the Pay product
    public String payProductName{get; set;}  
    
    //To hold the true if the discount is in percent
    public Boolean isDiscountInPercent{get; set;}
    
    //To hold the true if the discount is in amount
    public Boolean isDiscountInAmount{get; set;}
    
    //To hold the Null value
    Integer nullConst;
    
    //List to hold the all Subscription product
     Integer lineKey;
     
     //To hold the size of the map "mapOfCompTypeWithalue"
     public Integer sizeOfmapOfCompTypeWithalue{get; set;}
     
     //To get the Currency Symbol
     public String currencySymbol{get; set;}
     
     //To hold the avg uplift
     public String avgUplift{get; set;}
     
     //To Parse the map into string
     public String JSONmap{get; set;}
     
     //To hold the uplift per year
     public Map<String, Decimal> mapofUpliftWithYear{get; set;}
     
     //To hold the value of the avg uplift and discount
     public String avgUpliftDisount{get; set;}
    
    //Constructor
    public InvoiceComplianceController(){

        try { 
 
            //Initialization 
            quote = new List<SBQQ__Quote__c>();
            yearsInvoiceValue = new List<Integer>();
            yearsInvoiceValue1 = new List<ScanningInvoice>();
            quoteLinesWithName = new List<SBQQ__QuoteLine__c>();
            invoiceNumberWithvalues = new List<invoiceWrapper>();
            mapOfCompTypeWithalue = new Map<String, Map<String, Invoice_Compliance_Details__c>>();
            mapWithCompTypeWithWrapper = New Map<String, List<invoiceWrapper>>();
            sizeOfmapOfWrapperForPay = 0;
            URLProductConfig = '';
            avgPayDiscount = '0.0';
            lineKey = 0;
            currenyISO = '';
            discountIdentify = '';
            payProductName = '';
            isDiscountInAmount= false;
            isDiscountInPercent = false;
            currencySymbol = '';
            sizeOfmapOfCompTypeWithalue = 0;
            avgUplift = '0.0';
            mapofUpliftWithYear = new Map<String, Decimal>();
            upliftIdentify = '';
            avgUpliftDisount = '';
            
            mapOfWrapperForPay = new Map<String, QuoteLineInfo >();

            //Getting the quote ID from the page parameter
            quoteId =  ApexPages.currentPage().getParameters().get('id');
            
            if(quoteId == 'undefined') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please click on the quick save and then press again'));
            }

            else {
                lineKey = [Select ID From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: quoteId AND SBQQ__SegmentLabel__c != null ].size() + 2;
                quote = [SELECT Id, Avg_Additional_Discount_for_Pay__c, Difference_Amount__c FROM SBQQ__Quote__c where Id =:quoteId Limit 1];
                quoteLinesWithName = [SELECT SBQQ__Quantity__c, UpliftAmount__c, UpliftPercent__c, SBQQ__ListPrice__c,
                                             SBQQ__ListTotal__c, SBQQ__SegmentLabel__c, SBQQ__Quote__r.CurrencyIsoCode,
                                             SBQQ__SegmentIndex__c, Invoices__c, SBQQ__NetTotal__c, SBQQ__ProductName__c, 
                                             SBQQ__AdditionalDiscountAmount__c, SBQQ__Discount__c, SBQQ__Existing__c, SBQQ__Bundle__c, 
                                             SBQQ__Product__r.Average_Annual_Invoice_Volume__c, SBQQ__PriorQuantity__c, 
                                             SBQQ__Quote__r.Subscription_Term_Months__c	, SBQQ__Quote__r.SBQQ__StartDate__c, 
                                             SBQQ__Quote__r.SBQQ__EndDate__c, Base_Price__c, SBQQ__NetPrice__c, SBQQ__ProrateMultiplier__c
                                        FROM SBQQ__QuoteLine__c 
                                        WHERE (SBQQ__ProductName__c = 'Scanning Services' OR SBQQ__ProductName__c LIKE 'Pay%') AND SBQQ__Quote__c =: quoteId AND (NOT SBQQ__ProductName__c like '%Subcontractor%')
                                        ];
                if(quoteLinesWithName.size() > 0) {
                    
                    //To hold the quoteLine ID
                    quoteLineId = quoteLinesWithName[0].ID;
                    
                    //Start and end year of the quote
                    Integer startYear = quoteLinesWithName[0].SBQQ__Quote__r.SBQQ__StartDate__c.year();
                    Integer endYear = quoteLinesWithName[0].SBQQ__Quote__r.SBQQ__EndDate__c.year();
                    
                    //Currency ISO code
                    currenyISO = quoteLinesWithName[0].SBQQ__Quote__r.CurrencyIsoCode;                    
                    currencySymbol = Constants.getCurrencySymbolFromIso(currenyISO);
                    
                    //To hold the average
                    avgPayDiscount = '0.0'/*(quote[0].Avg_Additional_Discount_for_Pay__c!= null ? String.valueOf(quote[0].Avg_Additional_Discount_for_Pay__c.setScale(2)) : '0')*/;
                    avgUpliftDisount = '0.0'/*(quote[0].Difference_Amount__c!= null ? String.valueOf(quote[0].Difference_Amount__c.setScale(2)) : '0')*/;
                    
                    //Count for leap year
                    Integer countLeapYear = 0;
                    for(Integer yearStart = startYear; yearStart <= endYear; yearStart++){
                        if(Date.isLeapYear(yearStart)){
                            countLeapYear++;
                        }
                    }
                    //to get subscription of the quote
                    Integer subscriptionTermQuote = Integer.valueOf(quoteLinesWithName[0].SBQQ__Quote__r.Subscription_Term_Months__c	.round(System.RoundingMode.CEILING));
                    //totalYears = Math.mod(Integer.ValueOf(subscriptionTermQuote), 365) > 0 ? Integer.valueOf(subscriptionTermQuote/365 +1) : Integer.valueOf(subscriptionTermQuote/365) ;
                    
                    totalYears = Math.mod(Integer.ValueOf(subscriptionTermQuote), 12) == 0 ? Integer.ValueOf(subscriptionTermQuote)/12 : (Integer.ValueOf(subscriptionTermQuote)/12)+1;
                    for(Integer i=1; i<= totalyears; i++)
                        invoiceNumberWithvalues.add(new invoiceWrapper('Year '+ i, 0,0));  
                }
                
                //Size check of the quotelinesWithName 
                if(quoteLinesWithName.size()>0){
                     
                    //Loop over the quoteLinesWithName and updating the list of the product quantity
                    for( SBQQ__QuoteLine__c qtLine : quoteLinesWithName){
                        Decimal priorQuantity = qtLine.SBQQ__PriorQuantity__c == null ? 0.0 : qtline.SBQQ__PriorQuantity__c;
                        Decimal productQuantity = /*Integer.valueOf(qtLine.SBQQ__Quantity__c - priorQuantity)*/  qtLine.SBQQ__Quantity__c ;
                        if(qtLine.SBQQ__ProductName__c == 'Scanning Services'){                          
                            if(!qtLine.SBQQ__Existing__c && totalYears == quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                yearsInvoiceValue.add(Integer.valueOf(productQuantity > 0 ? productQuantity : 0));
                                yearsInvoiceValue1.add(new ScanningInvoice((productQuantity > 0 ? productQuantity : 0), qtLine.SBQQ__ListPrice__c));
                            }
                            else if(!qtLine.SBQQ__Existing__c && totalYears != quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                yearsInvoiceValue.add(Integer.valueOf(productQuantity > 0 ? productQuantity : 0));
                                 yearsInvoiceValue1.add(new ScanningInvoice((productQuantity > 0 ? productQuantity : 0), qtLine.SBQQ__ListPrice__c));
                            }
                            else if(qtLine.SBQQ__Existing__c && totalYears == quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                yearsInvoiceValue.add(Integer.valueOf(productQuantity > 0 ? productQuantity : 0));
                                 yearsInvoiceValue1.add(new ScanningInvoice((productQuantity > 0 ? productQuantity : 0),qtLine.SBQQ__ListPrice__c));
                            }
                            else if(qtLine.SBQQ__Existing__c && totalYears != quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                yearsInvoiceValue.add(Integer.valueOf(productQuantity > 0 ? productQuantity : 0));
                                yearsInvoiceValue1.add(new ScanningInvoice((productQuantity > 0 ? productQuantity : 0),qtLine.SBQQ__ListPrice__c));
                            }
                        }
                        else if(qtLine.SBQQ__Bundle__c == false && (qtLine.SBQQ__ProductName__c.contains('Pay Core Essentials Tier') || qtLine.SBQQ__ProductName__c.contains('Pay Business Edition Tier')) && !qtLine.SBQQ__ProductName__c.contains('Managed Onboarding-')){
                           
                            //list to hold the  annual range after split operation
                            List<String> annualQuantityRange = qtLine.SBQQ__Product__r.Average_Annual_Invoice_Volume__c.split('-');
                            maxQuantity = 'more';
                            if(annualQuantityRange.size() > 0 ){
                                  
                                minQuantity = annualQuantityRange[0] != null ? annualQuantityRange[0] : '';
                                if(minQuantity.contains('+')){
                                   minQuantity = minQuantity.removeEnd('+');
                                }
                            }
                            if(annualQuantityRange.size() > 1 ){
                                
                                maxQuantity = annualQuantityRange[1] != null ? annualQuantityRange[1] : '';
                            }
                            
                            payProductName = qtLine.SBQQ__ProductName__c;
                            String yearAsKey = 'Year '+ qtLine.SBQQ__SegmentIndex__c;
                            if(qtLine.SBQQ__Discount__c == null && qtLine.SBQQ__AdditionalDiscountAmount__c == null){
                                 isDiscountInPercent = true;
                            }
                            else if(qtLine.SBQQ__Discount__c == null){
                                
                                isDiscountInAmount = true;
                            }
                            else if(qtLine.SBQQ__AdditionalDiscountAmount__c == null){
                                
                                isDiscountInPercent = true;
                            }
                            
                            if(!mapofUpliftWithYear.containsKey(String.valueOf(qtLine.SBQQ__SegmentIndex__c)))
                                mapofUpliftWithYear.put(String.valueOf(qtLine.SBQQ__SegmentIndex__c), 0.0);
                            mapofUpliftWithYear.put(String.valueOf(qtLine.SBQQ__SegmentIndex__c), (qtLine.UpliftPercent__c != null ? qtLine.UpliftPercent__c : 0));
                            
                            
                            if(!qtLine.SBQQ__Existing__c && totalYears == quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                if(!mapOfWrapperForPay.containskey(yearAsKey))
                                    mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo());
                                mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo(qtLine.SBQQ__ProductName__c, Integer.valueOf(qtLine.Invoices__c), qtLine.SBQQ__NetPrice__c, (qtLine.SBQQ__Discount__c != null ? qtLine.SBQQ__Discount__c : qtline.SBQQ__AdditionalDiscountAmount__c) , qtLine.SBQQ__NetTotal__c, qtLine.UpliftPercent__c, qtLine.UpliftAmount__c, qtLine.SBQQ__ListPrice__c, qtLine.SBQQ__NetPrice__c, qtLine.SBQQ__ProrateMultiplier__c));
                                        
                            }
                            else if(!qtLine.SBQQ__Existing__c && totalYears != quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                if(!mapOfWrapperForPay.containskey(yearAsKey))
                                    mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo());
                                mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo(qtLine.SBQQ__ProductName__c, Integer.valueOf(qtLine.Invoices__c), qtLine.SBQQ__NetPrice__c, (qtLine.SBQQ__Discount__c != null ? qtLine.SBQQ__Discount__c : qtline.SBQQ__AdditionalDiscountAmount__c), qtLine.SBQQ__NetTotal__c, qtLine.UpliftPercent__c, qtLine.UpliftAmount__c, qtLine.SBQQ__ListPrice__c, qtLine.SBQQ__NetPrice__c, qtLine.SBQQ__ProrateMultiplier__c));
                            }
                            else if(qtLine.SBQQ__Existing__c && totalYears == quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                                if(!mapOfWrapperForPay.containskey(yearAsKey))
                                    mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo());
                                mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo(qtLine.SBQQ__ProductName__c, Integer.valueOf(qtLine.Invoices__c), qtLine.SBQQ__NetPrice__c, (qtLine.SBQQ__Discount__c != null ? qtLine.SBQQ__Discount__c : qtline.SBQQ__AdditionalDiscountAmount__c), qtLine.SBQQ__NetTotal__c, qtLine.UpliftPercent__c, qtLine.UpliftAmount__c, qtLine.SBQQ__ListPrice__c, qtLine.SBQQ__NetPrice__c, qtLine.SBQQ__ProrateMultiplier__c));
                            }
                             else if(qtLine.SBQQ__Existing__c && totalYears != quoteLinesWithName.size() && qtLine.SBQQ__Bundle__c == false){
                            
                                if(!mapOfWrapperForPay.containskey(yearAsKey))
                                    mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo());
                                mapOfWrapperForPay.put(yearAsKey, new QuoteLineInfo(qtLine.SBQQ__ProductName__c, Integer.valueOf(qtLine.Invoices__c), qtLine.SBQQ__NetPrice__c, (qtLine.SBQQ__Discount__c != null ? qtLine.SBQQ__Discount__c : qtline.SBQQ__AdditionalDiscountAmount__c), qtLine.SBQQ__NetTotal__c, qtLine.UpliftPercent__c, qtLine.UpliftAmount__c, qtLine.SBQQ__ListPrice__c, qtLine.SBQQ__NetPrice__c, qtLine.SBQQ__ProrateMultiplier__c) );
                            }
                        }
                    }
                }

                    //Loop over the quotelie
                for( SBQQ__QuoteLine__c qtline : [Select Id From SBQQ__QuoteLine__c where (SBQQ__ProductName__c LIKE 'Pay%' OR SBQQ__ProductName__c = 'Invoice Compliance') AND SBQQ__Bundle__c = false AND SBQQ__Quote__c =: quoteId.trim()]){
                    quoteLineIds.add(qtline.ID);
                }
                
                if(quoteLineIds.size() > 0){
                    //Add the compliance type name into the map "mapOfCompTypeWithalue"
                    mapOfCompTypeWithalue.put('1. Regular Post-audit',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('2. Post-audit India',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('3. Clearance Italy',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('4. Clearance Turkey',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('5. Clearance Argentina',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('6. Clearance Rest of Latin America',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('7. China GTS',new Map<String, Invoice_Compliance_Details__c>());
                    mapOfCompTypeWithalue.put('8. No compliance partner needed',new Map<String, Invoice_Compliance_Details__c>());
                     
                    //Loop over the Invoice Compliance Details and putting values into map "mapOfCompTypeWithalue"
                    for(Invoice_Compliance_Details__c invoiceComp : [Select Name, Quote_Line__c, Value_in_Amount__c, Value_in_Percent__c, Year__c From Invoice_Compliance_Details__c Where Quote_Line__c IN: quoteLineIds]){
                        
                        if(!mapOfCompTypeWithalue.containsKey(invoiceComp.Name)){
                            mapOfCompTypeWithalue.put(invoiceComp.Name,new Map<String, Invoice_Compliance_Details__c>());
                            if(!mapOfCompTypeWithalue.get(invoiceComp.Name).containsKey(invoiceComp.Year__c))
                                mapOfCompTypeWithalue.get(invoiceComp.Name).put(invoiceComp.Year__c,new Invoice_Compliance_Details__c());
                            mapOfCompTypeWithalue.get(invoiceComp.Name).put(invoiceComp.Year__c,invoiceComp);
                        }
                        else{
                            if(!mapOfCompTypeWithalue.get(invoiceComp.Name).containsKey(invoiceComp.Year__c)){
                                mapOfCompTypeWithalue.get(invoiceComp.Name).put(invoiceComp.Year__c,new Invoice_Compliance_Details__c());
                             mapOfCompTypeWithalue.get(invoiceComp.Name).put(invoiceComp.Year__c,invoiceComp);
                            }
                            else
                                mapOfCompTypeWithalue.get(invoiceComp.Name).put(invoiceComp.Year__c,invoiceComp);
                        }        
                    }
                }
            }
            //Size check of the Map "mapOfCompTypeWithalue"
            if(mapOfCompTypeWithalue.size() > 0){

                //Loop over the map key set
                for(String compTypeName : mapOfCompTypeWithalue.keySet()){ 

                    //List of Wrapper class
                    List<invoiceWrapper> yearWithInvoicevalues = new List<invoiceWrapper>();
                    
                    //Size check over the map values
                    if(mapOfCompTypeWithalue.get(compTypeName).size() > 0){
                        
                        //for(String year : mapOfCompTypeWithalue.get(compTypeName).keyset()){
                            /*for(Integer i=1; i<= totalyears; i++){
                                yearWithInvoicevalues.add(new invoiceWrapper('Year '+i, Integer.valueOf(mapOfCompTypeWithalue.get(compTypeName).get(year).Value_in_Percent__c), mapOfCompTypeWithalue.get(compTypeName).get(year).Value_in_Amount__c));
                            }*/
                            //Loop over the Map 'mapOfCompTypeWithalue'
                            for(Invoice_Compliance_Details__c invoiceCompDetail : mapOfCompTypeWithalue.get(compTypeName).values()){

                                yearWithInvoicevalues.add(new invoiceWrapper('Year '+invoiceCompDetail.Year__c, invoiceCompDetail.Value_in_Percent__c, invoiceCompDetail.Value_in_Amount__c));
                            }
                            if(yearWithInvoicevalues.size() < totalyears){
                                for(Integer i=yearWithInvoicevalues.size()+1; i<= totalyears; i++)
                                    yearWithInvoicevalues.add(new invoiceWrapper('Year '+i, 0, 0));    
                            }
                        //}
                        //Contains key check for the Map 'mapWithCompTypeWithWrapper'
                        if(!mapWithCompTypeWithWrapper.containsKey(compTypeName))
                            mapWithCompTypeWithWrapper.put(compTypeName, new List<invoiceWrapper>());
                        mapWithCompTypeWithWrapper.put(compTypeName, yearWithInvoicevalues) ;   
                    }

                    else{
                        if(!mapWithCompTypeWithWrapper.containsKey(compTypeName)){
                            mapWithCompTypeWithWrapper.put(compTypeName, new List<invoiceWrapper>());
                        }
                        
                        for(Integer i=1; i<= totalyears; i++)
                            yearWithInvoicevalues.add(new invoiceWrapper('Year '+i, 0, 0));
                        mapWithCompTypeWithWrapper.put(compTypeName, yearWithInvoicevalues);
                    }
                }    
            }
            JSONmap = JSON.serialize(mapofUpliftWithYear);
            sizeOfmapOfWrapperForPay = mapOfWrapperForPay.size();
            sizeOfmapOfCompTypeWithalue = mapOfCompTypeWithalue.size();
            CPQ_BaseURL__c CPQbaseURL = [Select URL__c From CPQ_BaseURL__c LIMIT 1];
            //URLProductConfig = 'https://'+CPQbaseURL.URL__c+'/apex/sb?id='+quoteId+'&scontrolCaching=1#/product/pc?lineKey='+lineKey+'&qId='+quoteId+'&ignoreCache=true';
            //System.assert(false, CPQbaseURL.URL__c);
            URLProductConfig = 'https://'+CPQbaseURL.URL__c +'/one/one.app#/alohaRedirect/apex/AdjustProduct?id='+quoteId;
        }
        catch(Exception excpt){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,excpt.getMessage()+'AT :'+ excpt.getLineNumber()));
            //System.assert(false, excpt.getMessage()+''+excpt.getLineNumber());
        }
    }

    /**
    * Description   :   This method to redriect to the previous pageand save the record
    *
    * Arguments     :   null
    *
    * Return        :   PageReference
    *
    * Version       :   V1.0 Created
    *             
    **/
    public PageReference saveInvoiceCompliance(){
       //System.assert(false, yearsInvoiceValue1); 
        System.debug('For pay details@@mapOfWrapperForPay' + mapOfWrapperForPay);
        System.debug('For Scanning services@@yearsInvoiceValue1'+yearsInvoiceValue1 );
        System.debug('For Invoice compliance@@mapWithCompTypeWithWrapper'+ mapWithCompTypeWithWrapper);
        
        //if(Decimal.valueOf(avgPayDiscount) > 0.0)
            //Assign the Value to the quote field
            quote[0].Avg_Additional_Discount_for_Pay__c = Decimal.valueOf(avgPayDiscount);
            quote[0].Difference_Amount__c = Decimal.valueOf(avgUpliftDisount);
            
            
        //List of the invoice compliance 
        List<Invoice_Compliance_Details__c> invoiceCompliances = new List<Invoice_Compliance_Details__c>();

        //List of the invoice compliance to update
        List<Invoice_Compliance_Details__c> invoiceCompliancesUpdate = new List<Invoice_Compliance_Details__c>();

        //List to update the quote line
        List<SBQQ__QuoteLine__c> qteLines = new List<SBQQ__QuoteLine__c>();

        //Map to hold the all invoice compliances with quote line as key
        Map<String, Map<String, Invoice_Compliance_Details__c>> mapOfQuoteLineWithInvoiceCompliance = new Map<String, Map<String, Invoice_Compliance_Details__c>>();

        //Map to hold the compliance type and tiering details 
        Map<String, List<Partner_Tier_Pricing_details__c>> mapOfCompTypeUSDWithPartnerTire = new Map<String, List<Partner_Tier_Pricing_details__c>>();
        
        //Map to hold the compliance type with the final amount
        Map<String, Map<String, Decimal>> mapOfCompTypeWithYearWithAmt = new Map<String, Map<String, Decimal>>();

        //Map to hold the compliance type with the final invoice volume
        Map<String, Map<String, Decimal>> mapOfCompTypeWithYearWithInvoiceVolume = new Map<String, Map<String, Decimal>>();

        //Loop over the Invoice compliance details
        for(Invoice_Compliance_Details__c invoiceComp : [Select Id, Name, Quote_Line__c, Value_in_Amount__c, Value_in_Percent__c, Year__c From Invoice_Compliance_Details__c Where Quote_Line__c IN: quoteLineIds]){

            if(!mapOfQuoteLineWithInvoiceCompliance.containsKey(invoiceComp.Quote_Line__c)){
                mapOfQuoteLineWithInvoiceCompliance.put(invoiceComp.Quote_Line__c, new Map<String, Invoice_Compliance_Details__c>());
                if(!mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).containskey(invoiceComp.Name))
                    mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).put(invoiceComp.Name,new Invoice_Compliance_Details__c());
                mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).put(invoiceComp.Name, invoiceComp);
                
            }
            else{
                if(!mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).containsKey(invoiceComp.Name)){
                    mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).put(invoiceComp.Name, invoiceComp);
                }
                else
                    mapOfQuoteLineWithInvoiceCompliance.get(invoiceComp.Quote_Line__c).put(invoiceComp.Name, invoiceComp);
            }
        }

        //Loop over the Compliance partner rate details
        for(Compliance_Partner_Rate_Details__c compPartnerRate : [Select Name, USD_invoice__c, Min_Yearly_fee_USD__c, (Select Name, Invoice_Range_From_per_year__c, Invoice_Range_To_per_year__c, Outbound_Transaction_USD_per_trans__c From Partner_Tier_Pricing_details__r)  From Compliance_Partner_Rate_Details__c]){
            
            //Unique key
            String uniqueKey = compPartnerRate.Name +'&&'+ compPartnerRate.USD_invoice__c +'&&'+ compPartnerRate.Min_Yearly_fee_USD__c;
            
            //Contains check for the Map key "mapOfCompTypeUSDWithPartnerTire"
            if(!mapOfCompTypeUSDWithPartnerTire.containsKey(uniqueKey))
                mapOfCompTypeUSDWithPartnerTire.put(uniqueKey, new List<Partner_Tier_Pricing_details__c>());

            if(compPartnerRate.Partner_Tier_Pricing_details__r.size() > 0){
                for(Partner_Tier_Pricing_details__c partnerTier : compPartnerRate.Partner_Tier_Pricing_details__r)
                    mapOfCompTypeUSDWithPartnerTire.get(uniqueKey).add(partnerTier);
            }
        }

        //Loop over the Map "mapWithCompTypeWithWrapper" key set
        for(String compType : mapWithCompTypeWithWrapper.keyset()){

            //Loop over the map values
            for(InvoiceWrapper invoiceWr : mapWithCompTypeWithWrapper.get(compType)){
                Decimal USDAmt = 0.0;
                Decimal volOfInvoice = invoiceWr.yearlyInvoiceAmt;
                //Check for the invoice amount greater than 0
                if(invoiceWr.yearlyInvoiceAmt > 0){
                     
                    //Loop over the Map
                    for(String uniqueKey : mapOfCompTypeUSDWithPartnerTire.keySet()){
                        
                        //Contains Check
                        if(uniqueKey.contains(compType.replaceAll('[1-7]. ', ''))){
                            
                            //To the split value of the unique key
                            List<String> compTypeWithUsd = uniqueKey.split('&&');
                            Decimal finalUSDAmt = Decimal.valueOf(compTypeWithUsd[1]) * invoiceWr.yearlyInvoiceAmt;
                            
                            //Map size check
                            if(mapOfCompTypeUSDWithPartnerTire.get(uniqueKey).size()>0){
                                
                                //Loop over the  Mao values
                                for(Partner_Tier_Pricing_details__c partnerTierRate: mapOfCompTypeUSDWithPartnerTire.get(uniqueKey)){
                                    if(partnerTierRate.Invoice_Range_From_per_year__c <= invoiceWr.yearlyInvoiceAmt && invoiceWr.yearlyInvoiceAmt > partnerTierRate.Invoice_Range_To_per_year__c){
                                        finalUSDAmt = invoiceWr.yearlyInvoiceAmt * partnerTierRate.Outbound_Transaction_USD_per_trans__c;
                                    }
                                }
                            }
                            USDAmt = finalUSDAmt == 0 ? 0.0 : finalUSDAmt;

                            //Null check
                            if(compTypeWithUsd != null && compTypeWithUsd[2] != 'null' && compTypeWithUsd[2] != ''){
                                USDAmt = Decimal.valueOf(compTypeWithUsd[2]) > finalUSDAmt ? Decimal.valueOf(compTypeWithUsd[2]) : finalUSDAmt;  
                            }
                            USDAmt = finalUSDAmt == 0 ? 0.0 : USDAmt;
                        }
                    }
                }

                //Adding value to Map "mapOfCompTypeWithYearWithAmt" 
                if(!mapOfCompTypeWithYearWithAmt.containskey(compType)){
                    mapOfCompTypeWithYearWithAmt.put(compType, new Map<String, Decimal>());
                    if(!mapOfCompTypeWithYearWithAmt.get(compType).containsKey(invoiceWr.year)){
                        mapOfCompTypeWithYearWithAmt.get(compType).put(invoiceWr.year,USDAmt);
                    }
                }
                else{
                    if(!mapOfCompTypeWithYearWithAmt.get(compType).containsKey(invoiceWr.year)){
                        mapOfCompTypeWithYearWithAmt.get(compType).put(invoiceWr.year,USDAmt);
                    }
                    else{
                        mapOfCompTypeWithYearWithAmt.get(compType).put(invoiceWr.year,USDAmt+mapOfCompTypeWithYearWithAmt.get(compType).get(invoiceWr.year));
                    }
                }
                 //Adding value to Map "mapOfCompTypeWithYearWithInvoiceVolume" 
                if(!mapOfCompTypeWithYearWithInvoiceVolume.containskey(compType)){
                    mapOfCompTypeWithYearWithInvoiceVolume.put(compType, new Map<String, Decimal>());
                    if(!mapOfCompTypeWithYearWithInvoiceVolume.get(compType).containsKey(invoiceWr.year)){
                        mapOfCompTypeWithYearWithInvoiceVolume.get(compType).put(invoiceWr.year, volOfInvoice);
                    }
                }
                else{
                    if(!mapOfCompTypeWithYearWithInvoiceVolume.get(compType).containsKey(invoiceWr.year)){
                        mapOfCompTypeWithYearWithInvoiceVolume.get(compType).put(invoiceWr.year, volOfInvoice);
                    }
                    else{
                        mapOfCompTypeWithYearWithInvoiceVolume.get(compType).put(invoiceWr.year, volOfInvoice + mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(invoiceWr.year));
                    }
                }
            }
        }

        //Loop over the quote line
        for(SBQQ__QuoteLine__c qteLine :[Select Id, Name, SBQQ__Product__r.Category__c,SBQQ__Product__r.Name , SBQQ__Product__r.Item__c, SBQQ__Discount__c, SBQQ__StartDate__c,
                                            SBQQ__EndDate__c, SBQQ__NetTotal__c, SBQQ__ListTotal__c, SBQQ__Quote__r.SBQQ__SubscriptionTerm__c, SBQQ__Quote__r.SBQQ__StartDate__c,
                                            SBQQ__Quote__r.CreatedDate, Regular_Post_audit__c, Post_audit_India__c, Clearance_Italy__c, Clearance_Turkey__c, Clearance_Argentina__c,
                                            Clearance_Rest_of_Latin_America__c, China_GTS__c,SBQQ__SegmentIndex__c, SBQQ__Uplift__c, SBQQ__UpliftAmount__c
                                            From SBQQ__QuoteLine__c
                                            Where SBQQ__Quote__c =: quoteId AND SBQQ__StartDate__c != null AND SBQQ__Bundle__c = false
                                            Order By SBQQ__StartDate__c]){
           //Integer totalYearTerm = Math.mod(Integer.ValueOf(qteLine.SBQQ__Quote__r.SBQQ__SubscriptionTerm__c), 12) == 0 ? Integer.valueOf(qteLine.SBQQ__Quote__r.SBQQ__SubscriptionTerm__c/12) : Integer.valueOf(qteLine.SBQQ__Quote__r.SBQQ__SubscriptionTerm__c/12+1) ;
            String yearAsKey = 'Year '+ qteLine.SBQQ__SegmentIndex__c;
            SBQQ__QuoteLine__c quteLine = new SBQQ__QuoteLine__c();
            if(qteLine.SBQQ__Product__r.Name == 'Invoice Compliance' || qteLine.SBQQ__Product__r.Name.contains('Pay Core Essentials Tier') || qteLine.SBQQ__Product__r.Name.contains('Pay Business Edition Tier') && !qteLine.SBQQ__Product__r.Name.contains('Managed Onboarding-')){
                for(String compType : mapWithCompTypeWithWrapper.keySet()){
                    for(InvoiceWrapper invoice :mapWithCompTypeWithWrapper.get(compType)){
                        if(yearAsKey == invoice.year){
                            invoiceCompliances.add(new Invoice_Compliance_Details__c(Name = compType, Year__c = String.valueOf(qteLine.SBQQ__SegmentIndex__c), Quote_Line__c = qteLine.Id, Value_in_Amount__c = invoice.yearlyInvoiceAmt, Value_in_Percent__c = invoice.yearlyInvoicePercnt));
                            break;
                        }
                    }
                }
                
                quteLine.Id = qteLine.Id;
                if((qteLine.SBQQ__Product__r.Name.contains('Pay Core Essentials Tier') || qteLine.SBQQ__Product__r.Name.contains('Pay Business Edition Tier') )&& !qteLine.SBQQ__Product__r.Name.contains('Managed Onboarding-')){
                    
                    quteLine.Invoices__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).invoice != null ? mapOfWrapperForPay.get(yearAsKey).invoice : 0 ) : 0;
                   //quteLine.SBQQ__ListPrice__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).listPrice != null ? mapOfWrapperForPay.get(yearAsKey).listPrice : 0 ) : 0;
                    if(discountIdentify == '%'){
                        quteLine.SBQQ__Discount__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).addDiscount != null ? mapOfWrapperForPay.get(yearAsKey).addDiscount : 0 ) : 0; 
                        quteLine.SBQQ__AdditionalDiscountAmount__c = nullConst;
                    }else if(discountIdentify == 'amt'){
                        quteLine.SBQQ__Discount__c = nullConst;
                        quteLine.SBQQ__AdditionalDiscountAmount__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).addDiscount != null ? mapOfWrapperForPay.get(yearAsKey).addDiscount : 0 ) : 0;                      
                    }
                    //System.assert(false, upliftIdentify);
                    if(upliftIdentify == 'amt'){
                        Decimal listPriceAmt = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).listPrice != null ? mapOfWrapperForPay.get(yearAsKey).basePrice : 0 ) : 0;
                        Decimal uplitAmt = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).upliftAmount != null ? mapOfWrapperForPay.get(yearAsKey).upliftAmount : 0 ) : 0;
                        Decimal prorate = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).upliftAmount != null ? mapOfWrapperForPay.get(yearAsKey).proratedMultiplier : 0 ) : 0;
                        quteLine.UpliftPercent__c = (uplitAmt * 100) / (listPriceAmt * prorate);
                        quteLine.UpliftAmount__c = uplitAmt;
                        
                    }
                    else if(upliftIdentify == '%'){
                        quteLine.UpliftPercent__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).uplift != null ? mapOfWrapperForPay.get(yearAsKey).uplift : 0 ) : 0;
                        quteLine.UpliftAmount__c = mapOfWrapperForPay.containsKey(yearAsKey) ? (mapOfWrapperForPay.get(yearAsKey).upliftAmount != null ? mapOfWrapperForPay.get(yearAsKey).upliftAmount : 0 ) : 0;
                   
                    }
                }
                for(String compType : mapOfCompTypeWithYearWithAmt.keyset()){
                    if(compType.contains('Regular Post-audit')){
                        quteLine.Regular_Post_audit__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_Regular_Post_audit__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('Post-audit India')){
                        quteLine.Post_audit_India__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_Post_audit_India__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('Clearance Italy')){
                        quteLine.Clearance_Italy__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_Clearance_Italy__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('Clearance Turkey')){
                        quteLine.Clearance_Turkey__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_Clearance_Turkey__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('Clearance Argentina')){
                        quteLine.Clearance_Argentina__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_Clearance_Argentina__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('Clearance Rest of Latin America')){
                        quteLine.Clearance_Rest_of_Latin_America__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Vol_of_Clearance_Rest_of_Latin_America__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);
                    }
                    if(compType.contains('China GTS')){
                        quteLine.China_GTS__c =  Math.round(mapOfCompTypeWithYearWithAmt.get(compType).get(yearAsKey));
                        quteLine.Volume_of_China_GTS__c = mapOfCompTypeWithYearWithInvoiceVolume.get(compType).get(yearAsKey);

                    }
                }
            }
            else if(qteLine.SBQQ__Product__r.Name == 'Scanning Services'){ 
                if(yearsInvoiceValue1.size() > 0){
                    quteLine.Id = qteLine.Id;
                    quteLine.SBQQ__Quantity__c = yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].invoiceQuantity != null ? yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].invoiceQuantity : 0; 
                    quteLine.Invoices__c =  yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].invoiceQuantity != null ? yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].invoiceQuantity : 0;
                    quteLine.SBQQ__ListPrice__c =  yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].customerCost != null ? yearsInvoiceValue1[Integer.valueOf(qteLine.SBQQ__SegmentIndex__c)-1].customerCost : 0;
                }
            }
            if(quteLine.Id != null)
                qteLines.add(quteLine); 
        } 
       /* for(Invoice_Compliance_Details__c invoiceDetails : [Select Name,Quote_Line__c,Value_in_Amount__c,Value_in_Percent__c,Year__c From Invoice_Compliance_Details__c Where Quote_Line__c =:quoteLineIds]){
            for(Invoice_Compliance_Details__c invoiceDetailList : invoiceCompliances){
                if(invoiceDetails.Name == invoiceDetailList.Name && invoiceDetails.Year__c == invoiceDetailList.Year__c){
                    invoiceCompliancesUpdate.add(new Invoice_Compliance_Details__c(Id = invoiceDetails.ID, Name = invoiceDetailList.Name, Year__c = invoiceDetailList.year__c, Quote_Line__c = invoiceDetailList.Quote_Line__c, Value_in_Amount__c = invoiceDetailList.Value_in_Amount__c, Value_in_Percent__c = invoiceDetailList.Value_in_Percent__c));
                    break;
                }
            }    
        }*/ 
        for(Invoice_Compliance_Details__c invoiceDetailList : invoiceCompliances){
            
            if(mapOfQuoteLineWithInvoiceCompliance.containsKey(invoiceDetailList.Quote_Line__c)){
                if(mapOfQuoteLineWithInvoiceCompliance.get(invoiceDetailList.Quote_Line__c).containskey(invoiceDetailList.Name)){
                    invoiceCompliancesUpdate.add(new Invoice_Compliance_Details__c(Id = mapOfQuoteLineWithInvoiceCompliance.get(invoiceDetailList.Quote_Line__c).get(invoiceDetailList.Name).ID, Value_in_Amount__c = invoiceDetailList.Value_in_Amount__c, Value_in_Percent__c = invoiceDetailList.Value_in_Percent__c ));
                }
            }
            else{
              invoiceCompliancesUpdate.add(new Invoice_Compliance_Details__c(Name = invoiceDetailList.Name, Value_in_Amount__c = invoiceDetailList.Value_in_Amount__c, Value_in_Percent__c = invoiceDetailList.Value_in_Percent__c, Quote_Line__c = invoiceDetailList.Quote_Line__c, Year__c = invoiceDetailList.Year__c  ));  
            } 

        }

        try{
            //Update Quote Line
            if(qteLines.size() > 0){
                System.debug('qteLines@@@'+qteLines);
                update qteLines;
            }

           //Upsert Invoice compliance
            if(invoiceCompliancesUpdate.size() > 0){
                System.debug('@@UpdateInvoiceCompliance'+invoiceCompliancesUpdate);
               upsert invoiceCompliancesUpdate;
            }
            
            //Update quote for avg discount of pay
            if(quote.size() > 0){
                System.debug('avgPayDiscount@@quote'+quote);
                update quote;
            }
        }
        catch(Exception excpt){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,excpt.getMessage() +''+excpt.getLineNumber()));
            System.assert(false,excpt.getMessage()+'--'+excpt.getLineNumber());

        }

       InvoiceRampingController invoiceController = new InvoiceRampingController(quoteId);
        PageReference pR = invoiceController.saveInvoiceRamp();
        
        //String for base URL
        String baseUrlList = System.URL.getSalesforceBaseUrl().getHost();
        if(baseUrlList.contains('--c.')){
            String str = baseUrlList.substring(0,baseUrlList.indexOf('--c.'));
            String str2 = baseUrlList.substring(baseUrlList.indexOf('--c.'), baseUrlList.length()).replace('--c','');
            
            //FinalUrl with extra parameter
            String finalUrl = 'https://'+Str+'--sbqq'+str2+'/apex/sb?scontrolCaching=1&id='+quoteId.trim();
            
            //PageRefernce variable
            pR =  new PageReference(finalUrl);
        }
        
        pR.setRedirect(true);
        
        //Return
        return pR;
    }

    //Wrapper Class
    public class InvoiceWrapper {

        //To hold the year 
        public String year {get; set;}

        //To hold the percentage
        public Integer yearlyInvoicePercnt {get; set;}

        //To hold the amount value
        public Decimal yearlyInvoiceAmt {get; set;}
 
        //Parameterized contructor  
        public InvoiceWrapper(String year, Decimal yearlyInvoice, Decimal yearlyInvoiceAmt) {
            //this.invoiceComplianceId = invoiceCompID;
            this.year = year;
            this.yearlyInvoicePercnt = Integer.valueOf(yearlyInvoice);
            this.yearlyInvoiceAmt = yearlyInvoiceAmt;
        }
    }
    
    //Wrapper to hold the details of the quote line
    public class QuoteLineInfo{
        
        //To hold the quantity
        public Integer invoice{get; set;}
        
        //To hold the list price
        public Integer listPrice{get; set;} 
        
        public Integer netUnitPrice {get; set;}
        
        // To hold the additional discount
        public Integer addDiscount{get; set;}
        
        //To hold the net total
        public Integer netTotal{get; set;}
        
        //to hold the product name
        public String productName{get; set;}
        
        //To the uplift in percent
        public Decimal uplift{get; set;}
        
        //To hold the uplit in amount
        public Decimal upliftAmount{get; set;}
        
        //To hold the base price
        public Decimal basePrice{get; set;}
        
        //To hold the base price
        public Decimal proratedMultiplier{get; set;}
        
        //Parameterized Constructor
        public QuoteLineInfo(String prodName, Integer invoice, Decimal listPrice, Decimal addDiscount, Decimal netTotal, Decimal uplift, Decimal upliftAmount, Decimal basePrice, Decimal netUnitPrice, Decimal proratedMultiplier){
            
            this.productName = prodName;
            this.invoice = invoice != null ? invoice : 0 ;
            this.listPrice = listPrice!=null ? Integer.valueOf(Math.abs(listPrice)) : 0;
            this.addDiscount = addDiscount != null ? Integer.valueOf(Math.abs(addDiscount)) : 0;
            this.netTotal = netTotal!= null ? Integer.valueOf(Math.abs(netTotal)) : 0;
            this.uplift = uplift != null ? uplift : 0;
            this.upliftAmount = upliftAmount != null ? Integer.valueOf(Math.abs(upliftAmount)) : 0; 
            this.basePrice = basePrice != null ? Integer.valueOf(Math.abs(basePrice)) : 0; 
            this.netUnitPrice = netUnitPrice != null ? Integer.valueOf(Math.abs(netUnitPrice)) : 0;   
            this.proratedMultiplier = proratedMultiplier != null ? proratedMultiplier : 0;  
        }
        public QuoteLineInfo(){
            
        }
    } 
    
    //Wrapper to hold the invoice foe th Scanninf servies product
    public class ScanningInvoice{
        
        //To hold the quantity'
        public Decimal invoiceQuantity{get; set;}
        
        //To hold the cost to customer
        public Decimal customerCost{get; set;}
        
        //Constructor
        public ScanningInvoice(Decimal invoiceQuantity, Decimal customerCost){
            
            this.invoiceQuantity = invoiceQuantity;
            this.customerCost = customerCost;
        }
    }
}