public with sharing class BillingScheduleController {

    //List to hold SBQQ__Quote__c
    public List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();

    //Map: Key as year number and Value as billingSchdule
    public Map<Integer, BillingScheduleDates> mapOfBillingSchedule{get; set;}

    //To hold the size of the map "mapOfBillingSchedule" 
    public Integer sizeOfMapOfBillingSchedule{get; set;} 

    public string date1{get; set;}
   
    public BillingScheduleController() {

        //QuoteID
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        mapOfBillingSchedule  = new Map<Integer, BillingScheduleDates>();
        sizeOfMapOfBillingSchedule = 0;
        
        
        //Neccessary Check
        if(quoteId != null){

            //Loop on query
            quotes = [Select ID, Effective_Date__c, Subscription_Term_Months__c, SBQQ__PaymentTerms__c, SBQQ__EndDate__c From SBQQ__Quote__c Where ID =: quoteId];

            if(quotes.size() > 0){
                /*Modified By Akshay Bagrecha 10/30/2019 CPQ-288 - Put the null check for the subscription term */
                Integer totalQuoteYear =  quotes[0].Subscription_Term_Months__c != null ? Integer.valueOf(Math.Ceil(quotes[0].Subscription_Term_Months__c/12)) : 1;
                Integer netTerm =  quotes[0].SBQQ__PaymentTerms__c.contains('Net') ? Integer.valueOf((quotes[0].SBQQ__PaymentTerms__c.remove('Net')).trim()) : 0;
                Datetime invoiceStarDate = quotes[0].Effective_Date__c;
               
                if(totalQuoteYear > 0){

                    for(Integer indx = 1; indx <= totalQuoteYear; indx++){
                        
                        if(!mapOfBillingSchedule.containsKey(indx))
                            mapOfBillingSchedule.put(indx, new BillingScheduleDates());
                        if(totalQuoteYear == indx){
                            Datetime endDate = quotes[0].SBQQ__EndDate__c;
                            mapOfBillingSchedule.put(indx, new BillingScheduleDates(indx, invoiceStarDate.formatGmt('yyy/MM/dd'), endDate.formatGmt('yyy/MM/dd'), invoiceStarDate.addDays(netTerm).formatGmt('yyy/MM/dd'), netTerm));
                            }
                        else
                            mapOfBillingSchedule.put(indx, new BillingScheduleDates(indx, invoiceStarDate.formatGmt('yyy/MM/dd'), (invoiceStarDate.addYears(1) -1).formatGmt('yyy/MM/dd'), invoiceStarDate.addDays(netTerm).formatGmt('yyy/MM/dd'), netTerm));
                        invoiceStarDate = invoiceStarDate.addYears(1);
                    }
                }
            }
            sizeOfMapOfBillingSchedule = mapOfBillingSchedule.size();
        }
    }

    //Wrapper Class to hold the billing Schedule
    public class BillingScheduleDates{
        
        //To hold year number
        public Integer yearNum{get; set;}

        //To hold the invoice start Date
        public String invoiceStartDate{get; set;}

        //To hold the invoice end date  
        public String invoiceEndDate{get; set;}

        //To hold the invoice due date
        public String invoiceDueDate{get; set;}

        //To hold the net term
        public String netTermInDays{get; set;}
        

        //Default Constructor
        public BillingScheduleDates(){
            yearNum = 0;
            invoiceStartDate = '';
            invoiceEndDate = '';
            invoiceDueDate = '';
            netTermInDays = '';
        }
        public BillingScheduleDates(Integer yearNum, String invoiceStartDate , String invoiceEndDate, String invoiceDueDate, Integer netTermInDays){
            this.yearNum = yearNum;
            this.invoiceStartDate = invoiceStartDate;
            this.invoiceEndDate = invoiceEndDate;
            this.invoiceDueDate = invoiceDueDate;

            this.netTermInDays = netTermInDays != null ? netTermInDays+' Days': null;
        }
    }
}