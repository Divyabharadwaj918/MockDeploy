/**
* @author Pratibh Prakash
* @date 20-Mar-2017
* @description Utility Class contains methods for partner sync between Opportunity and Sales Service Request.
* @last modified by 
*/
public class SalesServiceRequestHelper {
	
	//array of seven boolean indicating working days, Monday is index 0
	private static final List<Boolean> isWorkingDay;
	//count of the number of working days in the array
	private static final Integer workingDaysInWeek;
	private static final Date monday = Date.newInstance(1900, 1, 3);
	static {
	    //my real implementation uses the Salesforce BusinessHours Object to populate this array
	    isWorkingDay = new List<Boolean> { true, true, true, true, true, false, false };
	    //You will have real problems if this number does not match the number of true flags in the array
	    workingDaysInWeek = 5;
	}
	
    /*
    * Method to copy partners from Opportunity to Sales Service Request
    */
    public static void copyPartnersFromOpportunity(Set<Id> salesServiceRequestIds){
    	
    	Sales_Service_Request__c[] requestList = [Select Id, Opportunity__c, Opportunity__r.AccountId 
    												from Sales_Service_Request__c 
    												where Id in:salesServiceRequestIds];
    	
    	Set<Id> opportunityIds = new Set<Id>();
    	Set<Id> accountIds = new Set<Id>();
    	
    	for(Integer i=0; i<requestList.size(); i++){
    		opportunityIds.add(requestList[i].Opportunity__c);
    		accountIds.add(requestList[i].Opportunity__r.AccountId);
    	}
    	
    	AccountPartner[] opportunityPartnerList = [Select Role, OpportunityId, IsPrimary, AccountToId, AccountFromId
    												From AccountPartner
    												where OpportunityId in: opportunityIds
    												and AccountFromId in: accountIds];
    												
    												
    												
    	Map<String,List<AccountPartner>> opportunityPartnersMap = new Map<String,List<AccountPartner>>();
    	
    	for(Integer i=0; i<opportunityPartnerList.size(); i++){
    		if(!opportunityPartnersMap.containsKey(opportunityPartnerList[i].OpportunityId)){
    			opportunityPartnersMap.put(opportunityPartnerList[i].OpportunityId, new List<AccountPartner>());
    		}
    		opportunityPartnersMap.get(opportunityPartnerList[i].OpportunityId).add(opportunityPartnerList[i]);
    	}
    	
    	List<Sales_Service_Partners__c> salesServicePartnerForInsert = new List<Sales_Service_Partners__c>();
    	
    	for(Integer i=0; i<requestList.size(); i++){
    		if(opportunityPartnersMap.get(requestList[i].Opportunity__c)!=null){
    			for(AccountPartner partnerObj: opportunityPartnersMap.get(requestList[i].Opportunity__c)){
    				Sales_Service_Partners__c tempRecord = new Sales_Service_Partners__c();
	    			tempRecord.Sales_Service_Request__c = requestList[i].Id;
	    			tempRecord.Partner__c = partnerObj.AccountToId;
	    			tempRecord.Primary__c = partnerObj.IsPrimary;
	    			tempRecord.Role__c = partnerObj.Role;
	    			salesServicePartnerForInsert.add(tempRecord);
    			}	    		
    		} 
    	}
    	
    	if(salesServicePartnerForInsert.size()>0){
    		insert salesServicePartnerForInsert;
    	}
    }
    
    public static Boolean IsWeekendDay(Date dateParam){
		boolean result = false;
		//Recover the day of the week
		Date startOfWeek = dateParam.toStartOfWeek();
		Integer dayOfWeek = startOfWeek.daysBetween(dateParam);
		result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
		return result;
   	} 
   
   
	public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd ){
		//Add or decrease in BusinessDaysToAdd days 
      	Date finalDate = StartDate;
      	system.debug('finaldate = '+finalDate);
      	integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
      	system.debug('direction = '+direction);
       	while(BusinessDaysToAdd != 0){
			finalDate = finalDate.AddDays(direction);
           	system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);            
           	system.debug('finaldate = '+finalDate);
           	if (!isWeekendDay(finalDate)){
				BusinessDaysToAdd -= direction;
           	}
       	}
		return finalDate;
   	}
   	
   	public static Map<Id,RecordType> retrieveRecordTypes(String objectName){
   		Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([Select SobjectType, Name, IsActive, Id 
   												From RecordType 
   												where SobjectType =:objectName]);
   		
   		return recordTypeMap;
   	}
   		
	private static Integer getDayOfWeek(Date value) {
	    return Math.mod(monday.daysBetween(value), 7);
	}
	
	public static Integer getWorkingDays(Date startDate, Date endDate) {
	    //save some calculations when the number of working days is 0
	    if(workingDaysInWeek == 0 || startDate == null || endDate == null) {
	        return 0;
	    } else {
	        Integer difference = startDate.daysBetween(endDate);
	        if(difference == 0) {
	            //If the 2 dates are the same day check if the day is a working day or not
	            return isWorkingDay[getDayOfWeek(startDate)] ? 1 : 0;
	        } else if(workingDaysInWeek == 7) {
	            //when every day is a working day return the difference
	            return difference;
	        } else {
	            //The guts of the solution
	            Integer wholeWeeks = Math.floor(difference / 7).intValue();
	            Integer workingDays = wholeWeeks * workingDaysInWeek;
	            Integer dayOfWeek = getDayOfWeek(endDate);
	            for(Integer remainder = Math.mod(difference, 7); remainder >= 0; remainder--) {
	                if(isWorkingDay[dayOfWeek]) {
	                    workingDays++;
	                }
	                dayOfWeek--;
	                if(dayOfWeek < 0) {
	                    dayOfWeek = 6;
	                }
	            }
	            return workingDays;
	        }
	    }
	}
}