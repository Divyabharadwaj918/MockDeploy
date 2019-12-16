public with sharing class SubscriptionTriggerHelper {

    //Bypass Variable
    public static Boolean By_Pass_SubscriptionTrigger = false;
    
    public static void updateAmountOnContract(List<SBQQ__Subscription__c> subs){

        //Set to hold the contract ID
        Set<ID> contractIds = new Set<ID>();

        //Boolean check for the Assets
        Boolean isAssetOnAccount = false;

        //Loop on new subscription product
        for(SBQQ__Subscription__c sub : subs){

            //Necessary Checks
            if(sub.SBQQ__Contract__c != null && sub.ACV__c != null)
                contractIds.add(sub.SBQQ__Contract__c); 
        }

        //Size Check 
        if(contractIds.size() > 0){
            
            //List of contract to update
            List<Contract> contractToBeUpdate = new List<Contract>();
            
            //Map to hold the contractID with productName and its ACV amount
            Map<ID, Set<ID>> mapOfContractWithQuotes = new Map<ID, Set<ID>>();

            //Map to hold the Quote with Wrapper
            Map<ID, ContractWrapper> mapOfQuoteWrapper = new Map<Id, ContractWrapper>();

            //Set to hold quote IDS
            Set<ID> quoteIds = new Set<ID>(); 

            //Query on Subscription
            for(SBQQ__Subscription__c sub : [SELECT Related_Quote__c, SBQQ__Contract__c FROM SBQQ__Subscription__c Where SBQQ__Contract__c IN: contractIds ]){
                quoteIds.add(sub.Related_Quote__c);
                if(!mapOfContractWithQuotes.containsKey(sub.SBQQ__Contract__c))
                    mapOfContractWithQuotes.put(sub.SBQQ__Contract__c, new Set<ID>());
                mapOfContractWithQuotes.get(sub.SBQQ__Contract__c).add(sub.Related_Quote__c);
            }

            // //Query on asset
            // for(Asset ast : [SELECT Related_Quote__c, Contract__c FROM Asset Where Contract__c IN: contractIds ]){
            //     quoteIds.add(ast.Related_Quote__c);
            //     isAssetOnAccount = true;
            //     if(!mapOfContractWithQuotes.containsKey(ast.Contract__c))
            //         mapOfContractWithQuotes.put(ast.Contract__c, new Set<ID>());
            //     mapOfContractWithQuotes.get(ast.Contract__c).add(ast.Related_Quote__c);
            // }

            //Map size check "mapOfContractWithQuotes"
            if(mapOfContractWithQuotes.size() > 0){
                
                //Size check 
                if(quoteIds.size() > 0){
                    
                    //Loop on SBQQ__Quote__c
                    for(SBQQ__Quote__c qute : [Select ID, ACV__c, TCV__c, Total_Service_Amount__c, Managed_Services_ACV__c,  Committed_Amount__c, Forecasted_Amount__c	From SBQQ__Quote__c Where ID IN: quoteIds]){
                        if(!mapOfQuoteWrapper.containsKey(qute.ID))
                            mapOfQuoteWrapper.put(qute.ID, new ContractWrapper());
                        ContractWrapper conWrap = new ContractWrapper();
                        conWrap.contractACV = qute.ACV__c + (mapOfQuoteWrapper.containsKey(qute.ID) ? mapOfQuoteWrapper.get(qute.ID).contractACV : 0);
                        conWrap.contractTCV = qute.TCV__c + (mapOfQuoteWrapper.containsKey(qute.ID) ? mapOfQuoteWrapper.get(qute.ID).contractTCV : 0);
                        conWrap.contractTotalAmount = qute.Committed_Amount__c + qute.Forecasted_Amount__c + (mapOfQuoteWrapper.containsKey(qute.ID) ? mapOfQuoteWrapper.get(qute.ID).contractTotalAmount : 0);
                        conWrap.contractOneTimeService = (qute.Total_Service_Amount__c - qute.Managed_Services_ACV__c) + (mapOfQuoteWrapper.containsKey(qute.ID) ? mapOfQuoteWrapper.get(qute.ID).contractOneTimeService : 0);
                        mapOfQuoteWrapper.put(qute.ID, conWrap);
                    }
                }
                //size Check for map "mapOfQuoteWrapper" 
                if(mapOfQuoteWrapper.size() > 0){ 

                    for(String contIds : mapOfContractWithQuotes.keyset()){
                        Contract con = new contract();
                         con.ID = contIds;
                        for(String quoteID : mapOfContractWithQuotes.get(contIds)){
                            con.Original_Amount__c = (con.Original_Amount__c != null ? con.Original_Amount__c : 0)  + (mapOfQuoteWrapper.containsKey(quoteID) ? mapOfQuoteWrapper.get(quoteID).contractTotalAmount : 0);
                            con.Original_ACV__c = (con.Original_ACV__c != null ? con.Original_ACV__c : 0) + (mapOfQuoteWrapper.containsKey(quoteID) ? mapOfQuoteWrapper.get(quoteID).contractACV : 0);
                            con.Original_TCV__c = (con.Original_TCV__c != null ? con.Original_TCV__c : 0) + (mapOfQuoteWrapper.containsKey(quoteID) ? mapOfQuoteWrapper.get(quoteID).contractTCV : 0);   
                            /* Modified By Akshay Bagrecha 11-04-2019*/
                            //con.One_Time_Services__c = (con.One_Time_Services__c != null ? con.One_Time_Services__c : 0) + (mapOfQuoteWrapper.containsKey(quoteID) ? mapOfQuoteWrapper.get(quoteID).contractOneTimeService : 0);   
                        }
                        contractToBeUpdate.add(con); 
                    }
                }
               
                //size check for List to update
                if(contractToBeUpdate.size() > 0)
                    update contractToBeUpdate;
            }
        }
    }

    //Wrapper for the
    public class ContractWrapper{

        public Decimal contractACV;
        public Decimal contractTCV;
        public Decimal contractTotalAmount;
        public Decimal contractOneTimeService;

        //Constructor
        public ContractWrapper(){
            contractACV = 0;
            contractTCV = 0;
            contractTotalAmount = 0;
            contractOneTimeService = 0;
        }

        //Parameterized constructor
        public ContractWrapper(Decimal contractACV, Decimal contractTCV, Decimal contractTotalAmount, Decimal contractOneTimeService){

            this.contractACV = contractACV;
            this.contractTCV = contractTCV;
            this.contractTotalAmount = contractTotalAmount;
            this.contractOneTimeService = contractOneTimeService;
        }
    }
}