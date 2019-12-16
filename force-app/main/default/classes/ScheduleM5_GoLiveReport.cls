global class ScheduleM5_GoLiveReport implements System.Schedulable {
      global void execute(SchedulableContext sc) {
         scheduleJob();
        
    }

 @future(callout=true)
    // @TestVisible
    public static void scheduleJob(){
       Report reportlist=[SELECT CreatedById,CreatedDate,Description,DeveloperName,FolderName,Id,Name,OwnerId FROM Report where  Name='All Projects - M5 Go Live' Limit 1]; 

        String reportid1 =String.valueOf(reportlist.id);  

        String reportDN1 = reportlist.Name;

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