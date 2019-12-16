/** 
*    Description     :      This class is used as a helper of the quote trigger
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      21/02/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                    :      V1.1 Update By Akshay Bagrecha 07/18/2019
*                      
**/
public class QuoteTriggerHelper {
    
    static final String QUOTE_OBJECT = 'QUOTE';
    public static Boolean BYPASS_OPPORTUNITY_TRIGGER = false;
    public static Boolean bypassUpdateAverageACV  = false;
    public static Boolean callingFromQuote = false;
    
    /*
    *   @desc   :   Method to set the first quote as primary
    *
    *   @arg    :   List<SBQQ__Quote__c> newQuotes
    *
    *   @return :   void
    */
    public static void setFirstQuoteAsPrimary(List<SBQQ__Quote__c> newQuotes) {
        
        //Set to hold the id of Opportuinity 
        Set<Id> oppIds = new Set<Id>();
        
        for(SBQQ__Quote__c qte : newQuotes) {
            
            if(qte.SBQQ__Opportunity2__c != null && !qte.SBQQ__Primary__c)
                oppIds.add(qte.SBQQ__Opportunity2__c);
        }
        
        if(oppIds.size() > 0) {
            
            Map<Id, Opportunity> mapOfOpportunityWithQuote = new Map<Id, Opportunity>([SELECT Id, SBQQ__PrimaryQuote__c FROM Opportunity WHERE Id IN : oppIds]);
        
            for(SBQQ__Quote__c qte : newQuotes) {
                if(qte.SBQQ__Opportunity2__c != null && !qte.SBQQ__Primary__c) {
                    if(mapOfOpportunityWithQuote.get(qte.SBQQ__Opportunity2__c).SBQQ__PrimaryQuote__c == null)
                        qte.SBQQ__Primary__c = true;
                }
            }
        }
    }
            
    /*
    * Description   :  This method is used auto populate the subscription term value when master contract is populated
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   31/01/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateSubscriptionTerm(List<SBQQ__Quote__c> newQuoteList){

        //Set to hold the master contract
        Set<Id> masterContractIDs = new Set<Id>();

        for(SBQQ__Quote__c qt : newQuoteList){
            if(qt.SBQQ__MasterContract__c != null)
                masterContractIDs.add(qt.SBQQ__MasterContract__c);
        }
        
        if(masterContractIDs.size() > 0){
            
            //Map to hold the ID  with contract
            Map<ID, Contract> mapOfIdWithContract = new Map<Id,Contract>([Select Id, ContractTerm From Contract where ID IN: masterContractIDs]);
            
            if(masterContractIDs.size() > 0){
                for(SBQQ__Quote__c qute : newQuoteList){
                    qute.SBQQ__SubscriptionTerm__c = mapOfIdWithContract.get(qute.SBQQ__MasterContract__c).ContractTerm;
                }
            }
        }
    }
    

    /*
    * Description   :  This Method is used to check, if Dynamic Discount/Invoice Compliance Product are related to the Quote
    *
    * Created By    :   Romesh Kumar
    *
    * Created Date  :   03/29/2019
    *
    * Version       :   V1.0 Created
    *                   V1.1 Updated By Akshay(02/05/2019):for the Pay product check
    * 					V1.2 Updated By Akshay(27/11/2019): for CPQ-300
    *             
    */
    public static void isDynamicDiscountOrICProductExist(List<SBQQ__Quote__c> newQuotes) {
    
        Map<Id, SBQQ__Quote__c> mapOfQuoteWithQuoteLineItem = new Map<Id, SBQQ__Quote__c>([SELECT Id, (SELECT Id, Name, SBQQ__ProductName__c, SBQQ__ProductCode__c, SBQQ__ProductFamily__c FROM SBQQ__LineItems__r) FROM SBQQ__Quote__c WHERE Id IN: newQuotes]);
        
        for(SBQQ__Quote__c qte : newQuotes) {
            
            Boolean isDynamicDiscountEsist = false;
            Boolean isICOrPayOrScanningServices = false;
            Boolean isPay = false;
            Boolean isPayOrBuy = false;
            
            if(mapOfQuoteWithQuoteLineItem .get(qte.Id).SBQQ__LineItems__r.size() > 0) {
                for(SBQQ__QuoteLine__c qteLine : mapOfQuoteWithQuoteLineItem .get(qte.Id).SBQQ__LineItems__r) {
                    if(qteLine.SBQQ__ProductName__c.equalsIgnoreCase(Constants.DYNAMIC_DISCOUNTING_NAME) || qteLine.SBQQ__ProductCode__c == Constants.DYNAMIC_DISCOUNTING_CODE )
                        isDynamicDiscountEsist = true;
                    
                    if(qteLine.SBQQ__ProductName__c == 'Scanning Services'
                    || qteLine.SBQQ__ProductName__c.contains('Pay Core Essentials')
                    || qteLine.SBQQ__ProductName__c.contains('Pay Business Edition'))
                        isICOrPayOrScanningServices = true;
                    
                    //Updated by Akshay for pay product check 
                    if(qteLine.SBQQ__ProductName__c.contains('Pay Core Essentials') || qteLine.SBQQ__ProductName__c.contains('Pay Business Edition') || qteLine.SBQQ__ProductName__c.contains('Pay Business Edition Plus'))
                        isPay = true;
                    
                     /* Added By Akshay Bagrecha 11/27/2019  for CPQ-300*/
                    if(qteLine.SBQQ__ProductName__c.contains('Pay Core Essentials Tier') || qteLine.SBQQ__ProductName__c.contains('Pay Business Edition Tier') || qteLine.SBQQ__ProductName__c == 'Tradeshift Buy')
                        isPayOrBuy = true;
                }
            }
            
            qte.Is_Dynamic_Discounting_Exist__c = isDynamicDiscountEsist;
            qte.Is_Pay_IC_Product_Added__c= isICOrPayOrScanningServices;
            qte.Is_Pay_Product_Added__c = isPay; 
            qte.Is_PayOrBuy__c = isPayOrBuy;
        }
    }

