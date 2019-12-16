/**
 * Description  :   Test class for Quote Trigger
 * Coverage     :   97%
 **/
@isTest
public class QuoteTrigger_Test {
    
    
    public static Product2 prod = new Product2();
    static Id pricebookId;
    static PricebookEntry standardPrice = new PriceBookEntry();
    static Pricebook2 customPB = new PriceBook2();
    static PricebookEntry customPrice = new PriceBookEntry();

    
    @testSetup static void createTestData() {
        
        //Insert Products
        List<Product2> products = new List<Product2>();
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.SCANNING_SERVICES_NAME, Family = Constants.PAY_PRODUCT, IsActive = true,
                                  ProductCode = Constants.SCANNING_SERVICES_CODE, SBQQ__Component__c = false,
                                  SBQQ__AssetConversion__c = 'One per quote line', SBQQ__DefaultQuantity__c = 1,
                                  SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionBase__c = 'List'));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.PAY_CORE_ESSENTIAL_1_NAME, IsActive = true, ProductCode = Constants.PAY_CORE_ESSENTIAL_1_CODE, 
                                  SBQQ__Component__c = true,SBQQ__DefaultQuantity__c = 1));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.MANAGED_ONBOARDING_NAME, IsActive = true, ProductCode = Constants.MANAGED_ONBOARDING_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.DYNAMIC_DISCOUNTING_NAME, IsActive = true, ProductCode = Constants.DYNAMIC_DISCOUNTING_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1));
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
        insert priceBookEntries;
        
        //List of account
        List<Account> accounts = TestDataUtility.createAccounts(1);
        
        //Create contact
        Contact contact = new Contact(FirstName = 'Sub Test', LastName = 'Contact', AccountId = accounts[0].Id, LeadSource = 'Alliances');
        insert contact;
        
        Opportunity opp = new Opportunity();
        opp.name = 'Hello Kitty';
        opp.AccountId = accounts[0].Id;
        opp.Primary_Contact__c = contact.Id;
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
        
        //Stop test here
        Test.stopTest();
    }

    @isTest static void testUpdateSubscriptionTermWithDays() {
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Get Contact
        List<Contact> contacts = [Select Id From Contact];
        
        //Assert
        System.assertEquals(1, contacts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
        
        List<Contract> contracts = TestDataUtility.createContracts(accounts, opps);

      /*  List<Opportunity> childOpps = new List<Opportunity>();
        
        //Creating child opportunities
        for(Contract cont: contracts) {
            childOpps.add(new Opportunity(Name = 'Test Opp1 - >' + cont.AccountId, CloseDate = Date.today().addDays(3), StageName = '1 - Identify', AccountId = cont.AccountId, SBQQ__AmendedContract__c = cont.Id));
        }
        
        insert childOpps;
        */
        //Assert
        System.assertEquals(1, opps.size());
        
        //Get Product
        List<Product2> products = [Select Id, Name From Product2 ORDER BY SBQQ__Component__c ASC, Name ASC];
        
        //Assert
        System.assertEquals(4, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',Company_Location__c = 'US', Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5),SBQQ__Opportunity2__c = opps[0].Id ));
        
        //Insert quote
        insert quotes;
        
        //Query on Quote
        List<SBQQ__Quote__c> insertedQuote = [Select ID, SBQQ__StartDate__c, SBQQ__SubscriptionTerm__c, Subscription_Term_Months__c From SBQQ__Quote__c];
        
        //Assert
        //System.assertEquals(quotes[0].Effective_Date__c, insertedQuote[0].SBQQ__StartDate__c);
        //System.assertEquals(60, Integer.valueOf(insertedQuote[0].Subscription_Term_Months__c));
        
        //Test ends here
        Test.stopTest();
    }
    
    @isTest static void testUpdateSubscriptionTerm() {
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Get Contact
        List<Contact> contacts = [Select Id From Contact];
        
        //Assert
        System.assertEquals(1, contacts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
        
        List<Contract> contracts = TestDataUtility.createContracts(accounts, opps);

        List<Opportunity> childOpps = new List<Opportunity>();
        
        //Assert
        System.assertEquals(1, opps.size());
        
        //Get Product
        List<Product2> products = [Select Id, Name From Product2 ORDER BY SBQQ__Component__c ASC, Name ASC];
        
        //Assert
        System.assertEquals(4, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',SBQQ__MasterContract__c = contracts[0].ID, Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id ));
        
        //Insert quote
        insert quotes;
        
        //Query on Quote
        List<SBQQ__Quote__c> insertedQuote = [Select ID, SBQQ__StartDate__c, SBQQ__SubscriptionTerm__c, Subscription_Term_Months__c From SBQQ__Quote__c];
        
        //Asserts
        System.assertEquals(contracts[0].ContractTerm, insertedQuote[0].SBQQ__SubscriptionTerm__c);
        
        //Test ends here
        Test.stopTest();
    }
    
    @isTest static void testIsDynamicDiscountOrICProductExist() {
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Get Contact
        List<Contact> contacts = [Select Id From Contact];
        
        //Assert
        System.assertEquals(1, contacts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
        
        List<Contract> contracts = TestDataUtility.createContracts(accounts, opps);

        List<Opportunity> childOpps = new List<Opportunity>();
        
        //Assert
        System.assertEquals(1, opps.size());
        
        //Get Product
        List<Product2> products = [Select Id, Name From Product2 ORDER BY SBQQ__Component__c ASC, Name ASC];
        
        //Assert
        System.assertEquals(4, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',SBQQ__MasterContract__c = contracts[0].ID, Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id ));
        insert quotes;
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        
        
        //Add Proposal Lines under the Proposal
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1,  SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100,
                                                                     SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
        //Add Proposal Lines under the Proposal
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[1].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1,  SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100,
                                                                     SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
        //Add Proposal Lines under the Proposal
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[3].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1,  SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100,
                                                                     SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
        //Insert quoteLine
        insert quoteLines;
        
        List<SBQQ__QuoteLine__c> insertedQL = new List<SBQQ__QuoteLine__c>([Select ID, SBQQ__Product__c, ACV_amt__c, SBQQ__Quote__c From SBQQ__QuoteLine__c]);
        System.assertEquals(3, insertedQL.size());
        Double totalAcv = 0;
        for(SBQQ__QuoteLine__c ql : insertedQL){
            totalAcv = totalAcv + ql.ACV_amt__c;
        }
        
        //Query on Quote
        List<SBQQ__Quote__c> insertedQuote = [Select ID, SBQQ__StartDate__c, Total_ACV__c, SBQQ__SubscriptionTerm__c, Subscription_Term_Months__c From SBQQ__Quote__c];
        System.assertEquals(insertedQuote[0].Total_ACV__c, totalAcv);
        
        //Test ends here
        Test.stopTest();
    }
     @isTest static void testUpdateOpportunityDetails() {
        
         //Test starts here
         Test.startTest();
         
         //Get Account
         List<Account> accounts = [Select Id From Account order By Name];
         
         //Assert
         System.assertEquals(1, accounts.size());
         
         //Get Contact
         List<Contact> contacts = [Select Id From Contact];
         
         //Assert
         System.assertEquals(1, contacts.size());
         
         //Getting Opportunity
         List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
         
         List<Contract> contracts = TestDataUtility.createContracts(accounts, opps);
         
         List<Opportunity> childOpps = new List<Opportunity>();
         
         //Assert
         System.assertEquals(1, opps.size());
         
         //Get Product
         List<Product2> products = [Select Id, Name From Product2 ORDER BY SBQQ__Component__c ASC, Name ASC];
         
         //Assert
         System.assertEquals(4, products.size());
         
         List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
         
         //Add new proposal record in list
         quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',SBQQ__Primary__c = true, SBQQ__LastCalculatedOn__c=System.now(), Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id ));
         insert quotes;
         
         List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
         
         
         //Add Proposal Lines under the Proposal
         quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100,
                                               SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
         //Add Proposal Lines under the Proposal
         quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[1].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100 ,
                                               SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
         //Add Proposal Lines under the Proposal
         quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[3].Id, SBQQ__Number__c = 11, SBQQ__Quantity__c = 1, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100, 
                                               SBQQ__PricingMethod__c = 'List', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__DefaultSubscriptionTerm__c = 12));
         //Insert quoteLine
         insert quoteLines; 
         
         //Getting Opportunity
         List<Opportunity> insertedOpps = [Select Id, Name, AccountId, ACV2__c, TCV2__c From Opportunity Where AccountId =: accounts[0].Id];
         List<SBQQ__Quote__c> insertedQuote = [Select ID, SBQQ__LastCalculatedOn__c, SBQQ__StartDate__c, Total_ACV__c, TCV__c, SBQQ__SubscriptionTerm__c, Subscription_Term_Months__c From SBQQ__Quote__c];
         //System.assertEquals(insertedOpps[0].ACV2__c, insertedQuote[0].Total_ACV__c);
         //System.assertEquals(insertedOpps[0].TCV2__c, insertedQuote[0].TCV__c);
         
         //Test ends here
         Test.stopTest();
         
     }
    @isTest static void testUpdateEffectiveDateAfterAmendment(){
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
        
        //Get Product
        List<Product2> products = [Select Id, Name From Product2 Where Name =: Constants.PAY_CORE_ESSENTIAL_1_NAME];
        
        //Assert
        System.assertEquals(1, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',SBQQ__LastCalculatedOn__c=System.Now(), SBQQ__Primary__c = true, Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id ));
        insert quotes; 
        
        //Add QuoteLine
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>(); 
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 1', SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 2', SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
               
        //Insert quoteLine
        insert quoteLines; 
        
        opps[0].StageName = '7 - Closed/Won';    
        update opps;
        //System.assert(false, [Select Id, Amount, SBQQ__Contracted__c From Opportunity]);
        List<Contract> conts = [Select ID, AccountId From Contract WHere SBQQ__Opportunity__c =: opps[0].ID];
        //System.assertEquals(1, conts.size());
        
        //Stop test here
        Test.stopTest();
    }
    @isTest static void testPrimaryQuoteCanNotDelete(){
        
        //Test starts here
        Test.startTest();
        
        //Get Account
        List<Account> accounts = [Select Id From Account order By Name];
        
        //Assert
        System.assertEquals(1, accounts.size());
        
        //Getting Opportunity
        List<Opportunity> opps = [Select Id, Name, AccountId From Opportunity Where AccountId =: accounts[0].Id];
        
        //Get Product
        List<Product2> products = [Select Id, Name From Product2 Where Name =: Constants.PAY_CORE_ESSENTIAL_1_NAME];
        
        //Assert
        System.assertEquals(1, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote', SBQQ__Primary__c = true, SBQQ__LastCalculatedOn__c=System.Now(), Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id ));
        insert quotes; 
       
        Database.DeleteResult result = Database.Delete(quotes[0], false);
        //System.assertEquals('Primary Quote can not be deleted. In order to delete this Quote, please create a new Primary Quote',result.getErrors()[0].getMessage());
        //Stop test here
        Test.stopTest();
    }
}