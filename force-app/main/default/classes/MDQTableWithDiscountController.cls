public class MDQTableWithDiscountController {
    
    //For subscription product
    public Map<String,Map<Boolean ,Map<String,Decimal>>> mapOfItemNameWithOptionalWithYearwithTotalSummaryModel{get; set;}

    //For GainShare productc
    public Map<String,Map<Boolean ,Map<String,Decimal>>> mapOfItemNameWithGainshareWithYearwithTotalSummaryModel{get; set;}
  
  //For non subscription term and one time implementation fees for wrapper
  public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfItemNameWithOptionalWithOneTimeFeesWrapper{get; set;}
  
    public Map<String, Map<String, Decimal>> mapOfForcastedItemWithYearwithTotal{get; set;}

    public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfForcastedItemWithWrapper{get; set;}

    public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfItemNameWithListOfWrapperForSummaryMod{get; set;}

    //for Gainshare product
    public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfGainshareItemNameWithListOfWrapperForSummaryMod{get; set;}

    //To hold the quantity of the pay product
    public List<AnnualQuantity> annualQuantityOfPay{get;  set;}

    public Map<String,Decimal> mapOfYearWithTotalOfYear{get; set;}

    public Decimal totalOfAllYear{get; set;}

    //To hold the total quantity for the Pay product
    public Integer totalAnnualInvoiceRamp{get; set;}

    //To hold the size of this mapOfItemNameWithListOfWrapperForSummaryMod
    public Integer sizeOfmapOfItemNameWithListOfWrapperForSummaryMod{get; set;}

    //To hold the size of the mapOfYearWithTotalOfYear
    public Integer sizeOfmapOfYearWithTotalOfYear{get; set;}

    //To hold the size of the mapOfForcastedItemWithWrapper
    public Integer sizeOfmapOfForcastedItemWithWrapper{get; set;}

    //Map to hold the scanning services product
    public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfScanningServicesWithWrapper{get; set;}
    
    //Map to hold the App Partner Product
    public Map<String, List<QuoteLineWrapperForSummaryModel>> mapOfAppPartnerWithWrapper{get; set;}

    //To hold teh size of the mapOfScanningServicesWithWrapper
    public Integer sizeOfmapOfScanningServicesWithWrapper{get; set;}

    //to hold the quantity of the scanning services 
    public List<AnnualQuantity> annualQuantityOfScanningSevices{get;  set;}

    //To hold the total quantity for the Scanning Services
    public Integer totalQuantityOfScanningServices{get; set;}

    //To hold the partner of the scanning services
    public String scanningPartner{get; set;}
    
    //To hold the size of the map "mapOfAppPartnerWithWrapper"
    public Integer sizeOfmapOfAppPartnerWithWrapper{get; set;}
    
    //To hold the total amount per year
    public Map<String,Decimal> mapOfYearWithDiscount{get; set;}
    
     //To hold the total discount of all years for pay product
    public Decimal totalNonForcastedDiscount{get; set;}
    
    //To hold the size of this mapOfYearWithDiscount
    public Integer sizeOfmapOfYearWithDiscount{get; set;}
    
    //to hold the Currency ISO code
    public String currencySymbol{get; set;}
    
    //Map to hold the Product with its code
    public Map<String, String> mapProductNameWithCode{get; set;}
    
    //To hold the Size of the map "sizeOfMapProductNameWithCode"
    public Integer sizeOfMapProductNameWithCode{get; set;}

  //String to hold the invoice compliance
  public static String compliancePartner{get; set;}
  
  //To hold the Currency ISO code
  public String currenyISO{get; set;}
  
  //String to hold the invoice compliance
  public static String invoiceComplianceRegion{get; set;}
    
    //Boolean for the Invoice Compliance
    public Boolean isInvoiceCompliance{get; set;}
    
    //Boolean for the Scanning Services
    public Boolean isScanningServices{get; set;}
    
    //Map to hold the (NetTotal - ListTotal) with its year
    public Map<String, List<Decimal>> mapOfSegmentedYearWithDifference;
    
    //Map to hold the NetTotal with its year
    public Map<String, Decimal> mapOfSegmentedYearWithNetTotal;
    
    //To hold the size of map "mapOfItemNameWithOptionalWithOneTimeFeesWrapper"
  public Integer sizeMapOfItemNameWithOptionalWithOneTimeFeesWrapper{get; set;}

    //To hold the size of the map "mapOfGainshareItemNameWithListOfWrapperForSummaryMod"
    public Integer sizeOfmapOfGainshareItemNameWithListOfWrapperForSummaryMod{get; set;}
  
    public MDQTableWithDiscountController(){
    
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        mapOfItemNameWithOptionalWithYearwithTotalSummaryModel = new Map<String,Map<Boolean, Map<String,Decimal>>>();
        mapOfItemNameWithOptionalWithOneTimeFeesWrapper = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        mapOfItemNameWithListOfWrapperForSummaryMod = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        mapOfGainshareItemNameWithListOfWrapperForSummaryMod = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        mapOfForcastedItemWithYearwithTotal = new Map<String, Map<String, Decimal>>();
        mapOfForcastedItemWithWrapper = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        mapOfScanningServicesWithWrapper = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        mapOfAppPartnerWithWrapper = new Map<String, List<QuoteLineWrapperForSummaryModel>>();
        annualQuantityOfPay = new List<AnnualQuantity>();
        mapOfYearWithTotalOfYear = new Map<String,Decimal>();
        annualQuantityOfScanningSevices = new List<AnnualQuantity>();
        totalOfAllYear = 0.0;
        totalAnnualInvoiceRamp = 0;
        totalQuantityOfScanningServices = 0;
        scanningPartner = '';
        mapOfYearWithDiscount = new Map<String,Decimal>();
        totalNonForcastedDiscount = 0.0;
        sizeOfmapOfYearWithDiscount = 0;
        currencySymbol = Constants.getCurrencySymbolFromIso(UserInfo.getDefaultCurrency());
        mapProductNameWithCode = new Map<String, String>();
        sizeOfMapProductNameWithCode = 0;
        compliancePartner = '';
        invoiceComplianceRegion = '';
        isInvoiceCompliance = false;
        isScanningServices = false;
        mapOfSegmentedYearWithDifference = new Map<String, List<Decimal>>();
        mapOfSegmentedYearWithNetTotal = new Map<String, Decimal>();
        sizeMapOfItemNameWithOptionalWithOneTimeFeesWrapper = 0;
        mapOfItemNameWithGainshareWithYearwithTotalSummaryModel = new Map<String,Map<Boolean ,Map<String,Decimal>>>();
        sizeOfmapOfGainshareItemNameWithListOfWrapperForSummaryMod = 0;

        
        try{
          if(quoteId != null){
            getInvoiceComplianceDetail(quoteId);
            currenyISO = [Select CurrencyIsoCode From SBQQ__Quote__c Where ID =: quoteId LIMIT 1].CurrencyIsoCode;
            currencySymbol = Constants.getCurrencySymbolFromIso(currenyISO);
          }
            /*Modified By Akshay Bagrecha - 10/14/2019 - Add the effective quantity condition in the query for the amendment case */
            for(SBQQ__QuoteLine__c qteLine :[Select Id, Name, SBQQ__Product__r.Name, SBQQ__Product__r.Category__c, SBQQ__Product__r.Item__c, SBQQ__Discount__c,SBQQ__TotalDiscountRate__c, SBQQ__StartDate__c,
                                            SBQQ__EndDate__c, SBQQ__NetTotal__c, SBQQ__ListTotal__c, SBQQ__Quote__r.SBQQ__SubscriptionTerm__c, SBQQ__Quote__r.SBQQ__StartDate__c, Invoices__c,
                                            SBQQ__Quote__r.CreatedDate, SBQQ__Product__r.Is_Forecasted__c, SBQQ__SegmentIndex__c, SBQQ__Product__r.ProductCode, SBQQ__Product__r.SBQQ__Optional__c,SBQQ__Quantity__c, 
                                            SBQQ__ProductName__c, SBQQ__Quote__r.Scanning_Partner__c, SBQQ__Product__r.SBQQ__SortOrder__c, SBQQ__Product__r.Name_for_document__c, SBQQ__Quote__r.Subscription_Term_Months__c,
                                            SBQQ__Product__r.Is_Gainshare__c
                                            From SBQQ__QuoteLine__c
                                            Where SBQQ__Quote__c =: quoteId  AND SBQQ__Bundle__c = false AND SBQQ__EffectiveQuantity__c >=1
                                            Order By SBQQ__StartDate__c]){
                scanningPartner = qteLine.SBQQ__Quote__r.Scanning_Partner__c;
                String yearKey = 'Year '+( qteLine.SBQQ__SegmentIndex__c != null ? qteLine.SBQQ__SegmentIndex__c : 1);
                if(qteLine.SBQQ__Product__r.Is_Forecasted__c == false && qteLine.SBQQ__Product__r.Is_Gainshare__c == false){
                   
                    if(!mapOfYearWithTotalOfYear.containsKey(yearKey))
                        mapOfYearWithTotalOfYear.put(yearKey,0.0);
                    Decimal totalPerYer = qteLine.SBQQ__NetTotal__c + mapOfYearWithTotalOfYear.get(yearKey);
                    mapOfYearWithTotalOfYear.put(yearKey,Math.round(totalPerYer));
                }
                if(!qteLine.SBQQ__Product__r.Is_Forecasted__c && qteLine.SBQQ__Product__r.Name != Constants.PROFESSIONAL_SERVICES_ADVISOR_MILESTONE && qteLine.SBQQ__Product__r.Name != Constants.PROFESSIONAL_SERVICES_STANDARD_MILESTONE){
                  /*if(!mapOfYearWithDiscount.containsKey(yearKey))
                        mapOfYearWithDiscount.put(yearKey, 0);
                    Decimal totalDiscount = ((qteLine.SBQQ__TotalDiscountRate__c == null ? 0 : qteLine.SBQQ__TotalDiscountRate__c) + mapOfYearWithDiscount.get(yearKey))/2;
                    mapOfYearWithDiscount.put(yearKey, totalDiscount); */
                    if(!mapOfSegmentedYearWithDifference.containsKey(yearKey))
                     mapOfSegmentedYearWithDifference.put(yearKey, new List<Decimal>());
                   mapOfSegmentedYearWithDifference.get(yearKey).add(qteLine.SBQQ__ListTotal__c - qteLine.SBQQ__NetTotal__c);
                       
                  if(!mapOfSegmentedYearWithNetTotal.containsKey(yearKey))
                    mapOfSegmentedYearWithNetTotal.put(yearKey, 0);
                  mapOfSegmentedYearWithNetTotal.put(yearKey, mapOfSegmentedYearWithNetTotal.get(yearKey)+qteLine.SBQQ__ListTotal__c);  
                    
                }
                String yearAsKey = 'Year '+( qteLine.SBQQ__SegmentIndex__c != null ? qteLine.SBQQ__SegmentIndex__c : 1);
            String productItemNameOneTime = qteLine.SBQQ__Product__r.SBQQ__SortOrder__c+'. '+qteLine.SBQQ__Product__r.Name_for_document__c+ '&&&'+ qteLine.SBQQ__Product__r.ProductCode;
               Integer yearTerm = qteLine.SBQQ__Quote__r.Subscription_Term_Months__c != null ? Integer.valueOf(Math.Ceil(qteLine.SBQQ__Quote__r.Subscription_Term_Months__c/12)) : 1;
               if(qteLine.SBQQ__Product__r.Name == 'Professional Services - Advisor Milestone' || qteLine.SBQQ__Product__r.Name == 'Professional Services - Standard Milestone'){
                 for(Integer i =1; i<=yearTerm;i++){
                   if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.containsKey(productItemNameOneTime)){
                        mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.put(productItemNameOneTime, new Map<Boolean,Map<String,Decimal>>());
                        if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).containsKey(qteLine.SBQQ__Product__r.Is_Forecasted__c)){
                            mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).put(qteLine.SBQQ__Product__r.Is_Forecasted__c,new Map<String,Decimal>());
                            if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey('Year '+i))
                                  mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put('Year '+i,Math.round(qteLine.SBQQ__NetTotal__c));
                        }
                    }
                    else{
                        if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).containsKey(qteLine.SBQQ__Product__r.Is_Forecasted__c)){
                            mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).put(qteLine.SBQQ__Product__r.Is_Forecasted__c,new Map<String,Decimal>());
                            if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey('Year '+i))
                                mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put('Year '+i,Math.round(0));
    
                        }
                        else{
                            if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey('Year '+i)){
                                mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put('Year '+i,Math.round(0));
                            }
                            else{
                                Decimal totalAmt = mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).get('Year '+i) + qteLine.SBQQ__NetTotal__c;
                                mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemNameOneTime).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put('Year '+i,Math.round(0));
                            }   
                        }
                    }
                 }
               }
               
        if(qteLine.SBQQ__Product__r.Name == Constants.INVOICE_COMPLIANCE_NAME)
                    isInvoiceCompliance = true;
                if(qteLine.SBQQ__Product__r.Name == Constants.SCANNING_SERVICES_NAME)
                    isScanningServices = true;
                
                String productItemName = qteLine.SBQQ__Product__r.SBQQ__SortOrder__c+'. '+qteLine.SBQQ__Product__r.Name_for_document__c+ '&&&'+ qteLine.SBQQ__Product__r.ProductCode;
                 if(productItemName.contains('<')){
                  productItemName = productItemName.replace('<', '&lt;'); 
                }
                if(productItemName.contains('-')){
                  //productItemName = productItemName.replace('-', '&#8209;');
                }
                if(!qteLine.SBQQ__Product__r.Is_Gainshare__c && (qteLine.SBQQ__Product__r.Name != 'Professional Services - Advisor Milestone' && qteLine.SBQQ__Product__r.Name != 'Professional Services - Standard Milestone' )){
                  if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.containsKey(productItemName)){
                      mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.put(productItemName, new Map<Boolean,Map<String,Decimal>>());
                      if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).containsKey(qteLine.SBQQ__Product__r.Is_Forecasted__c)){
                          mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).put(qteLine.SBQQ__Product__r.Is_Forecasted__c,new Map<String,Decimal>());
                          if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey(yearAsKey))
                              mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
                      }
                  }
                  else{
                      if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).containsKey(qteLine.SBQQ__Product__r.Is_Forecasted__c)){
                          mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).put(qteLine.SBQQ__Product__r.Is_Forecasted__c,new Map<String,Decimal>());
                          if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey(yearAsKey))
                              mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
  
                      }
                      else{
                          if(!mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).containsKey(yearAsKey)){
                              mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
                          }
                          else{
                              Decimal totalAmt = mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).get(yearAsKey) + qteLine.SBQQ__NetTotal__c;
                              mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Forecasted__c).put(yearAsKey,Math.round(totalAmt));
                          }   
                      }
                  }
                }
                else if(qteLine.SBQQ__Product__r.Is_Gainshare__c && (qteLine.SBQQ__Product__r.Name != 'Professional Services - Advisor Milestone' && qteLine.SBQQ__Product__r.Name != 'Professional Services - Standard Milestone' )){
                    if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.containsKey(productItemName)){
                      mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.put(productItemName, new Map<Boolean,Map<String,Decimal>>());
                      if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).containsKey(qteLine.SBQQ__Product__r.Is_Gainshare__c)){
                          mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).put(qteLine.SBQQ__Product__r.Is_Gainshare__c,new Map<String,Decimal>());
                          if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).containsKey(yearAsKey))
                              mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
                      }
                  }
                  else{
                      if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).containsKey(qteLine.SBQQ__Product__r.Is_Gainshare__c)){
                          mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).put(qteLine.SBQQ__Product__r.Is_Gainshare__c,new Map<String,Decimal>());
                          if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).containsKey(yearAsKey))
                              mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
  
                      }
                      else{
                          if(!mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).containsKey(yearAsKey)){
                              mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).put(yearAsKey,Math.round(qteLine.SBQQ__NetTotal__c));
                          }
                          else{
                              Decimal totalAmt = mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).get(yearAsKey) + qteLine.SBQQ__NetTotal__c;
                              mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(productItemName).get(qteLine.SBQQ__Product__r.Is_Gainshare__c).put(yearAsKey,Math.round(totalAmt));
                          }   
                      }
                  }   
                }

                if(!mapProductNameWithCode.containsKey(qteLine.SBQQ__Product__r.Name))
                  mapProductNameWithCode.put(qteLine.SBQQ__Product__r.Name, '');
                mapProductNameWithCode.put(qteLine.SBQQ__Product__r.Name, qteLine.SBQQ__Product__r.ProductCode);
                
                if((qteLine.SBQQ__Product__r.Name.contains('Pay Core Essentials Tier') || qteLine.SBQQ__Product__r.Name.contains('Pay Business Edition Tier')) && !qteLine.SBQQ__Product__r.Name.contains('Managed Onboarding-')){
                    AnnualQuantity annualQuantity = new AnnualQuantity();
                    annualQuantity.quantity = Integer.ValueOf(qteLine.Invoices__c);
                    annualQuantityOfPay.add(annualQuantity);
                    totalAnnualInvoiceRamp += Integer.valueOf(qteLine.Invoices__c != null ? qteLine.Invoices__c : 0);
                }
                if(qteLine.SBQQ__Product__r.Item__c == 'Scanning Services'){
                    AnnualQuantity annualQuantity = new AnnualQuantity();
                    annualQuantity.quantity = Integer.ValueOf(qteLine.SBQQ__Quantity__c);
                    annualQuantityOfScanningSevices.add(annualQuantity);
                    totalQuantityOfScanningServices += Integer.valueOf(qteLine.SBQQ__Quantity__c != null ? qteLine.SBQQ__Quantity__c : 0);
                }
            }

            for(String mapItemName : mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.keyset()){ 
                for(Boolean mapOptional : mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).keySet()){
                    List<QuoteLineWrapperYearWithAmount> listWrapper = new List<QuoteLineWrapperYearWithAmount>();
                    Decimal totaYearAmt =0.0;
                    List<String> nameAndCodeOfProducts = mapItemName.split('&&&');
                    if(nameAndCodeOfProducts[1] != Constants.PROFESSIONAL_SERVICES_ADVISOR_MILESTONE_CODE && nameAndCodeOfProducts[1] != Constants.PROFESSIONAL_SERVICES_STANDARD_MILESTONE_CODE ){
                      if(mapOptional == false){
                          for(String mapYear : mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).keySet()){
                              totaYearAmt += mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear);
                              listWrapper.add(new QuoteLineWrapperYearWithAmount(mapYear , mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear)));
                          }
                          totalOfAllYear = Math.round(totalOfAllYear + totaYearAmt);
                          if(!mapOfItemNameWithListOfWrapperForSummaryMod.containsKey(mapItemName))
                              mapOfItemNameWithListOfWrapperForSummaryMod.put(mapItemName, new List<QuoteLineWrapperForSummaryModel>());
                          mapOfItemNameWithListOfWrapperForSummaryMod.get(mapItemName).add(new QuoteLineWrapperForSummaryModel(nameAndCodeOfProducts[0], nameAndCodeOfProducts[1], mapOptional, listWrapper,Math.round(totaYearAmt)));
                      }
                       
                      else{
                          for(String mapYear : mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).keySet()){
                              totaYearAmt += mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear);
                              listWrapper.add(new QuoteLineWrapperYearWithAmount(mapYear , mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear)));
                          }
                          if(!mapOfForcastedItemWithWrapper.containsKey(mapItemName))
                              mapOfForcastedItemWithWrapper.put(mapItemName, new List<QuoteLineWrapperForSummaryModel>());
                          mapOfForcastedItemWithWrapper.get(mapItemName).add(new QuoteLineWrapperForSummaryModel(nameAndCodeOfProducts[0], nameAndCodeOfProducts[1], mapOptional, listWrapper,Math.round(totaYearAmt)));
                      }
                    }
                    else{
                      for(String mapYear : mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).keySet()){
                              totaYearAmt += mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear);
                              listWrapper.add(new QuoteLineWrapperYearWithAmount(mapYear , mapOfItemNameWithOptionalWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear)));
                          }
                          totalOfAllYear = Math.round(totalOfAllYear + totaYearAmt);
                          if(!mapOfItemNameWithOptionalWithOneTimeFeesWrapper.containsKey(mapItemName))
                              mapOfItemNameWithOptionalWithOneTimeFeesWrapper.put(mapItemName, new List<QuoteLineWrapperForSummaryModel>());
                          mapOfItemNameWithOptionalWithOneTimeFeesWrapper.get(mapItemName).add(new QuoteLineWrapperForSummaryModel(nameAndCodeOfProducts[0], nameAndCodeOfProducts[1], mapOptional, listWrapper,Math.round(totaYearAmt)));
                    }
                } 
            }
            
            //size check for map "mapOfItemNameWithGainshareWithYearwithTotalSummaryModel"
            if(mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.size() > 0){
                for(String mapItemName : mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.keyset()){ 
                    for(Boolean mapOptional : mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(mapItemName).keySet()){
                        List<QuoteLineWrapperYearWithAmount> listWrapper = new List<QuoteLineWrapperYearWithAmount>();
                        Decimal totaYearAmt =0.0;
                        List<String> nameAndCodeOfProducts = mapItemName.split('&&&');
                        for(String mapYear : mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).keySet()){
                            totaYearAmt += mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear);
                            listWrapper.add(new QuoteLineWrapperYearWithAmount(mapYear , mapOfItemNameWithGainshareWithYearwithTotalSummaryModel.get(mapItemName).get(mapOptional).get(mapYear)));
                        }
                        //totalOfAllYear = Math.round(totalOfAllYear + totaYearAmt);
                        if(!mapOfGainshareItemNameWithListOfWrapperForSummaryMod.containsKey(mapItemName))
                            mapOfGainshareItemNameWithListOfWrapperForSummaryMod.put(mapItemName, new List<QuoteLineWrapperForSummaryModel>());
                        mapOfGainshareItemNameWithListOfWrapperForSummaryMod.get(mapItemName).add(new QuoteLineWrapperForSummaryModel(nameAndCodeOfProducts[0], nameAndCodeOfProducts[1], mapOptional, listWrapper,Math.round(totaYearAmt)));
                    }
                }
            }
            
            //Size check
            if(mapOfSegmentedYearWithDifference.size() > 0){
              for(String yearLabel : mapOfSegmentedYearWithDifference.keySet()){
                Decimal totalDiscount =0;
                for(Decimal yearDiscount : mapOfSegmentedYearWithDifference.get(yearLabel)){
                  totalDiscount = totalDiscount+ yearDiscount;
                }
                if(!mapOfYearWithDiscount.containsKey(yearLabel))
                  mapOfYearWithDiscount.put(yearLabel, 0);
                mapOfYearWithDiscount.put(yearLabel, (mapOfSegmentedYearWithNetTotal.get(yearLabel) > 0 ? ((totalDiscount/mapOfSegmentedYearWithNetTotal.get(yearLabel))*100).setScale(2) : 0));
              }
            }
            Decimal totalDiscount = 0.0;
            Decimal netTotal = 0.0;
            //Loop for total discount
            for(String yearKey : mapOfSegmentedYearWithDifference.keySet()){
              for(Decimal yearDiscount : mapOfSegmentedYearWithDifference.get(yearKey)){
                  totalDiscount = totalDiscount+ yearDiscount;
                }
            }
            //Loop for total discount
            for(String yearKey : mapOfSegmentedYearWithNetTotal.keySet()){
              netTotal = (netTotal + mapOfSegmentedYearWithNetTotal.get(yearKey));
            }
            totalNonForcastedDiscount = (netTotal > 0 ? ((totalDiscount /netTotal) *100).setScale(2) : 0);
            sizeOfmapOfItemNameWithListOfWrapperForSummaryMod = mapOfItemNameWithListOfWrapperForSummaryMod.size();
            sizeOfmapOfGainshareItemNameWithListOfWrapperForSummaryMod = mapOfGainshareItemNameWithListOfWrapperForSummaryMod.size();
            sizeOfmapOfYearWithTotalOfYear = mapOfYearWithTotalOfYear.size();
            sizeOfmapOfForcastedItemWithWrapper = mapOfForcastedItemWithWrapper.size();
            sizeOfmapOfScanningServicesWithWrapper = mapOfScanningServicesWithWrapper.size();
            sizeOfmapOfAppPartnerWithWrapper = mapOfAppPartnerWithWrapper.size();
            sizeOfmapOfYearWithDiscount = mapOfYearWithDiscount.size();
            sizeOfMapProductNameWithCode = mapProductNameWithCode.size(); 
            sizeMapOfItemNameWithOptionalWithOneTimeFeesWrapper = mapOfItemNameWithOptionalWithOneTimeFeesWrapper.size();
            //System.assert(false, mapOfYearWithDiscount);
        }
        catch(Exception excpt){
            System.assert(false, excpt.getMessage()+'------------>'+excpt.getLineNumber());
        }  
    }
    public class QuoteLineWrapperForSummaryModel{
        
        //Item Name
        public String itemName{get;set;}

        //To hold the product is forecasted or not
        public Boolean isOptional{get; set;}
        
        //Wrapper List
        public List<QuoteLineWrapperYearWithAmount> wrapperWithYearAndAmt{get; set;}
        
        //Total amount
        public Decimal totalAmoutOfYears{get; set;}
        
        //To hold the product code
        public String productCode{get; set;}
        
        //To hold the "Maximun quantity statement"
        public String maxStatement{get; set;}

        public QuoteLineWrapperForSummaryModel(){
            itemName = '';
            productCode = '';
            totalAmoutOfYears =0.0;
            isOptional = true;
            wrapperWithYearAndAmt = new List<QuoteLineWrapperYearWithAmount>();
            maxStatement = '';
        }
        
        public QuoteLineWrapperForSummaryModel(String itemName, String productCode, Boolean isOptional, List<QuoteLineWrapperYearWithAmount> qteYearAmt, Decimal totalAmoutOfYears){
            List<String> productNameAndMaxInvoice = new List<String>();
            if(itemName.contains('&lt;')){
                productNameAndMaxInvoice = itemName.split('&lt;');
            }
            if(productNameAndMaxInvoice.size() > 0){
                this.itemName = productNameAndMaxInvoice[0] != null ? productNameAndMaxInvoice[0] : itemName;
                this.maxStatement = productNameAndMaxInvoice[1] != null ? productNameAndMaxInvoice[1] : '';
            }
            else {
                this.itemName = itemName;
                //this.maxStatement = '';
            }
            this.productCode = productCode;
            this.isOptional = isOptional ; 
            this.totalAmoutOfYears = totalAmoutOfYears;
            this.wrapperWithYearAndAmt = new List<QuoteLineWrapperYearWithAmount>(qteYearAmt);
            
        }
    }
    public class QuoteLineWrapperYearWithAmount{

        //To hold Year
        public String yearNumber{get; set;}
        
        //Amount of according to year
        public Decimal yearAMt{get; set;}

        //to hold the quantity of the product
        public Integer usageQuantity{get; set;}
        
        public QuoteLineWrapperYearWithAmount(){
            yearNumber = '';
            yearAMt = 0.0;
            usageQuantity = 0;
        }
        public QuoteLineWrapperYearWithAmount(String yearNumber, Decimal yearAMt){
            this.yearNumber = yearNumber;
            this.yearAMt = yearAMt;
        }
        public QuoteLineWrapperYearWithAmount(String yearNumber, Decimal yearAMt, Integer usageQuantity){
            this.yearNumber = yearNumber;
            this.yearAMt = yearAMt;
            this.usageQuantity = usageQuantity;
        }
    } 
    public class AnnualQuantity{
        public Integer quantity{get; set;}
        
        public AnnualQuantity(){
            quantity = 0;
        }

        public AnnualQuantity(Decimal quantity){
            this.quantity = Integer.valueOF(quantity);

        }
    }  
    /** 
    *    Description     :      This method is used to get the edition of the pay product
    *
    *    Created By      :      Akshay Bagrecha
    *
    *    Created Date    :      05/21/2019
    * 
    *    Revision Logs   :      V_1.0 - Created
    *                      
    **/
    public static String getEditionNameAndCode(String qtId){
      
      //String to hold the edition
      String editionName = '';
      
      //To hold the product code
      String productCode = '';
      
      //Null Check
      if(!String.isBlank(qtId)){
        
        //Loop over the Quotelines
        for(SBQQ__QuoteLine__c qtL : [Select Id, SBQQ__Product__r.Name, SBQQ__Product__r.Edition__c, SBQQ__Product__r.ProductCode  From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qtId And  SBQQ__StartDate__c != null Order By SBQQ__StartDate__c]){
          
          if(qtL.SBQQ__Product__r.Name.contains('Pay Core Essentials Tier') || qtL.SBQQ__Product__r.Name.contains('Pay Business Edition Tier')) {
            editionName = (qtL.SBQQ__Product__r.Edition__c != null ? qtL.SBQQ__Product__r.Edition__c : '' );
            productCode = (qtL.SBQQ__Product__r.ProductCode != null ? qtL.SBQQ__Product__r.ProductCode : '' );
            break;
          }
        }
      }
      if(editionName.containsIgnoreCase('Edition')){
        editionName = editionName.removeEndIgnoreCase('Edition');
      }
      return (editionName +'--'+productCode);
    }
    
     /** 
    *    Description     :      This method is used to get Invoice compliance details
    *
    *    Created By      :      Akshay Bagrecha
    *
    *    Created Date    :      05/22/2019
    * 
    *    Revision Logs   :      V_1.0 - Created
    *                      
    **/
    public static void getInvoiceComplianceDetail(String qtId){
      
      //Set to hold the ID of the Pay product or Invoice Compliance product
      Set<Id> quoteLineIds = new Set<Id>();
      
      //Set to hold the name of the Invoice complaince
      Set<String> invoiceComplianceNames = new Set<String>();
      
      //Set to hold the name of the Compliance partners
      Set<String> compliancePartnerNames = new Set<String>();
       
      for(SBQQ__QuoteLine__c qtL : [Select Id, SBQQ__Product__r.Name From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: qtId.trim()]){
        
        //Checks for the product
        if(qtL.SBQQ__Product__r.Name.contains('Pay Core Essentials Tier') || qtL.SBQQ__Product__r.Name.contains('Pay Business Edition') || qtL.SBQQ__Product__r.Name.contains('Pay Business Edition Plus') || qtL.SBQQ__Product__r.Name.contains('Invoice Compliance')){
          quoteLineIds.add(qtL.Id);
        }
      }

      //Size check for the set "quoteLineIds"
      if(quoteLineIds.size() > 0){
        
        //Loop over the Invoice Compliance
        for(Invoice_Compliance_Details__c invoiceComp : [Select Id, Name, Value_in_Amount__c, Value_in_Percent__c From Invoice_Compliance_Details__c where Quote_Line__c IN: quoteLineIds]){
          
          //Necessary Check
          if(invoiceComp.Value_in_Percent__c > 0){
            
            invoiceComplianceNames.add(invoiceComp.Name.replaceAll('[1-7]. ', ''));  
          }  
        }
      }
    
      //Size check for the set "invoiceComplianceNames"
      if(invoiceComplianceNames.size() > 0){
        
        //Loop over the Compliance partner detail
        for(Compliance_Partner_Rate_Details__c compPartner : [Select Id, Partner__r.Name From Compliance_Partner_Rate_Details__c where Name IN: invoiceComplianceNames]){
          
          compliancePartnerNames.add(compPartner.Partner__r.Name);
        }
      }
      
      //To add the Invoice compliance into a string
      if(invoiceComplianceNames.size() > 0){
        for(String invoiceComp : invoiceComplianceNames){
          invoiceComplianceRegion += (invoiceComplianceRegion == '' ? '' : ', ') + invoiceComp;          
        }
      }
      
      //To add the Compliance Partner into a string
      if(compliancePartnerNames.size() > 0){
        for(String compPartner : compliancePartnerNames){
          compliancePartner += (compliancePartner == '' ? '' : ', ') + compPartner;          
        }
      }      
    }
}