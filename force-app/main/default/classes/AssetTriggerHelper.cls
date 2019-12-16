/** 
*    Description     :      This class is used as a helper og the asset trigger
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      09/10/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                      
**/
public with sharing class AssetTriggerHelper {
    
    //Boolean bypas trigger
    public static Boolean bypassAssetTrigger = false;

    /**
    * Description   :  This method is used auto populate contract ID.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :    09/10/2019
    *
    * Version       :   V1.0 Created
    *             
    **/
    public static void updateContract(List<Asset> assets){

        //Set to hold the quotelineIDS
        Set<ID> quotelineIds = new Set<Id>();

        //Loop on new Asset
        for(Asset ast : assets){
            if(ast.SBQQ__QuoteLine__c != null && ast.Contract__c == null)
                quotelineIds.add(ast.SBQQ__QuoteLine__c);
        }

        //size check for set " quotelineIds "
        if(quotelineIds.size() > 0){

            //Map to hold the quoteLine ID with opportunity ID
            Map<ID, ID> mapofQuoteLines = new Map<Id, ID>();

            //Map to hold the Opportunity ID with contract ID
            Map<ID, ID> mapOfOppIDWithContractID = new Map<ID, ID>();

            //Loop on related quoteLines
            for(SBQQ__QuoteLine__c qtLine : [Select ID, SBQQ__Quote__r.SBQQ__Opportunity2__c, SBQQ__Quote__r.SBQQ__Type__c, SBQQ__Quote__r.SBQQ__MasterContract__c  From SBQQ__QuoteLine__c Where ID IN: quotelineIds AND SBQQ__Quote__r.SBQQ__Primary__c = true]){
                
                //Check for amended quote.
                if( qtLine.SBQQ__Quote__r.SBQQ__MasterContract__c != null){
                    if(!mapOfOppIDWithContractID.containsKey(qtLine.SBQQ__Quote__r.SBQQ__Opportunity2__c))
                        mapOfOppIDWithContractID.put(qtLine.SBQQ__Quote__r.SBQQ__Opportunity2__c, qtLine.SBQQ__Quote__r.SBQQ__MasterContract__c );
                    mapOfOppIDWithContractID.put(qtLine.SBQQ__Quote__r.SBQQ__Opportunity2__c, qtLine.SBQQ__Quote__r.SBQQ__MasterContract__c );
                }
                if(!mapofQuoteLines.containsKey(qtLine.ID))
                    mapofQuoteLines.put(qtLine.ID, qtLine.SBQQ__Quote__r.SBQQ__Opportunity2__c);
                mapofQuoteLines.put(qtLine.ID, qtLine.SBQQ__Quote__r.SBQQ__Opportunity2__c);
            }

            //Size check for map "mapofQuoteLines"
            if(mapofQuoteLines.size() > 0){

                //Loop on Contract
                for(Contract cont : [Select ID, SBQQ__Opportunity__c From Contract where SBQQ__Opportunity__c IN: mapofQuoteLines.values()]){
                    
                    if(!mapOfOppIDWithContractID.containsKey(cont.SBQQ__Opportunity__c))
                        mapOfOppIDWithContractID.put(cont.SBQQ__Opportunity__c, cont.ID);
                    mapOfOppIDWithContractID.put(cont.SBQQ__Opportunity__c, cont.ID);  
                }
            
                //size check for map "mapOfOppIDWithContractID"
                if(mapOfOppIDWithContractID.size() > 0){
                    
                    //Loop on new asset
                    for(Asset ast : assets){
                        
                        // contains check in  map "mapofQuoteLines" 
                        if(mapofQuoteLines.containsKey(ast.SBQQ__QuoteLine__c)){
                            bypassAssetTrigger = true;
                            
                            ast.Contract__c = mapOfOppIDWithContractID.containsKey(mapofQuoteLines.get(ast.SBQQ__QuoteLine__c)) ? mapOfOppIDWithContractID.get(mapofQuoteLines.get(ast.SBQQ__QuoteLine__c)) : '';
                        }
                    }
                }
            }
        }
    }

    //Bypass Variable
    public static Boolean By_Pass_SubscriptionTrigger = false;
    
    public static void updateAmountOnContract(List<Asset> assets){

        //Set to hold the contract ID
        Set<ID> contractIds = new Set<ID>();

        //Loop on new Asset
        for(Asset ast : assets){

            //Necessary Checks
            if(ast.Contract__c != null)
                contractIds.add(ast.Contract__c); 
        }

        //Size Check 
        if(contractIds.size() > 0){
            
            //List of contract to update
            List<Contract> contractToBeUpdate = new List<Contract>();
            
            //Map to hold the contractID with productName and its ACV amount
            Map<ID, Decimal> mapOfContractWithOneTimeAmount = new Map<ID, Decimal>();


            //Query on asset
            for(Asset ast : [SELECT Related_Quote__c, Contract__c, Price, Quantity FROM Asset Where Contract__c IN: contractIds  ]){
                
                if(!mapOfContractWithOneTimeAmount.containsKey(ast.Contract__c))
                    mapOfContractWithOneTimeAmount.put(ast.Contract__c, 0.0);
                    Decimal oneTimeAmount = (ast.Price * ast.Quantity) + (mapOfContractWithOneTimeAmount.containsKey(ast.Contract__c) ? (mapOfContractWithOneTimeAmount.get(ast.Contract__c) != null ? mapOfContractWithOneTimeAmount.get(ast.Contract__c) : 0 ) : 0);
                mapOfContractWithOneTimeAmount.put(ast.Contract__c, oneTimeAmount);
            }

            //Size check for Map "mapOfContractWithOneTimeAmount"
            if(mapOfContractWithOneTimeAmount.size() > 0){
                
                for(Id contID : mapOfContractWithOneTimeAmount.keyset()){
                    Contract cont = new Contract();
                    cont.ID = contID;
                    cont.One_Time_Services__c = mapOfContractWithOneTimeAmount.containsKey(contID) ? mapOfContractWithOneTimeAmount.get(contID) : 0.0;
                    contractToBeUpdate.add(cont);
                }
            }

            //Size check for the list
            if(contractToBeUpdate.size() > 0)
                update contractToBeUpdate;
        }
    }

}