    /*
    * Description   :  This method is used update the value of the start date as effective date field value
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/04/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateStartDate(List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c> mapOfQuote){
       
        for(SBQQ__Quote__c qte : newQuotes){
             if(qte.Effective_Date__c != null && (mapOfQuote == null || qte.Effective_Date__c != mapOfQuote.get(qte.Id).Effective_Date__c)){
                qte.SBQQ__StartDate__c = qte.Effective_Date__c;
            }
        }
    }

    /*
    * Description   :  This method is used update the value of the Opportunity field
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   01/05/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateOpportunityDetails(List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c> mapQuoteWithID){

        //Set to hold the Opportunity ID
        /*Set<Id> oppIds = new Set<Id>();

        for(SBQQ__Quote__c qt : newQuotes){
            if(qt.SBQQ__Primary__c == true && qt.Total_ACV__c != null && qt.TCV__c != null 
                && (mapQuoteWithID == null  || (qt.SBQQ__Primary__c != mapQuoteWithID.get(qt.Id).SBQQ__Primary__c 
                                            || qt.TCV__c != mapQuoteWithID.get(qt.Id).TCV__c
                                            || qt.Total_ACV__c != mapQuoteWithID.get(qt.Id).Total_ACV__c))){
                oppIds.add(qt.SBQQ__Opportunity2__c);
            }
        }
        
        if(oppIds.size() > 0){
            
            Map<Id, Opportunity> mapOfOpp = new Map<Id, Opportunity>([Select Id, ACV2__c, TCV2__c, Updated_From__c From Opportunity Where ID IN: oppIds]);
         
            if(mapOfOpp.size() > 0){
    
                for(SBQQ__Quote__c qt : newQuotes){
                    if(mapOfOpp.containsKey(qt.SBQQ__Opportunity2__c)) {
                        mapOfOpp.get(qt.SBQQ__Opportunity2__c).ACV2__c = qt.ACV__c;
                        mapOfOpp.get(qt.SBQQ__Opportunity2__c).TCV2__c = qt.TCV__c;
                        mapOfOpp.get(qt.SBQQ__Opportunity2__c).Updated_From__c = QUOTE_OBJECT ;   
                    }                 
                }
            }
    
            if(mapOfOpp.size() > 0){
                BYPASS_OPPORTUNITY_TRIGGER = true; 
                update mapOfOpp.values();            
            }
        }*/
        //Set to hold the Opportunity ID
        Set<Id> oppIds = new Set<Id>();
        
        //Loop on SBQQ__Quote__c
        for(SBQQ__Quote__c qt : newQuotes){
            if(qt.SBQQ__Opportunity2__c != null && qt.SBQQ__Primary__c)
                oppIds.add(qt.SBQQ__Opportunity2__c );
        }
        
