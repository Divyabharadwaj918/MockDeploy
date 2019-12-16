/**
* @author Pratibh Prakash
* @date 25-Aug-2017
* @description Wrapper class for Account Wrapper
* @last modified by 
*/
public class AccountReportWrapper {
    
    @AuraEnabled
    public Account accountObj{get;set;}
    @AuraEnabled
    public List<Boolean> liveCountries{get;set;}
    @AuraEnabled
    public List<CountryStatusWrapper> countryStatusList{get;set;}
    
    public AccountReportWrapper(){
    	liveCountries = new List<Boolean>();
    	countryStatusList = new List<CountryStatusWrapper>();
    }
    
    public class CountryStatusWrapper{
    	@AuraEnabled
    	public String country{get;set;}
    	@AuraEnabled
    	Boolean display{get;set;}
    	@AuraEnabled
    	public Boolean isLive{get;set;}
    	@AuraEnabled
    	public Boolean isImplementation{get;set;}
    	@AuraEnabled
    	public Boolean isRoadmapped{get;set;}    	
    	@AuraEnabled
    	public Boolean isFuture{get;set;}
    	
    	public CountryStatusWrapper(){
    		display = true;
    		isLive = false;
    		isRoadmapped = false;
    		isImplementation = false;
    		isFuture = false;
    	}
    }
}