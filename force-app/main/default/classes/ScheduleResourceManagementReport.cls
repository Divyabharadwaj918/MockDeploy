global class ScheduleResourceManagementReport implements System.Schedulable {
      global void execute(SchedulableContext sc) {
         scheduleJob();
        
    }
 @future(callout=true)
    // @TestVisible
    public static void scheduleJob(){
       LIST<Report> reportlist=[SELECT CreatedById,CreatedDate,Description,DeveloperName,FolderName,Id,Name,OwnerId FROM Report where  Name='Accounts + M2, M4, M5 Completion dates' OR Name='Contacts with CSAT YES']; 
    
        String str1 = String.valueOf(reportlist[0].id);  
        String str2 = String.valueOf(reportlist[1].id); 
      
        String reportid1 = str1; 
        String reportid2 = str2;
		
        
        String reportDN1 = reportlist[0].Name;
        String reportDN2 = reportlist[1].Name;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();


        
        ApexPages.PageReference report1 = new ApexPages.PageReference( '/' + reportid1 + '?csv=1&isdtp=p1');     
        Messaging.EmailFileAttachment attachment1 = new Messaging.EmailFileAttachment();
        attachment1.setFileName(reportDN1+'.csv');
         if(Test.isRunningTest()) { 
            attachment1.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment1.setBody(report1.getContent());
        }      
        attachment1.setContentType('text/csv');
        attachments.add(attachment1);

        ApexPages.PageReference report2 = new ApexPages.PageReference( '/' + reportid2 + '?csv=1&isdtp=p1');     
        Messaging.EmailFileAttachment attachment2 = new Messaging.EmailFileAttachment();
        attachment2.setFileName(reportDN2+'.csv');
        if(Test.isRunningTest()) { 
            attachment2.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment2.setBody(report2.getContent());
        }      
        attachment2.setContentType('text/csv');
        attachments.add(attachment2);

 
        message.setSubject('Automated Resource Management CSV ');
        message.setFileAttachments(attachments);
        String body;
        body='Hi,\n';
        body+='Please find Krow reports attached.';
        message.setPlainTextBody(body);
        message.setToAddresses( new String[] { 'krowbot@tradeshift.com' } );
        
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );    
    
    }
}