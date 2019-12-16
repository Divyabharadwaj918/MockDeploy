/**
 *    Description     :        This is customLeadConversion controller.
 *
 *    Created By      :        
 *
 *    Created Date    :        20/08/2017
 *
 *    Revision Logs   :        V_1.0 - Created
 *                      
 **/
public class CustomLeadConversionController {
    public lead leadRecord ;
    public Lead lead {get; set;}
    public String result {get; set;}
    public account accountInfo {get; set;}
    public contact contactInfo {get; set;}
    public opportunity opportunityInfo {get; set;}
    
    public CustomLeadConversionController(ApexPages.StandardController sc){
        leadRecord = (Lead) sc.getRecord();
        result = '';
        lead = [Select Id, Name, FirstName, LastName, Phone, Email, Company, TS_ID__c, Buyer__r.Name From Lead Where Id = :leadRecord.Id Limit 1];
	}
    
    public PageReference backToLeadRecord(){
        PageReference pg = new PageReference('/'+leadRecord.Id);
        pg.setRedirect(false);
        return pg;
    }
    
    public void convertLead(){
        
        try{
            Id recordTypeIdAcc = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Account' AND IsActive = true LIMIT 1].Id;
            Id recordTypeIdCon = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Contact' AND IsActive = true LIMIT 1].Id;
            Id recordTypeIdOpp = [Select Id From RecordType Where DeveloperName = 'Seller_Sales' AND sObjectType = 'Opportunity' AND IsActive = true LIMIT 1].Id;
            
            //create account record.
            Account newAccount = new Account();
                     
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadRecord.Id);
            lc.setOwnerId(userInfo.getUserId());
            
            Boolean accFound = false;
            //Query account record and set it id in setAccountId method.
            if(String.isNotBlank(lead.TS_ID__c)){
                List<Account> acc  = [Select Id, Name, type, phone, website, Owner.Name, Client_Executive__r.Name  From Account Where TS_ID__c = :lead.TS_ID__c LIMIT 1];
                if(acc != null && acc.size() > 0){
                    accFound = true;
                	lc.setAccountId(acc[0].Id);
                    accountInfo = acc[0];
                    
                    //checking for contact record.
                    List<contact> con = [Select Id, RecordTypeId, Name, Title, Account.Name, Phone, Email, MobilePhone From Contact 
                                   Where AccountId = :acc[0].Id AND Phone =: lead.Phone AND Email =: lead.Email AND FirstName =: lead.FirstName AND LastName =: lead.LastName LIMIT 1];
                    
                    if(con != null && con.size() > 0){
                        lc.setContactId(con[0].Id);
                    }
                }
            }
            if(accFound == false){
                newAccount.Name = lead.Company;
                newAccount.RecordTypeId = recordTypeIdAcc;
                newAccount.Is_Seller__c = true;
                newAccount.OwnerId = userInfo.getUserId();
                insert newAccount;
                accountInfo = newAccount;
                lc.setAccountId(newAccount.Id);
            }
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            
            Database.LeadConvertResult lcr = Database.convertLead(lc,dml);
            if(lcr.isSuccess()){
                //update the record type of account, contact and opportunity record.
                Id accountId = lcr.getAccountId();
                Id contactId = lcr.getContactId();
                Id opportunityId = lcr.getOpportunityId();
                
                //List to update record.
                List<Sobject> listOfSobjectToUpdate = new List<Sobject>();
                
                Account newCreatedAccount = [Select Id, Name, type, phone, website, Owner.Name, Client_Executive__r.Name, Is_Seller__c From Account Where Id = :accountId];
                //newCreatedAccount.Is_Seller__c = true;
                accountInfo = newCreatedAccount;
                
                Contact newCreatedContact = [Select Id, RecordTypeId, Name, Title, Account.Name, Phone, Email, MobilePhone From Contact Where Id = :contactId];
                contactInfo = newCreatedContact;
                
                Opportunity newCreatedOpp = [Select Id, Name, RecordTypeId, Account.Name, Buyer__r.Name,CloseDate, Amount, StageName, Owner.Name From Opportunity Where Id = :opportunityId];
                opportunityInfo = newCreatedOpp;
                opportunityInfo.Name = newCreatedOpp.Account.Name +' - '+ newCreatedOpp.Buyer__r.Name;
                listOfSobjectToUpdate.add(newCreatedOpp);
                
                if(listOfSobjectToUpdate.size() > 0){
                    update listOfSobjectToUpdate;
                    apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your lead has been converted.'));
                    result = 'success';
                }
            }
            else{
                apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error, lcr.getErrors()[0].getMessage()));
                result = 'failure';
            }
            
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error, e.getMessage()));
            result = 'failure';
        }
    }
    
}