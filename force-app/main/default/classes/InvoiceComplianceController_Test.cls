/**
* Description	:	Test class for Invoice compliance Controller
* Coverage		:	0%
**/
@isTest
public class InvoiceComplianceController_Test {
    
    @testSetup static void createTestData() {
        
        //Insert Products
        List<Product2> products = new List<Product2>();
        
        //Add new Products in List
        
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.PAY_CORE_ESSENTIAL_1_NAME, IsActive = true, ProductCode = Constants.PAY_CORE_ESSENTIAL_1_CODE, 
                                  SBQQ__Component__c = true,SBQQ__DefaultQuantity__c = 1, SBQQ__SubscriptionTerm__c = 12, Average_Annual_Invoice_Volume__c='1-100,000'));
        
        //Add new Products in List
        products.add(new Product2(Name = Constants.MANAGED_ONBOARDING_NAME, IsActive = true, ProductCode = Constants.MANAGED_ONBOARDING_CODE, 
                                  SBQQ__Component__c = true, SBQQ__DefaultQuantity__c = 1, SBQQ__SubscriptionTerm__c = 12));
        
        products.add(new Product2(Name = Constants.SCANNING_SERVICES_NAME, Family = Constants.PAY_PRODUCT, IsActive = true,
                                  ProductCode = Constants.SCANNING_SERVICES_CODE, SBQQ__Component__c = false,
                                  SBQQ__AssetConversion__c = 'One per quote line', SBQQ__DefaultQuantity__c = 1,
                                  SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionBase__c = 'List'));
        
        //Start test here
        Test.startTest();
        
        //Insert
        insert products;
        
        //Price Book ID
        Id pricebookId = Test.getStandardPricebookId();
        
        //Price Book Entry
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        priceBookEntries.add(new PricebookEntry(Product2Id=products[0].Id, Pricebook2Id=pricebookId, UnitPrice=59500, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[1].Id, Pricebook2Id=pricebookId, UnitPrice=20000, IsActive=true));
        priceBookEntries.add(new PricebookEntry(Product2Id=products[2].Id, Pricebook2Id=pricebookId, UnitPrice=0, IsActive=true));
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
    
    
    @isTest static void testInvoiceCompliance() {
        
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
        System.assertEquals(3, products.size());
        
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        
        //Add new proposal record in list
        quotes.add(new SBQQ__Quote__c(Quote_Name__c='Test Quote',SBQQ__MasterContract__c = contracts[0].ID, Effective_Date__c = Date.today(), SBQQ__EndDate__c = Date.today().addYears(5), SBQQ__Opportunity2__c = opps[0].Id, Company_Location__c = 'US'));
        
        //Insert quote
        insert quotes;
        
        //Add QuoteLine
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>(); 
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 1', SBQQ__ProratedListPrice__c = 10000, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[0].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 2', SBQQ__ProratedListPrice__c = 10000, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[1].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 1', SBQQ__ProratedListPrice__c = 10000, SBQQ__Discount__c=20, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[1].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 2', SBQQ__ProratedListPrice__c = 10000, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[2].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 1', SBQQ__ProratedListPrice__c = 10000, SBQQ__Discount__c=20, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quotes[0].Id, SBQQ__Product__c = products[2].Id, SBQQ__Quantity__c = 1, SBQQ__SegmentLabel__c='Year 2', SBQQ__ProratedListPrice__c = 10000, SBQQ__ProrateMultiplier__c=1, SBQQ__ListPrice__c = 100));
        
        //Insert quoteLine
        insert quoteLines; 
        
        //Invoice Compliance invoiceCompliances.add(new Invoice_Compliance_Details__c());
        List<Invoice_Compliance_Details__c> invoiceCompliances = new List<Invoice_Compliance_Details__c>();
        invoiceCompliances.add(new Invoice_Compliance_Details__c(Name= '1. Regular Post-audit', Value_in_Percent__c=100, Year__c='1', Quote_Line__c = quoteLines[0].Id));
        invoiceCompliances.add(new Invoice_Compliance_Details__c(Name= '1. Regular Post-audit', Value_in_Percent__c=100, Year__c='1', Quote_Line__c = quoteLines[1].Id));
        invoiceCompliances.add(new Invoice_Compliance_Details__c(Name= '1. Regular Post-audit', Value_in_Percent__c=100, Year__c='1', Quote_Line__c = quoteLines[2].Id));
        
        //Insert invoice compliance
        insert invoiceCompliances;
        
        Test.stopTest();
        
        SBQQ__Quote__c insertedQuote = [Select Id From SBQQ__Quote__c Limit 1];
        System.assertEquals(quotes[0].Id, insertedQuote.Id);
        
        ApexPages.currentPage().getParameters().put('Id',insertedQuote.Id);
        InvoiceComplianceCOntroller controllerIC = new InvoiceComplianceController();
        PageReference pageInvoiceController = controllerIC.saveInvoiceCompliance();
    }
}