global class scheduleReport implements System.Schedulable {
    global void execute(SchedulableContext sc) {
         scheduleJob();
        
    }
     @future(callout=true)
    // @TestVisible
    public static void scheduleJob(){
       LIST<Report> reportlist=[SELECT CreatedById,CreatedDate,Description,DeveloperName,FolderName,Id,Name,OwnerId FROM Report where  Name='All Active Users' OR Name='Auto-Project-Issues' OR Name='Auto-Project-Milestones'
                               OR  Name='Auto-Project-Risks' OR Name='Auto-TimesheetConsumtion' OR DeveloperName = 'Revenue_Gap' OR DeveloperName = 'Weekly_Report_Post_Email']; 
    
        String str = String.valueOf(reportlist[0].id);  
        String str1 = String.valueOf(reportlist[1].id); 
        String str2 = String.valueOf(reportlist[2].id);  
        String str3 = String.valueOf(reportlist[3].id);
        String str4 = String.valueOf(reportlist[4].id);
        String Str5 = String.valueOf(reportlist[5].id);
		String Str6 = String.valueOf(reportlist[6].id);

        String reportid = str;
        String reportid1 = str1; 
        String reportid2 = str2;
        String reportid3 = str3;
        String reportid4 = str4;
        String reportid5 = str5;
		String reportid6 = str6;
				
        
        String reportDN = reportlist[0].Name;
        String reportDN1 = reportlist[1].Name;
        String reportDN2 = reportlist[2].Name;
        String reportDN3 = reportlist[3].Name;
        String reportDN4 = reportlist[4].Name;
        String reportDN5 = reportlist[5].Name;
		String reportDN6 = reportlist[6].Name;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

        ApexPages.PageReference report = new ApexPages.PageReference( '/' + reportid + '?csv=1&isdtp=p1');
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
          attachment.setFileName(reportDN+'.csv');
        if(Test.isRunningTest()) { 
            attachment.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment.setBody(report.getContent());
        }          
        attachment.setContentType('text/csv');
        attachments.add(attachment);
        
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

        ApexPages.PageReference report3 = new ApexPages.PageReference( '/' + reportid3 + '?csv=1&isdtp=p1');     
        Messaging.EmailFileAttachment attachment3 = new Messaging.EmailFileAttachment();
        attachment3.setFileName(reportDN3+'.csv');
         if(Test.isRunningTest()) { 
            attachment3.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment3.setBody(report3.getContent());
        }     
        attachment3.setContentType('text/csv');
        attachments.add(attachment3);
        
        ApexPages.PageReference report4 = new ApexPages.PageReference( '/' + reportid4 + '?csv=1&isdtp=p1');     
        Messaging.EmailFileAttachment attachment4 = new Messaging.EmailFileAttachment();
        attachment4.setFileName(reportDN4+'.csv');
        if(Test.isRunningTest()) { 
            attachment4.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment4.setBody(report4.getContent());
        }     
        attachment4.setContentType('text/csv');
        attachments.add(attachment4);

        ApexPages.PageReference report5 = new ApexPages.PageReference( '/' + reportid5 + '?csv=1&isdtp=p1');
        Messaging.EmailFileAttachment attachment5 = new Messaging.EmailFileAttachment();
        
        attachment5.setFileName(reportDN5+'.csv');
        if(Test.isRunningTest()) { 
            attachment5.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment5.setBody(report5.getContent());
        }     
        attachment5.setContentType('text/csv');            
        attachments.add(attachment5);

        ApexPages.PageReference report6 = new ApexPages.PageReference( '/' + reportid6 + '?csv=1&isdtp=p1');     
        Messaging.EmailFileAttachment attachment6 = new Messaging.EmailFileAttachment();
        attachment6.setFileName(reportDN6+'.csv');
        if(Test.isRunningTest()) { 
            attachment6.setBody(blob.valueOf('Unit.Test'));
        } else {
            attachment6.setBody(report6.getContent());
        }      
        attachment6.setContentType('text/csv');
        attachments.add(attachment6);

        message.setSubject('Automated Krow Reports CSV ');
        message.setFileAttachments(attachments);
        String body;
        body='Hi,\n';
        body+='Please find Krow reports attached.';
        message.setPlainTextBody(body);
        message.setToAddresses( new String[] { 'krowbot@tradeshift.com' } );
        
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );    
    
    }
}