/**
 * Description  :   Test class for Quote Trigger
 * Coverage     :   100%
 **/
@isTest
public class OpportunityLineItemTrigger_Test {
    
    @testSetup static void createTestData() {
        
        //Insert Products
        List<Product2> products = new List<Product2>();
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.SCANNING_SERVICES_NAME, Family = Constants.PAY_PRODUCT, IsActive = true,
                                  ProductCode = Constants.SCANNING_SERVICES_CODE, SBQQ__Component__c = false, ACV__c= 0,
                                  SBQQ__AssetConversion__c = 'One per quote line', SBQQ__DefaultQuantity__c = 1,
                                  SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionBase__c = 'List', Is_Forecasted__c = true));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.PAY_CORE_ESSENTIAL_1_NAME, IsActive = true, ProductCode = Constants.PAY_CORE_ESSENTIAL_1_CODE, 
                                  SBQQ__Component__c = true,SBQQ__DefaultQuantity__c = 1, Is_Forecasted__c = False, ACV__c=100));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.MANAGED_ONBOARDING_NAME, IsActive = true, ProductCode = Constants.MANAGED_ONBOARDING_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1, Is_Forecasted__c = true, ACV__c=50));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.DYNAMIC_DISCOUNTING_NAME, IsActive = true, ProductCode = Constants.DYNAMIC_DISCOUNTING_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1, Is_Forecasted__c = true, ACV__c = 0));
        
         //Add new Products in List
        products.add(new Product2(Name = Constants.INVOICE_COMPLIANCE_NAME, IsActive = true, ProductCode = Constants.INVOICE_COMPLIANCE_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1, Is_Forecasted__c = true, ACV__c = 0));
        //Start test here
        Test.startTest();
        
        //Insert
        insert products;
        
        //Price Book ID
        Id pricebookId = Test.getStandardPricebookId();
        
        //Price Book Entry
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        priceBookEntries.add(new PricebookEntry(Product2Id=products[0].Id, Pricebook2Id=pricebookId, UnitPrice=5000, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[1].Id, Pricebook2Id=pricebookId, UnitPrice=5000, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[2].Id, Pricebook2Id=pricebookId, UnitPrice=5000, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[3].Id, Pricebook2Id=pricebookId, UnitPrice=5000, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[4].Id, Pricebook2Id=pricebookId, UnitPrice=5000, IsActive=true));
        
        insert priceBookEntries;
        
        //List of account
        List<Account> accounts = TestDataUtility.createAccounts(1);
        
        Opportunity opp = new Opportunity();
        opp.name = 'Hello Kitty';
        opp.AccountId = accounts[0].Id;
        opp.Type = 'Services';
        opp.StageName = '1 - Identify';
        opp.TradeShift_Category__c = 'Upside';
        opp.Trigger__c = 'Alliances';
        opp.CloseDate = System.today().addDays(10);
        
        insert opp;
        CustomTriggers__c cT = new CustomTriggers__c();
        cT.Active_Custom_Trigger_on_Contract__c = true;
        cT.Active_Custom_Trigger_on_Opportunity__c = true;
        cT.Active_Custom_Trigger_on_Quote__c = true;
        cT.Active_Custom_Trigger_on_QuoteLine__c = true;
		insert cT;
        
        //Stop test here updateListUnitPrice
        Test.stopTest();
    }
    @isTest static void testUpdateACVFromQL() {
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId, SBQQ__PrimaryQuote__c, ACV2__c, TCV2__c From Opportunity Where AccountId =: accounts[0].Id];
        
        //Assert
        System.assertEquals(1, opps.size());
        
        //Get Product
        List<Product2> products = [Select Id, Name, Is_Forecasted__c From Product2];
        //Assert
        System.assertEquals(5, products.size());
        System.assertEquals(true, products[0].Is_Forecasted__c);
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote', Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(2), SBQQ__Opportunity2__c = opps[0].Id ));
        
        //Insert Quote
        insert quotes;
        
        List<SBQQ__Quote__c> insertedQuotes = [Select Id, Subscription_Term_Months__c, SBQQ__LastCalculatedOn__c From SBQQ__Quote__c];
        //System.assertEquals(24, Math.round(insertedQuotes[0].Subscription_Term_Months__c));
        
        //Add QuoteLine
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>(); 
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 1', SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 2', SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
               
        //Insert quoteLine
        insert quoteLines;
        
        List<Sbqq__QuoteLine__c> insertedQuoteLine = [Select Id, ACV_amt__c, ACV__c, SBQQ__ListPrice__c From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: quotes[0].Id];
        insertedQuoteLine[0].Acv__c =100;
        insertedQuoteLine[1].Acv__c =100;
        update insertedQuoteLine;
        
        //Update Quote
        List<SBQQ__Quote__c> quotesToBeUpdated = [Select Id, Subscription_Term_Months__c, SBQQ__LastCalculatedOn__c, SBQQ__Introduction__c From SBQQ__Quote__c];
        quotesToBeUpdated[0].SBQQ__LastCalculatedOn__c = System.now();
        update quotesToBeUpdated;
        
        
        List<Sbqq__QuoteLine__c> updatedQuoteLine = [Select Id, ACV_amt__c, ACV__c, SBQQ__ListPrice__c, SBQQ__ProratedListPrice__c, Average_Net_Total__c From SBQQ__QuoteLine__c Where SBQQ__Quote__c =: quotes[0].Id];
        
        List<OpportunityLineItem> oppItems = [Select ID, ACV_amt__c From OpportunityLineItem Where OpportunityId =: opps[0].Id ]; 
        //System.assertEquals(oppItems[0].ACV_amt__c, oppItems[0].ACV_amt2__c);
        oppItems[0].ACV_amt__c = 100;
        update oppItems;
        
        
        //Stop Test here
        Test.stopTest();
    }
}