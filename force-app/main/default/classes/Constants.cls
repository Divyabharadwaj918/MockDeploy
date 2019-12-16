/** 
*    Description     :      This class is used to hold the all constant values
*
*    Created By      :      Akshay Bagrecha
*
*    Created Date    :      05/04/2019
* 
*    Revision Logs   :      V_1.0 - Created
*                      
**/
public without sharing class Constants {

	public static final String MANAGED_ONBOARDING_NAME = 'Managed Onboarding';
    public static final String MANAGED_ONBOARDING_CODE = 'MO';
	public static final String INVOICE_COMPLIANCE_NAME = 'Invoice Compliance';
    public static final String INVOICE_COMPLIANCE_CODE = 'IC';
	public static final String PAY_PRODUCT = 'Pay';
	public static final String SUBCONTRACTOR_PRODUCT = 'Subcontractor';
	public static final String PLATFORM_PRODUCT = 'Platform';
	public static final String PLATFORM_PRODUCT_CODE = 'PLATFORM PLUS';
	public static final String BUY_PRODUCT = 'Buy';
	public static final String CORE_ESSENTIALS_EDITION = 'Core Essentials Edition';
	public static final String BUSINESS_EDITION = 'Business Edition';
	public static final String BUSINESS_EDITION_PLUS = 'Business Edition Plus';
	public static final String DYNAMIC_DISCOUNTING_NAME = 'Dynamic Discounting';
    public static final String DYNAMIC_DISCOUNTING_CODE = 'DD';
    public static final String PAY_CORE_ESSENTIAL_1_NAME = 'Pay Core Essentials Tier 1';
    public static final String PAY_CORE_ESSENTIAL_1_CODE = 'PAY CORE Tier 1';
    public static final String SCANNING_SERVICES_NAME = 'Scanning Services';
    public static final String SCANNING_SERVICES_CODE = 'SS';
    
    //One time implementation fees product
    public static final String PROFESSIONAL_SERVICES_ADVISOR_MILESTONE = 'Professional Services - Advisor Milestone';
    public static final String PROFESSIONAL_SERVICES_ADVISOR_MILESTONE_CODE = 'IMP2';
    
    public static final String PROFESSIONAL_SERVICES_STANDARD_MILESTONE = 'Professional Services - Standard Milestone';
    public static final String PROFESSIONAL_SERVICES_STANDARD_MILESTONE_CODE = 'IMP';

    //Compliance Type Name
    public static final String COMP_REGULAR_POST_AUDIT = 'Regular Post-audit';
    public static final String COMP_POST_AUDIT_INDIA = 'Post-audit India';
    public static final String COMP_CLEARANCE_ITALY = 'Clearance Italy';
    public static final String COMP_CLEARANCE_TURKEY = 'Clearance Turkey';
    public static final String COMP_CLEARANCE_ARGENTINA = 'Clearance Argentina';
    public static final String COMP_REST_OF_LATIN_AMERICA = 'Clearance Rest of Latin America';
    public static final String COMP_CHINA_GTS = 'China GTS';
    
    
    //Method for thr Currency Symbol
    public static String getCurrencySymbolFromIso(String Iso) {
         String currencySymbol = 
           ('USD' == Iso ? '$' : 
           ('CHF' == Iso ? 'SFr.' : 
           ('CNY' == Iso ? '¥' : 
           ('DKK' == Iso ? 'Kr.' : 
           ('EUR' == Iso ? '€' : 
           ('GBP' == Iso ? '£' : 
           ('JPY' == Iso ? '¥' :
           ('NOK' == Iso ? 'kr' :
           ('SEK' == Iso ? 'kr' : 
           Iso)))))))));
           return currencySymbol;
    }
}