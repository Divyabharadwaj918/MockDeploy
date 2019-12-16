/**
 * Utility class to create test data 
 **/
@isTest
public class TestDataUtility {
    
    //Method to create bulk accoutns
    public static List<Account> createAccounts(Integer noOfRecord) {
        
        List<Account> accounts = new List<Account>();
        for(Integer count = 0; count<noOfRecord; count++){
        	accounts.add(new Account(Name = 'Test Account '+count, BillingCountry  = 'USA'));
        }
        
        insert accounts;
        return accounts;
    }
    
    //Method to create parent Opportunities
    public static List<Opportunity> createParentOpps(List<Account> accounts) {
        
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account acc: accounts) {
            opportunities.add(new Opportunity(Name = 'Test Opp - >' + acc.Id, CloseDate = Date.today().addDays(3), StageName = '1 - Identify', AccountId = acc.Id, Trigger__c = 'Alliances'));
        }
        
        insert opportunities;
        return opportunities;
    }
    
    //Method to create bulk contracts
    public static List<Contract> createContracts(List<Account> accounts, List<Opportunity> opportunities) {
        
        List<Contract> newContracts = new List<Contract>();
        for(Opportunity opp: opportunities) {
            newContracts.add(new Contract(AccountId = opp.AccountId, StartDate = Date.today(), ContractTerm = 3, SBQQ__Opportunity__c = opp.Id));
        }

        insert newContracts;
        return newContracts;
    }
    
    //Method to create bulk quotes
    public static List<SBQQ__Quote__c> createQuotes(List<Opportunity> opportunities) {
        
        opportunities = [Select Id, SBQQ__AmendedContract__c, AccountId FROM Opportunity WHERe Id IN: opportunities];
        
        List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>();
        for(Opportunity opp : opportunities) {
            newQuotes.add(new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id, SBQQ__Account__c = opp.AccountId, SBQQ__MasterContract__c = opp.SBQQ__AmendedContract__c, Effective_Date__c  = Date.today(), SBQQ__EndDate__c = Date.today().addYears(3)));
        }
        
        insert newQuotes;
        return newQuotes;
    }
    
    //Method to create Quote Line items
    public static List<SBQQ__QuoteLine__c> createQuoteProducts(List<SBQQ__Quote__c> quotes, Pricebook2 customPB, Product2 prod, PricebookEntry customPrice) {
        
        for(SBQQ__Quote__c qte : quotes)
            qte.SBQQ__PriceBook__c = customPB.Id;
        update quotes;
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__Quote__c qote : quotes) {
            quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Product__c	= prod.Id, SBQQ__PricebookEntryId__c = customPB.Id, SBQQ__Quote__c = qote.Id ));
        }
        
        insert quoteLines;
        return quoteLines;
    }
    
    //Method to create Product Options
    public static List<SBQQ__ProductOption__c> createProductOptions(Product2 prod) {
        
        List<SBQQ__ProductOption__c> newProductOptions = new List<SBQQ__ProductOption__c>();
        
        for(Integer i = 0; i < 3; i ++) {
            newProductOptions.add(new SBQQ__ProductOption__c(SBQQ__Number__c = i, SBQQ__ConfiguredSKU__c = prod.Id, SBQQ__OptionalSKU__c = prod.Id));
        }
        
        insert newProductOptions;
        return newProductOptions;
    }
}