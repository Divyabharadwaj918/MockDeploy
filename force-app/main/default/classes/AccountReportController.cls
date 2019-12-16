/**
* @author Pratibh Prakash
* @date 25-Aug-2017
* @description Controller class for Account Report
* @last modified by 
*/
public with sharing class AccountReportController {
	
	@AuraEnabled 
    public static List<String> retrieveCountries(){ 
    	Set<String> countries = new Set<String>();
    	Account[] accountList = [Select Id, Type, Live_Countries__c, Implementation_Countries__c, Road_mapped_Countries__c, Future_Interest_Countries__c, Products_in_Use__c, Account_Status__c
									from Account 
									where Type='Enterprise Customer' 
									and (Account_Status__c='Live Customer' or Account_Status__c='In-Flight Customer')
									and (Live_Countries__c!=null or Implementation_Countries__c!=null or Road_mapped_Countries__c!=null or Future_Interest_Countries__c!=null)];
		
		for(Integer i=0; i<accountList.size(); i++){
			if(accountList[i].Live_Countries__c!=null) countries.addAll(accountList[i].Live_Countries__c.split(';'));
			if(accountList[i].Implementation_Countries__c!=null) countries.addAll(accountList[i].Implementation_Countries__c.split(';'));
			if(accountList[i].Road_mapped_Countries__c!=null) countries.addAll(accountList[i].Road_mapped_Countries__c.split(';'));
			if(accountList[i].Future_Interest_Countries__c!=null) countries.addAll(accountList[i].Future_Interest_Countries__c.split(';'));
		}
		
		List<String> tempList = new List<String>();
		tempList.addAll(countries);
		tempList.sort();
		return tempList;
    }
    
    @AuraEnabled
    public static List<AccountReportWrapper> retrieveAccounts(List<String> countries){ 
    	countries.sort();
    	Set<String> countriesSet = new Set<String>();
    	countriesSet.addAll(countries);
    	Set<String> tempSet_Live = new Set<String>();
    	Set<String> tempSet_Implementation = new Set<String>();
    	Set<String> tempSet_Roadmapped = new Set<String>();
    	Set<String> tempSet_Future = new Set<String>();
    	
    	Account[] accountList = [Select Id, Name, Type, Live_Countries__c, Implementation_Countries__c, Road_mapped_Countries__c, Future_Interest_Countries__c, Products_in_Use__c
									from Account 
									where Type='Enterprise Customer'
									and (Account_Status__c='Live Customer' or Account_Status__c='In-Flight Customer')
									and (Live_Countries__c!=null or Implementation_Countries__c!=null or Road_mapped_Countries__c!=null or Future_Interest_Countries__c!=null)
									order by Name ASC];
		
		List<AccountReportWrapper> wrapperList = new List<AccountReportWrapper>();
		for(Integer i=0; i<accountList.size(); i++){
			AccountReportWrapper tempObj = new AccountReportWrapper();
			tempObj.accountObj = accountList[i];
			
			tempSet_Live.clear();
			if(accountList[i].Live_Countries__c!=null)tempSet_Live.addAll(accountList[i].Live_Countries__c.split(';'));
			
			tempSet_Implementation.clear();			
			if(accountList[i].Implementation_Countries__c!=null)tempSet_Implementation.addAll(accountList[i].Implementation_Countries__c.split(';'));
			
			tempSet_Roadmapped.clear();			
			if(accountList[i].Road_mapped_Countries__c!=null)tempSet_Roadmapped.addAll(accountList[i].Road_mapped_Countries__c.split(';'));
			
			tempSet_Future.clear();
			if(accountList[i].Future_Interest_Countries__c!=null)tempSet_Future.addAll(accountList[i].Future_Interest_Countries__c.split(';'));
						
			for(String country: countries){
				AccountReportWrapper.CountryStatusWrapper statusWrpTemp = new AccountReportWrapper.CountryStatusWrapper();
				statusWrpTemp.country = country;
				if(tempSet_Live.contains(country)){
					statusWrpTemp.isLive = true;					
				}
				if(tempSet_Implementation.contains(country)){
					statusWrpTemp.isImplementation = true;					
				}
				if(tempSet_Roadmapped.contains(country)){
					statusWrpTemp.isRoadmapped = true;					
				}
				if(tempSet_Future.contains(country)){
					statusWrpTemp.isFuture = true;					
				}							
				tempObj.countryStatusList.add(statusWrpTemp);	
			}
			wrapperList.add(tempObj);
		}
    	return wrapperList;
    }
    
    @AuraEnabled 
    public static Map<String,ISO_Countries__c> retrieveCountriesCodes(){ 
    	Map<String,ISO_Countries__c> countryCodeMap = new Map<String,ISO_Countries__c>();
    	ISO_Countries__c[] countryCodes =  [Select Name, ISO_2_Char_Code__c, ISO_3_Char_Code__c 
    										from ISO_Countries__c];
    	
    	for(Integer i=0; i<countryCodes.size(); i++){
    		countryCodeMap.put(countryCodes[i].Name, countryCodes[i]);
    	}
    	return countryCodeMap;
    }    
    
    
}