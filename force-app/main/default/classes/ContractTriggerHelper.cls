/** 
*    Description     :      This class is used as a helper of the contract trigger
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      09/09/2019
* 
*    Revision Logs   :      V_1.0 - Created
* 
*                      
**/
public with sharing class ContractTriggerHelper {
    
    
    /*
    * Description   :  This method is used to update the Order field.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/16/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateOrder(List<Contract> contracts, Map<Id, Contract> mapOfContracts){

        //Set to hold the ID of the Opportunity
        Set<String> opportunityIds = new Set<String>();

        //Loop on contract
        for(Contract cont : contracts){
            
            //Check for the Order and Opportunity
            if(cont.SBQQ__Order__c == null && cont.SBQQ__Opportunity__c != null && (mapOfContracts == null || mapOfContracts.get(cont.Id).SBQQ__Opportunity__c != cont.SBQQ__Opportunity__c)){
                opportunityIds.add(cont.SBQQ__Opportunity__c);
            }
        }

        //Size check "opportunityIds"
        if(opportunityIds.size() > 0){
            
            //Map to hold the Order with its 
            Map<String, Order> mapOfOrderWithOpportunityId = new Map<String, Order>();
            for(Order od : [Select ID, OpportunityId From Order Where OpportunityId IN: opportunityIds]){
                if(!mapOfOrderWithOpportunityId.containsKey(od.OpportunityId))
                    mapOfOrderWithOpportunityId.put(od.OpportunityId, new Order());
                mapOfOrderWithOpportunityId.put(od.OpportunityId, od);      
            }

            //size check for map "mapOfOrderWithOpportunityId" 
            if(mapOfOrderWithOpportunityId.size() > 0){
                
                //Loop on Contract
                for(Contract cont : contracts){
                    cont.SBQQ__Order__c = mapOfOrderWithOpportunityId.containsKey(cont.SBQQ__Opportunity__c) ? mapOfOrderWithOpportunityId.get(cont.SBQQ__Opportunity__c).Id : '';
                }
            }
        }
    }
    
    /*
    * Description   :  This method is used to update the order status to activated.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/16/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateOrderStatus(List<Contract> contracts, Map<Id, Contract> mapOfContract){

        //Set to hold the order ID
        Set<String> orderIds = new Set<String>();

        //Loop on Contracts
        for(Contract cont : contracts){

            //Necessary Condition
            if(cont.SBQQ__Order__c != null && cont.Status == 'Activated' &&  mapOfContract != null && cont.Status != mapOfContract.get(cont.Id).Status){
                
                orderIds.add(cont.SBQQ__Order__c);
            }
        }
        //Size Check "cont.SBQQ__Order__c"
        if(orderIds.size() > 0){
            
            //List to update Order
            List<Order> ordersToBeUpdate = new List<Order>();

            //Loop on the Order
            for(Order ord : [Select ID, Status From Order Where ID IN: orderIds AND Status != 'Activated']){
                ordersToBeUpdate.add(New Order(ID = ord.ID, Status = 'Activated'));
            }

            //Size Check "ordersToBeUpdate"
            if(ordersToBeUpdate.size() > 0){
                update ordersToBeUpdate;
            }
        }
    }

    /*
    * Description   :  This method is used to update the master contract if the Opportunity is new business.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/16/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateMasterContract(List<Contract> contracts, Map<Id, Contract> mapOfContract){

        //Set to hold the Opportunity ID's
        Set<String> oppIds = new Set<String>(); 

        //Loop on the new Contract
        for(Contract cont : contracts){
            
            //Necessary Condition checks
            if(cont.SBQQ__Opportunity__c != null && cont.SBQQ__MasterContract__c == false){
                oppIds.add(cont.SBQQ__Opportunity__c);
            }
        }
        //Size Check
        if(oppIds.size() > 0){
            
            Map<Id, Opportunity> mapOfOpportunity = new Map<ID, Opportunity>([Select ID, Type, (Select ID From SBQQ__Contracts__r Where SBQQ__MasterContract__c= true) From Opportunity Where ID IN: oppIds]);
            
            //Size Check map
            if(mapOfOpportunity.size() > 0 ){
                
                //Loop on the new Contract
                for(Contract cont : contracts){
                    
                    //Necessary Checks
                    if(cont.SBQQ__Opportunity__c != null && mapOfOpportunity.containsKey(cont.SBQQ__Opportunity__c) && mapOfOpportunity.get(cont.SBQQ__Opportunity__c).SBQQ__Contracts__r.size() == 0 && mapOfOpportunity.get(cont.SBQQ__Opportunity__c).Type == 'New Business'){
                        cont.SBQQ__MasterContract__c = true;
                    }
                }
            }
        }
    }

    /*
    * Description   :  This method is used to update ContractNumber on the order.
    *
    * Created By    :   Akshay Bagrecha
    *
    * Created Date  :   09/26/2019
    *
    * Version       :   V1.0 Created
    *             
    */
    public static void updateContractNumberOnOrder(List<Contract> contracts, Map<ID, Contract> mapOfContract ){

        //Order list to update
        List<Order> orderToBeUpdated = new List<Order>();

        //To hold the order ID
        Set<String> orderIds = new Set<String>();

        //Loop on the new Contract
        for(Contract cont : contracts){

            //Necessary Checks
            if(cont.SBQQ__Order__c != null && (mapOfContract == null || mapOfContract.get(cont.ID).SBQQ__Order__c != cont.SBQQ__Order__c))
                orderIds.add(cont.SBQQ__Order__c);
                    
        }
        system.debug('orderIds--'+orderIds);
        //Size Check for set "orderIds"
        if(orderIds.size() > 0){
            // Map to hold the Order
            Map<ID, Order> mapOfOrder = new Map<ID, Order>([Select ID, ContractId From Order WHere ID IN: orderIds]);
            system.debug('mapOfOrder--'+mapOfOrder);

            //Size Check for map "mapOfOrder"
            if(mapOfOrder.size() > 0){

                  //Loop on the new Contract
                for(Contract cont : contracts){
                    system.debug('cont.SBQQ__Order__c--'+cont.SBQQ__Order__c+'mapOfOrder.containsKey(cont.SBQQ__Order__c)--'+mapOfOrder.containsKey(cont.SBQQ__Order__c)+'mapOfOrder.get(cont.SBQQ__Order__c).ContractId=='+mapOfOrder.get(cont.SBQQ__Order__c).ContractId+'cont.ID--');
                    if(cont.SBQQ__Order__c != null && mapOfOrder.containsKey(cont.SBQQ__Order__c) && mapOfOrder.get(cont.SBQQ__Order__c).ContractId == null || (mapOfOrder.get(cont.SBQQ__Order__c).ContractId != null && mapOfOrder.get(cont.SBQQ__Order__c).ContractId != cont.ID)){
                        orderToBeUpdated.add(new Order(ID = cont.SBQQ__Order__c, ContractId = cont.ID));
                    }
                }
            }
            system.debug('orderToBeUpdated--'+orderToBeUpdated);
            //Size Check for list "orderToBeUpdated" 
            if(orderToBeUpdated.size() > 0 )
                update orderToBeUpdated;
        }    
    }
}