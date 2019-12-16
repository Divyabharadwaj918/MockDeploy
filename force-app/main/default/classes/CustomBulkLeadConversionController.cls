/**
*    Description     :        This controller Class is used to Convert similiar Lead records in bulk.
*
*    Created By      :        
*
*    Created Date    :        27/08/2019
*
*    Revision Logs   :        V_1.0 - Created
*                      
**/
public class CustomBulkLeadConversionController {
    
    @AuraEnabled
    public static WrapObjects convertLeads(String RecordId){
        WrapObjects data = new WrapObjects();
        try{
            if(RecordId != null && RecordId instanceof Id){
                
                Id userId =UserInfo.getUserId();
                Map<Id,Lead> mapLead =new Map<Id,Lead> ([Select Id, FirstName , LastName, TS_ID__c,Phone, Email, Company, title,buyer__c, Buyer__r.Name from Lead where Id =: RecordId limit 1]);
                
                Id recordTypeIdAcc = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Account' AND IsActive = true LIMIT 1].Id;
                Id recordTypeIdCon = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Contact' AND IsActive = true LIMIT 1].Id;
                Id recordTypeIdOpp = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Opportunity' AND IsActive = true LIMIT 1].Id;
                
                // Map<Id,Lead> mapLead = new Map<Id,Lead>();//{currentLead[0].Id => CurrentLead[0]};
                Set<Id> LeadId = new Set<Id>{RecordId};
                    Boolean accFound = false;
                
                List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
                if(Datacloud.FindDuplicates.findDuplicates(mapLead.values()).size()>0 && Datacloud.FindDuplicates.findDuplicates(mapLead.values())[0].getDuplicateResults().size() >0
                  && Datacloud.FindDuplicates.findDuplicates(mapLead.values())[0].getDuplicateResults()[0].getMatchResults().size()> 0)
                    for(Datacloud.MatchRecord matchrecord :(Datacloud.FindDuplicates.findDuplicates(mapLead.values())[0].getDuplicateResults()[0].getMatchResults()[0].getMatchRecords() )){
                        
                        system.debug(matchrecord.getRecord());
                        LeadId.add(matchrecord.getRecord().Id);
                        
                    }
                
                if(LeadId.size() >0)
                    for(Lead leaddata :[Select Id, FirstName , LastName, TS_ID__c,Phone, Email, Company,Recordtype.Name, title,buyer__c, Buyer__r.Name from Lead where Id IN : LeadId ]){
                        if( !mapLead.containsKey(leaddata.Id) && leaddata.Recordtype.Name =='Seller Sales')
                            mapLead.put(leaddata.Id, leaddata);
                    }
                
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                
                
                
                if(String.isNotBlank(mapLead.get(RecordId).TS_ID__c)){
                    List<Account> acc  = [Select Id, Name, type, phone, website, Owner.Name, Client_Executive__r.Name  From Account Where TS_ID__c = :mapLead.get(RecordId).TS_ID__c LIMIT 1];
                    if(acc != null && acc.size() > 0){
                        accFound = true;
                        data.acc = acc[0];
                        
                        //checking for contact record.
                        List<contact> con = [Select Id, RecordTypeId, FirstName,LastName, Title, Account.Name, Phone, Email, MobilePhone From Contact 
                                             Where AccountId = :acc[0].Id AND Phone =: mapLead.get(RecordId).Phone AND Email =: mapLead.get(RecordId).Email AND FirstName =: mapLead.get(RecordId).FirstName AND LastName =: mapLead.get(RecordId).LastName LIMIT 1];
                        
                        if(con != null && con.size() > 0){
                            data.con = con[0];
                        }
                        
                    }
                }
                if(accFound == false){
                    Account newAccount = new Account();
                    newAccount.Name = mapLead.get(RecordId).Company;
                    newAccount.RecordTypeId = recordTypeIdAcc;
                    newAccount.Is_Seller__c = true;
                    insert newAccount;
                    system.debug(newAccount);
                    data.acc = newAccount; 
                }
                if(data.con == null){
                    Contact newcon = new Contact();
                    newcon.FirstName = mapLead.get(RecordId).FirstName;
                    newcon.LastName  = mapLead.get(RecordId).LastName;
                    newcon.Email = mapLead.get(RecordId).Email;
                    newcon.Title = mapLead.get(RecordId).Title;
                    newcon.Phone = mapLead.get(RecordId).Phone;
                    newcon.RecordTypeId =recordTypeIdCon;
                    newcon.AccountId =data.acc.Id;
                    Database.DMLOptions dml = new Database.DMLOptions();
                    dml.DuplicateRuleHeader.AllowSave = true;
                    Database.insert(newcon, dml);
                    data.con = newcon;
                }
                for(ID str: mapLead.keySet()){
                    
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(str);
                    lc.convertedStatus = 'Qualified';
                    lc.setAccountId(data.acc.Id);
                    lc.setContactId(data.con.Id);
                    lc.setOwnerId(userId);
                    lc.setOpportunityName(mapLead.get(str).Company+' - '+mapLead.get(str).Buyer__r.Name);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    leadConverts.add(lc);
                    system.debug(lc);
                }
                Database.DMLOptions dml = new Database.DMLOptions();
                    dml.DuplicateRuleHeader.AllowSave = true;
                Database.LeadConvertResult[] lcrList = Database.convertLead(leadConverts,dml);
                Set<Id> opportunityId = new Set<Id>();
                List<OpportunityWrapper>wrapperdata =new List<OpportunityWrapper>();
                for(Database.LeadConvertResult lcr :lcrList){
                    OpportunityWrapper opWrap = new OpportunityWrapper();
                    if(lcr.isSuccess()){
                        //update the record type of account, contact and opportunity record.
                        opportunityId.add(lcr.getOpportunityId());
                        data.message ='Lead is converted successfully';
                    }
                    else
                    {
                        opWrap.leadId= lcr.getLeadId();
						
                       opWrap.error =lcr.getErrors() ;
                    }
                    wrapperdata.add(opWrap);
                }
                data.oppwrapper =wrapperdata;
                data.oppList =[Select Name, RecordTypeId, Account.Name, Buyer__r.Name,CloseDate, Amount, StageName, Owner.Name From Opportunity Where Id IN :opportunityId];
            	return data;
            }
            else{
                data.message ='Incorrect Lead Id';
                return data;
            }
        }
        catch(exception ex){
            data.message = 'Lead coversion failed due to-'+ex.getMessage() +ex.getLineNumber()+'--'+ex.getCause();
            return data;
        }
    }  
    
    
    public class WrapObjects{
        
        @AuraEnabled public Account acc{get;set;}
        @AuraEnabled public Contact con{get;set;} 
        @AuraEnabled public List<OpportunityWrapper>oppwrapper {get;set;}
        @AuraEnabled public List<Opportunity>oppList {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public List<Database.Error>error {get;set;}
    }
    public class OpportunityWrapper{
        @AuraEnabled public Id leadId {get;set;}
        @AuraEnabled public List<Database.Error> error {get;set;}
        
    }
}