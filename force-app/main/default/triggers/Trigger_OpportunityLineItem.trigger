/*
* Description   :   Trigger will fire on before insert
*
* Created By    :   Akshay Bagrecha
*
* Created Date  :   05/01/2019
*
* Version       :   V1.0 Created
*				:	V1.1 Updated By Akshay Bagrecha 07/18/2019
*             
*/
trigger Trigger_OpportunityLineItem on OpportunityLineItem (before insert, before update) {
    
    
    //Try catch
    try{
	    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
	    
	        //Trigger helper method calling
	        OpportunityLineItemTriggerHelper.updateProductFamily(Trigger.new, Trigger.oldMap);
	        OpportunityLineItemTriggerHelper.updateACVFromQL(Trigger.new, Trigger.oldMap);  
	    }
    }
    catch(Exception excpt){
    	System.debug(excpt.getMessage()+'   :'+ excpt.getLineNumber());
    }
}