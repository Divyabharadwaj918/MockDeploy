trigger RKIndustryTranslatorL on Lead (before insert) {

for (Lead a : Trigger.new) {

if (a.Translate_RK_Industry__c=='Yes') {
List <RK_Industry_Translation__c> b = new list <RK_Industry_Translation__c> ([Select id, name, Agriculture__c,  Banking__c, Biotech_and_Pharmaceuticals__c, Basic_Materials_and_Chemicals__c,   Construction__c,    Colleges__c,    Education_Services__c,  Alternative_Energy__c,  Oil_and_Gas__c, Environmental_Services_Equipment__c,    Brokerage_and_Asset_Management__c,  Financial_Services__c,  Real_Estate__c, Beverages__c,   Food__c,    Aerospace_and_Defense__c,   State_And_Local_Government__c,  Government_Contractors__c,  Hospitals_and_Healthcare_Providers__c,  Managed_Care__c,    Medical_Devices__c, Hotels__c,  Restaurants__c, Insurance__c,   Consumer_Products_Manufacturers__c, Industrial_Manufacturing_and_Machinery__c,  Media__c,   Associations__c,    Charitable_Organizations__c,    Cultural_and_Religious_Institutions__c, Foundations__c, Foundations_and_Charitable_Organizations__c,    Metals_Mining__c,   Business_Services__c,   Consumer_Services__c,   Law_Firms__c,   Security_Products_Services__c,  Retail__c,  Computer_Hardware__c,   Computer_Services__c,   Computer_Software__c,   Electronics__c, Hosting_Provider__c,    Telecommunications_Equipment__c,    Telecommunications_Services__c, Automotive_Transport__c,    Transportation__c,  Utilities__c
 from RK_Industry_Translation__c limit 1]);

if (b.size() > 0) {

if (a.RK_Industry__c=='Agriculture') {a.Industry=b[0].Agriculture__c;}
if (a.RK_Industry__c=='Banking') {a.Industry=b[0].Banking__c;}
if (a.RK_Industry__c=='Biotech and Pharmaceuticals') {a.Industry=b[0].Biotech_and_Pharmaceuticals__c;}
if (a.RK_Industry__c=='Basic Materials and Chemicals') {a.Industry=b[0].Basic_Materials_and_Chemicals__c;}
if (a.RK_Industry__c=='Construction') {a.Industry=b[0].Construction__c;}
if (a.RK_Industry__c=='Colleges') {a.Industry=b[0].Colleges__c;}
if (a.RK_Industry__c=='Education Services') {a.Industry=b[0].Education_Services__c;}
if (a.RK_Industry__c=='Alternative Energy') {a.Industry=b[0].Alternative_Energy__c;}
if (a.RK_Industry__c=='Oil and Gas') {a.Industry=b[0].Oil_and_Gas__c;}
if (a.RK_Industry__c=='Environmental Services & Equipment') {a.Industry=b[0].Environmental_Services_Equipment__c;}
if (a.RK_Industry__c=='Brokerage and Asset Management') {a.Industry=b[0].Brokerage_and_Asset_Management__c;}
if (a.RK_Industry__c=='Financial Services') {a.Industry=b[0].Financial_Services__c;}
if (a.RK_Industry__c=='Real Estate') {a.Industry=b[0].Real_Estate__c;}
if (a.RK_Industry__c=='Beverages') {a.Industry=b[0].Beverages__c;}
if (a.RK_Industry__c=='Food') {a.Industry=b[0].Food__c;}
if (a.RK_Industry__c=='Aerospace & Defense') {a.Industry=b[0].Aerospace_and_Defense__c;}
if (a.RK_Industry__c=='State and Local Government') {a.Industry=b[0].State_And_Local_Government__c;}
if (a.RK_Industry__c=='Government Contractors') {a.Industry=b[0].Government_Contractors__c;}
if (a.RK_Industry__c=='Hospitals and Healthcare Providers') {a.Industry=b[0].Hospitals_and_Healthcare_Providers__c;}
if (a.RK_Industry__c=='Managed Care') {a.Industry=b[0].Managed_Care__c;}
if (a.RK_Industry__c=='Medical Devices') {a.Industry=b[0].Medical_Devices__c;}
if (a.RK_Industry__c=='Hotels') {a.Industry=b[0].Hotels__c;}
if (a.RK_Industry__c=='Restaurants') {a.Industry=b[0].Restaurants__c;}
if (a.RK_Industry__c=='Insurance') {a.Industry=b[0].Insurance__c;}
if (a.RK_Industry__c=='Consumer Products Manufacturers') {a.Industry=b[0].Consumer_Products_Manufacturers__c;}
if (a.RK_Industry__c=='Industrial Manufacturing and Machinery') {a.Industry=b[0].Industrial_Manufacturing_and_Machinery__c;}
if (a.RK_Industry__c=='Media') {a.Industry=b[0].Media__c;}
if (a.RK_Industry__c=='Associations') {a.Industry=b[0].Associations__c;}
if (a.RK_Industry__c=='Charitable Organizations') {a.Industry=b[0].Charitable_Organizations__c;}
if (a.RK_Industry__c=='Cultural and Religious Institutions') {a.Industry=b[0].Cultural_and_Religious_Institutions__c;}
if (a.RK_Industry__c=='Foundations') {a.Industry=b[0].Foundations__c;}
if (a.RK_Industry__c=='Foundations and Charitable Organizations') {a.Industry=b[0].Foundations_and_Charitable_Organizations__c;}
if (a.RK_Industry__c=='Metals & Mining') {a.Industry=b[0].Metals_Mining__c;}
if (a.RK_Industry__c=='Business Services') {a.Industry=b[0].Business_Services__c;}
if (a.RK_Industry__c=='Consumer Services') {a.Industry=b[0].Consumer_Services__c;}
if (a.RK_Industry__c=='Law Firms') {a.Industry=b[0].Law_Firms__c;}
if (a.RK_Industry__c=='Security Products & Services') {a.Industry=b[0].Security_Products_Services__c;}
if (a.RK_Industry__c=='Retail') {a.Industry=b[0].Retail__c;}
if (a.RK_Industry__c=='Computer Hardware') {a.Industry=b[0].Computer_Hardware__c;}
if (a.RK_Industry__c=='Computer Services') {a.Industry=b[0].Computer_Services__c;}
if (a.RK_Industry__c=='Computer Software') {a.Industry=b[0].Computer_Software__c;}
if (a.RK_Industry__c=='Electronics') {a.Industry=b[0].Electronics__c;}
if (a.RK_Industry__c=='Hosting Provider') {a.Industry=b[0].Hosting_Provider__c;}
if (a.RK_Industry__c=='Telecommunications Equipment') {a.Industry=b[0].Telecommunications_Equipment__c;}
if (a.RK_Industry__c=='Telecommunications Services') {a.Industry=b[0].Telecommunications_Services__c;}
if (a.RK_Industry__c=='Automotive & Transport') {a.Industry=b[0].Automotive_Transport__c;}
if (a.RK_Industry__c=='Transportation') {a.Industry=b[0].Transportation__c;}
if (a.RK_Industry__c=='Utilities') {a.Industry=b[0].Utilities__c;}

}
}

}
}