global class reportSchedular implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        LIST<Report> reportlist=[SELECT CreatedById,CreatedDate,Description,DeveloperName,FolderName,Id,Name,OwnerId FROM Report where Name='Auto-Project-Issues' OR Name='Auto-Project-Milestones'
                                 OR Name='Auto-Project-Risks' OR Name='Auto-TimesheetConsumtion' ];
        String str = String.valueOf(reportlist[0].id);  
        String str1 = String.valueOf(reportlist[1].id);  
        String str2 = String.valueOf(reportlist[2].id);  
        String str3 = String.valueOf(reportlist[3].id);  
        //  String str4= String.valueOf(reportlist[4].id);  
        
        String Reportid = str;
        String reportid1=str1;
        String reportid2=str2;
        String reportid3=str3;
        // String reportid4=str4;
        
        ApexPages.PageReference report = new ApexPages.PageReference( '/' + Reportid + '?csv=1');     
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Auto-Project-Issues.csv');
        attachment.setBody(report.getContent());
       // attachment.setBody(Blob.valueof(report.getContent().toString()));
        attachment.setContentType('text/csv');
        
        ApexPages.PageReference report1 = new ApexPages.PageReference( '/' + Reportid1 + '?csv=1');
        Messaging.EmailFileAttachment attachment1 = new Messaging.EmailFileAttachment();
        attachment1.setFileName('Auto-Project-Milestones.csv');
        attachment.setBody(report1.getContent());
        //attachment1.setBody(Blob.valueof(report1.getContent().toString()));
        attachment1.setContentType('text/csv');
        
        ApexPages.PageReference report2 = new ApexPages.PageReference( '/' + Reportid2 + '?csv=1');
        Messaging.EmailFileAttachment attachment2 = new Messaging.EmailFileAttachment();
        attachment2.setFileName('Auto-Project-Risks.csv');
        attachment.setBody(report2.getContent());
       // attachment2.setBody(Blob.valueof(report2.getContent().toString()));
        attachment2.setContentType('text/csv');
        
        ApexPages.PageReference report3 = new ApexPages.PageReference( '/' + Reportid3 + '?csv=1');        
        Messaging.EmailFileAttachment attachment3 = new Messaging.EmailFileAttachment();
        
        attachment3.setFileName('Auto-TimesheetConsumtion.csv');
        attachment.setBody(report3.getContent());
      //  attachment3.setBody(Blob.valueof(report3.getContent().toString()));
        attachment3.setContentType('text/csv');
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment, attachment1,attachment2,attachment3 } );
        message.setSubject('All  Reports');
        String body;
        body='Hi Jawhar,\n';
        body+=' Plese find the attachments of All Reports . ';
        message.setPlainTextBody(body);
        message.setToAddresses( new String[] { 'janardhana.reddy@tradeshift.com' } );
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );    
    }
}