        //Size check
        if(oppIds.size() > 0){
            
            //Opportunity to update
            List<Opportunity> oppToBeUpdate = new List<Opportunity>();
            
            for(Opportunity opp : [Select Id, SBQQ__PrimaryQuote__r.TCV__c, SBQQ__PrimaryQuote__r.ACV__c, ACV2__c, TCV2__c, Updated_From__c From Opportunity Where ID IN: oppIds]){
                Boolean updateByQuote = false;
                Opportunity oppt = new Opportunity();
                if(opp.TCV2__c != opp.SBQQ__PrimaryQuote__r.TCV__c){
                    oppt.TCV2__c = opp.SBQQ__PrimaryQuote__r.TCV__c;
                    updateByQuote = true;
                }
                if(opp.ACV2__c != opp.SBQQ__PrimaryQuote__r.ACV__c){
                    oppt.ACV2__c = opp.SBQQ__PrimaryQuote__r.ACV__c;
                    updateByQuote = true;
                }
                if(updateByQuote = true){
                    oppt.Updated_From__c = QUOTE_OBJECT;
                    oppt.Id = opp.ID;
                }
                oppToBeUpdate.add(oppt);
            }
            
            //Size check of list "oppToBeUpdate"
            if(oppToBeUpdate.size() > 0){
                BYPASS_OPPORTUNITY_TRIGGER = true; 
                update oppToBeUpdate;
            }
        }
    }
       
    /*
    * Description   :  This method is used to update the effective date at the time of amendement.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   05/13/2019
    *
    * Version       :   V1.0 Created
    *             
    */  
    public static void updateQuoteAfterAmendment(List<SBQQ__Quote__c> quotes){
    
        //Set to hold the master contract value
        Set<Id> masterContractIDs = new Set<Id>();
        
        for(SBQQ__Quote__c qt : quotes){
            if(qt.SBQQ__Type__c == 'Amendment' && qt.SBQQ__MasterContract__c != null){
                masterContractIDs.add(qt.SBQQ__MasterContract__c);
            }
        }

        if(masterContractIDs.size() > 0){
            
            Map<ID, Contract> mapOfIdWithContract = new Map<Id,Contract>([Select Id, StartDate,SBQQ__AmendmentStartDate__c, ContractNumber, SBQQ__Quote__r.SBQQ__Account__r.Name, SBQQ__Quote__r.SBQQ__StartDate__c, SBQQ__Quote__r.Quote_Name__c, SBQQ__Quote__r.Company_Location__c From Contract where ID IN: masterContractIDs]);
            
            if(mapOfIdWithContract.size() > 0){
                for(SBQQ__Quote__c qt : quotes){
                    if(mapOfIdWithContract.containsKey(qt.SBQQ__MasterContract__c)){
Date amendDate = mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__AmendmentStartDate__c;
                        if(mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__AmendmentStartDate__c == null){
                            amendDate = System.today();
                        }
                        qt.Effective_Date__c = amendDate < mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).StartDate ? mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).StartDate : amendDate;
                        //qt.Effective_Date__c = mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__AmendmentStartDate__c != null ? mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__AmendmentStartDate__c : System.today();
                        qt.Quote_Name__c = (mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__Quote__r.SBQQ__Account__r.Name != null ? mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__Quote__r.SBQQ__Account__r.Name : qt.SBQQ__BillingName__c )
                                            +' - Amendment Quote for '+ mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).ContractNumber;
                        qt.Company_Location__c =  mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__Quote__r.Company_Location__c != null ? mapOfIdWithContract.get(qt.SBQQ__MasterContract__c).SBQQ__Quote__r.Company_Location__c : 'US';
                    }
                }
            }
        }
    }
   
    /**
    *    @description    :    Method to restrict user, not to delete the primary Quote
    *
    *    @param          :    List<SBQQ__Quote__c> 
    *
    *    @return         :    Void
    **/
    public static void primaryQuoteCanNotDelete(List<SBQQ__Quote__c> oldQuotes) {
    
        for(SBQQ__Quote__c qte : oldQuotes) {
            if(qte.SBQQ__Primary__c) 
                qte.addError('Primary Quote can not be deleted. In order to delete this Quote, please create a new Primary Quote');
        }
    }
    
    /**
    *    @description    :    THis method is used to update Start End Date on The Opportunity
    *
    *    @param          :    List<SBQQ__Quote__c>, Map<Id, SBQQ__Quote__c>
    *
    *    @return         :    Void
    **/
    public static void updateOpportunityDate(List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c>  mapOfOldQuotes) {
        
        List<Opportunity> opportunities = new List<Opportunity>();
        
        for(SBQQ__Quote__c qt : newQuotes){
            
            if(qt.SBQQ__Opportunity2__c != null && qt.Effective_Date__c != null && qt.SBQQ__EndDate__c != null
                && ( mapOfOldQuotes == null 
                    || ( mapOfOldQuotes.get(qt.Id).SBQQ__Opportunity2__c != qt.SBQQ__Opportunity2__c 
                    || mapOfOldQuotes.get(qt.Id).Effective_Date__c != qt.Effective_Date__c 
                    || mapOfOldQuotes.get(qt.Id).SBQQ__EndDate__c != qt.SBQQ__EndDate__c)
                    )
                ){
                opportunities.add(new Opportunity(ID = qt.SBQQ__Opportunity2__c, Start_Date__c = qt.Effective_Date__c, End_Date__c = qt.SBQQ__EndDate__c));
            }
        }
        
        if(opportunities.size() > 0){
            update opportunities;
        }
    }
    
    /**
    *    @description    :    This method is used to update currency of the quote as Opportunity Currency Code
    *
    *    @param          :    List<SBQQ__Quote__c>
    *
    *    @return         :    Void
    **/
    public static void updateCurrencyAsOpp(List<SBQQ__Quote__c> newQuotes){
        
        //Set to hold the Opportunity Id
        Set<Id> oppIds = new Set<Id>();
        
        for(SBQQ__Quote__c qt: newQuotes){
            if(qt.SBQQ__Opportunity2__c != null)
                oppIds.add(qt.SBQQ__Opportunity2__c);
        } 

        if(oppIds.size() > 0){
            
            Map<Id, Opportunity> mapOfOpportunities = new Map<Id, Opportunity>([Select Id, CurrencyIsoCode From Opportunity Where ID IN: oppIds]);
            
            if(mapOfOpportunities.size() > 0){
                for(SBQQ__Quote__c qt: newQuotes){
                    
                    if(mapOfOpportunities.containsKey(qt.SBQQ__Opportunity2__c))
                        qt.CurrencyIsoCode = mapOfOpportunities.get(qt.SBQQ__Opportunity2__c).CurrencyIsoCode;
                }
            }
        }
    }
     /*
    * Description   :  This method is used Calulate the ACV value for the quoteLines.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   05/13/2019
    *
    * Version       :   V1.0 Created
    *               :   V1.1 Updated By Romesh Kumar 
    *             
    */
    public static void updateAverageACV(List<SBQQ__Quote__c> quotes, Map<Id, SBQQ__Quote__c> mapOfQuotes){ 
		//System.assert(false, 'Called');
        //Set to hold the Quote__c
        Set<Id> quoteIds = new Set<Id>(); 
        
        //Map to hold the quoteLines
        Map<String, List<SBQQ__QuoteLine__c>> mapOfQuoteLineWithName = new Map<String, List<SBQQ__QuoteLine__c>>();
                
        //List to update QuoteLine
        List<SBQQ__QuoteLine__c> quoteLinesToUpdate = new List<SBQQ__QuoteLine__c>();
        
        //Map to hold the avg ACV with its Name
        Map<String, Decimal> mapOfAvgAcvWithName = new Map<String, Decimal>();
        
        for(SBQQ__Quote__c qt : quotes){
            
            if((qt.SBQQ__LastCalculatedOn__c != null || qt.SBQQ__LastSavedOn__c != null) && (mapOfQuotes != null 
            && (qt.SBQQ__LastCalculatedOn__c != mapOfQuotes.get(qt.Id).SBQQ__LastCalculatedOn__c 
                || qt.SBQQ__LastSavedOn__c != mapOfQuotes.get(qt.Id).SBQQ__LastSavedOn__c ))) 
                 quoteIds.add(qt.Id);
        }

        if(quoteIds.size() > 0){
            Map<String, Integer> mapOfTermWthProductName = new Map<String, Integer>();
            Map<String, Decimal> mapOfAvgACVWthProductName = new Map<String, Decimal>();
            Set<Id> setOfQuoteLineId = new Set<Id>();

            for(SBQQ__QuoteLine__c qtLine : [Select Id, SBQQ__SpecialPrice__c, SBQQ__EffectiveQuantity__c, UpliftPercent__c, Quote_Subscription_Term__c,SBQQ__Discount__c, SBQQ__AdditionalDiscountAmount__c, SBQQ__ListPrice__c, SBQQ__ProrateMultiplier__c, SBQQ__Quote__r.SBQQ__StartDate__c, SBQQ__Quote__r.SBQQ__EndDate__c, SBQQ__ProductName__c,SBQQ__StartDate__c,SBQQ__EndDate__c, Average_Net_Total__c, SBQQ__NetTotal__c, SBQQ__Quantity__c, SBQQ__NetPrice__c, ACV__c, ACV_amt__c, SBQQ__Quote__r.Subscription_Term_Months__c, SBQQ__Quote__r.Subscription_Term__c From SBQQ__QuoteLine__c Where SBQQ__Quote__c IN: quoteIds And SBQQ__Bundle__c = false]){
                if(!mapOfQuoteLineWithName.containsKey(qtLine.SBQQ__ProductName__c)) 
                    mapOfQuoteLineWithName.put(qtLine.SBQQ__ProductName__c, new List<SBQQ__QuoteLine__c>());
                  mapOfQuoteLineWithName.get(qtLine.SBQQ__ProductName__c).add(qtLine);
            }
        }
        System.debug('mapOfQuoteLineWithName:---' + mapOfQuoteLineWithName);
        if(mapOfQuoteLineWithName.size() > 0){
            
            for(String mapKey : mapOfQuoteLineWithName.keySet()){
                
                //Variable to hold the average ACV
                Decimal avgAcv = 0.0;
                
                for(SBQQ__QuoteLine__c qtL : mapOfQuoteLineWithName.get(mapKey)){
                    //Modified By Akshay Bagrecha- 21-10-2019
                    //Modified By Akshay Bagrecha- 15-10-2019 :- Change after call discussion.
                    Double prorationPrice = qtl.SBQQ__SpecialPrice__c;
                    //Decimal netTotal = qtl.SBQQ__ProrateMultiplier__c < 1 ? ((prorationPrice + (((prorationPrice * qtl.UpliftPercent__c ) / 100 ) - (qtl.SBQQ__AdditionalDiscountAmount__c !=null ? qtl.SBQQ__AdditionalDiscountAmount__c : (prorationPrice * (qtl.SBQQ__Discount__c != null ? qtl.SBQQ__Discount__c : 0))/100 ))) * qtl.SBQQ__Quantity__c): qtL.SBQQ__NetTotal__c ;
                   
                    //Modified By Akshay Bagrecha- 30-09-2019 :- Change quantity to effective quantity for the calculation.
                    Decimal netTotal = qtl.SBQQ__ProrateMultiplier__c < 1 ? ((prorationPrice  - (qtl.SBQQ__AdditionalDiscountAmount__c !=null ? qtl.SBQQ__AdditionalDiscountAmount__c : (prorationPrice * (qtl.SBQQ__Discount__c != null ? qtl.SBQQ__Discount__c : 0))/100 )) * qtl.SBQQ__EffectiveQuantity__c): qtL.SBQQ__NetTotal__c ;
                    
                    avgACV = avgACV + netTotal;
                    
                   // avgACV = avgACV +  qtl.SBQQ__NetTotal__c;
                }
                
                if(!mapOfAvgAcvWithName.containsKey(mapKey))
                    mapOfAvgAcvWithName.put(mapKey, 0.0);
                mapOfAvgAcvWithName.put(mapKey, avgACV);
            }
        }
                    System.debug('mapOfAvgAcvWithName:---' + mapOfAvgAcvWithName);

        if(mapOfAvgAcvWithName.size() > 0){
            for(String mapKey : mapOfAvgAcvWithName.keyset()){
                for(SBQQ__QuoteLine__c qtL : mapOfQuoteLineWithName.get(mapKey)){
                    Sbqq__QuoteLine__c qt = new Sbqq__QuoteLine__c();
                    qt.Id = qtL.Id;
                    qt.Average_Net_Total__c = qtL.Quote_Subscription_Term__c > 0 ? mapOfAvgAcvWithName.get(mapKey) / qtL.Quote_Subscription_Term__c : 0;
                    quoteLinesToUpdate.add(qt);
                }
            }
        }
        if(quoteLinesToUpdate.size() > 0) {
            callingFromQuote = true;
            update quoteLinesToUpdate;
        }
    }
    /*
    * Description   :  This method is used put blank on field
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/22/2019
    *
    * Version       :   V1.0 Created
    *               :   
    *             
    */
    public static void udpdateQuoteFields(List<SBQQ__Quote__c> newQuotes){
        
        for(SBQQ__Quote__c qt : newQuotes){
            if(qt.SBQQ__LineItemCount__c == 0){
                qt.Difference_Amount__c = 0;
            }
        }
    }
    
    /*
    * Description   :  This method is used update the value of subscription term on the basis of the effective date and end date
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   17/04/2019
    *
    * Version       :   V1.0 Created
    *               :   V1.1 Updated By Akshay Bagrecha.
    *             
    */
    public static void updateSubscriptionTermWithDays(List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c> mapOfQuote){
        
        //Map to hold the Start Date and End Date as key and Subscirption term in months as Value
        Map<Id, Map<String, Double>> mapTermWithDateAsKey = new Map<Id, Map<String, Double>>();
        
        //Map to hold the total months
        Map<Id, Double> mapMonthsWithQuoteId = new Map<Id, Double>();
        
        Set<String> keys = new Set<String>();
        
        for(SBQQ__QuoteLine__c qteLine : [SELECT Id, SBQQ__ProrateMultiplier__c, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Quote__c FROM SBQQ__QuoteLine__c WHERE  SBQQ__Quote__c IN: mapOfQuote.keySet()  AND SBQQ__StartDate__c != null] ) {
            String key = String.valueOf(qteLine.SBQQ__StartDate__c) + '-' + qteLine.SBQQ__EndDate__c;
            
            if(!keys.contains(key) && qteLine.SBQQ__ProrateMultiplier__c != null) {
                if(!mapMonthsWithQuoteId.containsKey(qteLine.SBQQ__Quote__c))
                    mapMonthsWithQuoteId.put(qteLine.SBQQ__Quote__c, 0);
  
                if(!mapTermWithDateAsKey.containsKey(qteLine.SBQQ__Quote__c))
                    mapTermWithDateAsKey.put(qteLine.SBQQ__Quote__c, new Map<String, Double>());
                    
                mapTermWithDateAsKey.get(qteLine.SBQQ__Quote__c).put(key, ((qteLine.SBQQ__ProrateMultiplier__c != null ? qteLine.SBQQ__ProrateMultiplier__c : 0) * 12));
                mapMonthsWithQuoteId.put(qteLine.SBQQ__Quote__c,
                 (mapMonthsWithQuoteId.get(qteLine.SBQQ__Quote__c) + mapTermWithDateAsKey.get(qteLine.SBQQ__Quote__c).get(key) ));
            
                keys.add(key);
            }

        }
        for(SBQQ__Quote__c qte :  mapOfQuote.values()) {
            if(mapTermWithDateAsKey.containsKey(qte.Id)) {
                qte.Subscription_Term__c = mapMonthsWithQuoteId.get(qte.Id);
            }
        }

    }
    
    /**
    *    @description    :    Method to restrict user, not to delete the primary Quote
    *
    *    @param          :    List<SBQQ__Quote__c> 
    *
    *    @return         :    Void
    **/
    public static void changePrimaryQuoteOnDelete(List<SBQQ__Quote__c> oldQuotes) {
        
        //Set to hold the opportunity of the primary quote.
        Set<String> opportunityIds = new Set<String>();
        
        for(SBQQ__Quote__c qte : oldQuotes) {
         
            if(qte.SBQQ__Primary__c) 
                opportunityIds.add(qte.SBQQ__Opportunity2__c);
        }
        if(opportunityIds.size() >0){
            
            //List to update Quote.
            List<SBQQ__Quote__c> quoteToBeUpdated = new List<SBQQ__Quote__c>(); 
            
            for(Opportunity opp : [Select Id, (Select ID, Quote_Name__c, SBQQ__Primary__c From SBQQ__Quotes2__r Order By CreatedDate Desc LIMIT 1) From Opportunity Where ID IN: opportunityIds]){
                if(opp.SBQQ__Quotes2__r.size() > 0){
                    for(SBQQ__Quote__c qt: opp.SBQQ__Quotes2__r){
                        quoteToBeUpdated.add(new SBQQ__Quote__c(ID =qt.ID, SBQQ__Primary__c = true));   
                        
                    }
                }   
            }
            
            if(quoteToBeUpdated.size() > 0)
                update quoteToBeUpdated;
        }
    }
    
    /*
    * Description   :  This method is used Calulate the average deviation.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   07/31/2019
    *
    * Version       :   V1.0 Created 
    *             
    */
    public static void updateAverageDeviation(List<SBQQ__Quote__c> quotes, Map<Id, SBQQ__Quote__c> mapOfQuotes){
        
        //Set to hold the Quote__c
        Set<Id> quoteIds = new Set<Id>();
        
        //Map to hold the quoteLines
        Map<String, List<SBQQ__QuoteLine__c>> mapOfQuoteLineWithName = new Map<String, List<SBQQ__QuoteLine__c>>();
        
        for(SBQQ__Quote__c qt : quotes){
            if(qt.SBQQ__LastCalculatedOn__c != null && (mapOfQuotes != null && qt.SBQQ__LastCalculatedOn__c != mapOfQuotes.get(qt.Id).SBQQ__LastCalculatedOn__c ))
                quoteIds.add(qt.Id);
        }
        
        if(quoteIds.size() > 0){
           
            //Map to hold the avg Deviation with its Name
            Map<String, Decimal> mapOfAvgDeviationWithName = new Map<String, Decimal>();
            
            //List to hold the update quoteline
            List<SBQQ__QuoteLine__c> quoteLinesToUpdate = new List<SBQQ__QuoteLine__c>();
            
            for(SBQQ__QuoteLine__c qtLine : [Select Id, Deviation_ProratedPrice_v_s_NetTotal__c, SBQQ__ProductName__c From SBQQ__QuoteLine__c Where SBQQ__Quote__c IN: quoteIds And SBQQ__Bundle__c = false]){
                if(!mapOfQuoteLineWithName.containsKey(qtLine.SBQQ__ProductName__c)) 
                    mapOfQuoteLineWithName.put(qtLine.SBQQ__ProductName__c, new List<SBQQ__QuoteLine__c>());
                  mapOfQuoteLineWithName.get(qtLine.SBQQ__ProductName__c).add(qtLine);
            }
            
            if(mapOfQuoteLineWithName.size() > 0){
                for(String mapKey : mapOfQuoteLineWithName.keySet()){
                    
                    //Variable to hold the average ACV
                    Decimal avgDeviation = 0.0;
                    
                    //To hold the count of year
                    Integer numberOfQuoteLine = 0;
                        
                    for(SBQQ__QuoteLine__c qtL : mapOfQuoteLineWithName.get(mapKey)){
                        avgDeviation = avgDeviation + (qtL.Deviation_ProratedPrice_v_s_NetTotal__c != null ? qtL.Deviation_ProratedPrice_v_s_NetTotal__c : 0);
                        numberOfQuoteLine++;
                    }
                    
                    if(!mapOfAvgDeviationWithName.containsKey(mapKey))
                        mapOfAvgDeviationWithName.put(mapKey, 0.0);
                    mapOfAvgDeviationWithName.put(mapKey, (avgDeviation/numberOfQuoteLine));
                }
            }

            if(mapOfAvgDeviationWithName.size() > 0){
                for(String mapKey : mapOfAvgDeviationWithName.keyset()){
                    for(SBQQ__QuoteLine__c qtL : mapOfQuoteLineWithName.get(mapKey)){
                        quoteLinesToUpdate.add(new SBQQ__QuoteLine__c(ID = qtL.ID, Average_Deviation__c = (mapOfAvgDeviationWithName.containsKey(mapKey) ? mapOfAvgDeviationWithName.get(mapKey) : 0)));
                    }
                }
            }
            
            if(quoteLinesToUpdate.size() > 0)
                update quoteLinesToUpdate;
        }
    }
    
    /*
    * Description   :  This method is used to populate the company address from custom metadata
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   08/26/2019
    *
    * Version       :   V1.0 Created
    *             
    */  
    public static void updateCompanyAddress(List<SBQQ__Quote__c> newQuotes, Map<Id, SBQQ__Quote__c> mapOfQuotes){
        
        //Set to hold the company location
        Set<String> companyLocations = new Set<String>();
        
        //Loop on the list of quote
        for(SBQQ__Quote__c qt : newQuotes){
            if(qt.Company_Location__c != null && (mapOfQuotes == null || qt.Company_Location__c != mapOfQuotes.get(qt.ID).Company_Location__c)){
                companyLocations.add(qt.Company_Location__c);
            }
        }
        //Map to hold the entity and its address.
        Map<String, String> mapOfEntityWithAdd = new Map<String, string>();
        
        //Size check for the set "companyLocations" 
        if(companyLocations.size() > 0){

            //To get the custom metadata record.
            for(Entity_Setting__mdt entity : [Select DeveloperName, Company_Address__c From Entity_Setting__mdt Where DeveloperName IN: companyLocations]){
                
                if(!mapOfEntityWithAdd.containsKey(entity.DeveloperName))
                    mapOfEntityWithAdd.put(entity.DeveloperName, '');
                mapOfEntityWithAdd.put(entity.DeveloperName, entity.Company_Address__c);    
            }

            //Size Check of map "mapOfEntityWithAdd"    
            if(mapOfEntityWithAdd.size() > 0){
                
                //Loop onthe quote
                //Loop on the list of quote
                for(SBQQ__Quote__c qt : newQuotes){
                    qt.Company_Address__c = mapOfEntityWithAdd.containsKey(qt.Company_Location__c) ? mapOfEntityWithAdd.get(qt.Company_Location__c) : '' ;
                }
            }
        }
    }
    
    
    /*
    * Description   :  This method is used to populate Quote name and Effective date after renewal
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/12/2019
    *
    * Version       :   V1.0 Created
    *               :   V1.1 Modified By Akshay bagrecha 10/07/2019 - CPQ 255
    *             
    */  
    public static void updateQuoteAfterRenewal(List<SBQQ__Quote__c> quotes){

        //Set to hold the Opportunity ID.
        Set<ID> opportunityIds = new Set<ID>();

        //Loop on the SBQQ__Quote__c
        for( SBQQ__Quote__c qt : quotes){

            //Check for the SBQQ__Type__c to 'Renewal'
            if(qt.SBQQ__Type__c == 'Renewal' && qt.SBQQ__Opportunity2__c != null)
                opportunityIds.add(qt.SBQQ__Opportunity2__c);
        }

        //size check for the set "OpportunityIds"
        if(opportunityIds.size() > 0){
            //Map to hold the Opportunity
            Map<ID, Opportunity> mapOfOpprotunity = new Map<ID, Opportunity>([Select ID, Name, SBQQ__RenewedContract__r.endDate, SBQQ__RenewedContract__r.ContractNumber, SBQQ__RenewedContract__r.SBQQ__Quote__r.Company_Location__c From Opportunity where ID IN: opportunityIds]);

            //Size check for map "mapOfOpprotunity"
            if(mapOfOpprotunity.size() > 0 ){

                //Loop on SBQQ__Quote__c
                for( SBQQ__Quote__c qt : quotes){
                    if(mapOfOpprotunity.containsKey(qt.SBQQ__Opportunity2__c)){
                        qt.Company_Location__c = mapOfOpprotunity.get(qt.SBQQ__Opportunity2__c).SBQQ__RenewedContract__r.SBQQ__Quote__r.Company_Location__c != null ? mapOfOpprotunity.get(qt.SBQQ__Opportunity2__c).SBQQ__RenewedContract__r.SBQQ__Quote__r.Company_Location__c : '';
                        /* Modified By Akshay Bagrecha 11-19-2019 Due to getting error at time of creating quote with type "Renewal"*/
                        if(qt.Effective_Date__c == null)
                            qt.Effective_Date__c = qt.SBQQ__StartDate__c != null  ? qt.SBQQ__StartDate__c : mapOfOpprotunity.get(qt.SBQQ__Opportunity2__c).SBQQ__RenewedContract__r.endDate + 1 ;
                        
                        /* Modified By Akshay Bagrecha 11-19-2019 Due to getting error at time of creating quote with type "Renewal"*/
                        if(qt.Quote_Name__c == null)
                        	qt.Quote_Name__c = qt.SBQQ__BillingName__c +' - Renewal for Contract '+mapOfOpprotunity.get(qt.SBQQ__Opportunity2__c).SBQQ__RenewedContract__r.ContractNumber;
                    }
                }
            }
        }
    }
}