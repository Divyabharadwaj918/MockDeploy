public class ContractAttachmentValidatorController {
    
    //Properties
    public String attachmentMessage{get;set;}
    public Boolean attachmentComplete{get;set;}
    public List<GoogleDoc> doclist{get;set;}
    public String contractId{get;set;}
    
    
    //Constructor
    public ContractAttachmentValidatorController(ApexPages.StandardController sc){
        contractId = sc.getId();
        String badDocuments = '';
        doclist = new List<GoogleDoc>();
        GoogleDoc[] googleDocs = [Select Id, Name, URL from GoogleDoc where ParentId=:contractId order by Name];
        
        
        for(Integer i=0; i<googleDocs.size(); i++){
            doclist.add(googleDocs[i]);
            if(googleDocs[i].URL.contains('PLACEHOLDERPLEASEUPLOAD')){
                badDocuments += '<b>'+googleDocs[i].Name+'</b>, ';
                doclist[i].URL='';
            }
        }
        
        attachmentMessage = '<span style=\"color:Green;font-weight:bold\">Documents are complete, can be submitted for Approval.</span>';
        attachmentComplete = true;
        if(badDocuments.length()>0){
            badDocuments = badDocuments.substring(0,badDocuments.length()-2);
            attachmentMessage = '<span style=\"color:Red;font-weight:bold\">Cannot Submit for Approval.</span><br/>';
            attachmentMessage += 'Please update the highlighted with appropriate Google Docs link.';//+badDocuments;
            attachmentComplete = false;
        }
        
        if(googleDocs.size()<4){
            attachmentMessage = '<span style=\"color:Red;font-weight:bold\">Cannot Submit for Approval.</span><br/>';
            attachmentMessage += 'Please ensure Google Docs: Statement of Work, Estimator Sheet, Supplier Forecast, Approval & Transition Sheet are uploaded.';
        }
        
    }
    
    public void udpateContract(){
        Contract contractObj = new Contract(Id=contractId, Has_Attachments__c = attachmentComplete);
        update contractObj;
    }
    
    public void saveDocs(){
        update doclist;
    }
}