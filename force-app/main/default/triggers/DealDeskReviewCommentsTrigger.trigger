trigger DealDeskReviewCommentsTrigger on Opportunity (before insert, before update) {    
    String oldComment, newComment;
    String oldlegalComment, newLegalComment;
    String oldProductComment,newProductComment;
    String oldServiceComment,newServiceComment;
    String oldITsecurityComment,newITsecurityComment;
    String currentUserInitials = UserInfo.getFirstName().substring(0,1)+''+UserInfo.getLastName().substring(0,1);
    String commentTag = currentUserInitials+'-'+String.valueOf(Date.today().format());
    
    for(Integer i=0; i<Trigger.new.size(); i++){        
        if(Trigger.isInsert && Trigger.new[i].New_Comment__c!=null && Trigger.new[i].New_Comment__c!=''){
            Trigger.new[i].Deal_Review_Comments__c = commentTag +' :- '+Trigger.new[i].New_Comment__c;
            Trigger.new[i].New_Comment__c= '';
        }
        if(Trigger.isInsert && Trigger.new[i].Legal_Finance_Comment__c!=null && Trigger.new[i].Legal_Finance_Comment__c!=''){
            Trigger.new[i].Legal_Finance_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Legal_Finance_Comment__c;
            Trigger.new[i].Legal_Finance_Comment__c = '';
        }
        if(Trigger.isInsert && Trigger.new[i].Product_Comment__c!=null && Trigger.new[i].Product_Comment__c!=''){
            Trigger.new[i].Product_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Product_Comment__c;
            Trigger.new[i].Product_Comment__c = '';
        }
        if(Trigger.isInsert && Trigger.new[i].IT_Security_Comment__c!=null && Trigger.new[i].IT_Security_Comment__c!=''){
            Trigger.new[i].IT_Security_Review_Comments__c = commentTag +' :- '+Trigger.new[i].IT_Security_Comment__c;
            Trigger.new[i].IT_Security_Comment__c = '';
        }
        if(Trigger.isInsert && Trigger.new[i].Services_Comment__c!=null && Trigger.new[i].Services_Comment__c!=''){
            Trigger.new[i].Service_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Services_Comment__c;
            Trigger.new[i].Services_Comment__c = '';
        } 
        if((Trigger.isUpdate && (Trigger.new[i].Legal_Finance_Comment__c==null || Trigger.new[i].Legal_Finance_Comment__c=='') &&
           (Trigger.new[i].Legal_Finance_Approval__c!=Trigger.oldMap.get(Trigger.new[i].Id).Legal_Finance_Approval__c && Trigger.new[i].Legal_Finance_Approval__c=='Rejected') )){
           System.debug(' ---inside loop--');
           Trigger.new[i].Legal_Finance_Comment__c.addError('Legal/Finance Comment is required when rejecting.');
        }   
          if((Trigger.isUpdate && (Trigger.new[i].IT_Security_Comment__c==null || Trigger.new[i].IT_Security_Comment__c=='') &&
           (Trigger.new[i].IT_Security_Approval__c!=Trigger.oldMap.get(Trigger.new[i].Id).IT_Security_Approval__c && Trigger.new[i].IT_Security_Approval__c=='Rejected') )){
           System.debug(' ---inside loop--');
           Trigger.new[i].IT_Security_Comment__c.addError('IT/Security  Comment is required when rejecting.');
        }
          if((Trigger.isUpdate && (Trigger.new[i].Product_Comment__c==null || Trigger.new[i].Product_Comment__c=='') &&
           (Trigger.new[i].Product_Approval__c!=Trigger.oldMap.get(Trigger.new[i].Id).Product_Approval__c && Trigger.new[i].Product_Approval__c=='Rejected') )){
           System.debug(' ---inside loop--');
           Trigger.new[i].Product_Comment__c.addError('Product  Comment is required when rejecting.');
        }
          if((Trigger.isUpdate && (Trigger.new[i].Services_Comment__c==null || Trigger.new[i].Services_Comment__c=='') &&
           (Trigger.new[i].Services_Approval__c!=Trigger.oldMap.get(Trigger.new[i].Id).Services_Approval__c && Trigger.new[i].Services_Approval__c=='Rejected') )){
           System.debug(' ---inside loop--');
           Trigger.new[i].Services_Comment__c.addError('Service Comment is required when rejecting.');
        }
        if(Trigger.isUpdate){
            oldComment = Trigger.oldMap.get(Trigger.new[i].Id).New_Comment__c;
            newComment = Trigger.new[i].New_Comment__c;
            oldlegalComment=Trigger.oldMap.get(Trigger.new[i].Id).Legal_Finance_Comment__c;
            newLegalComment = Trigger.new[i].Legal_Finance_Comment__c;
            oldProductComment=Trigger.oldMap.get(Trigger.new[i].Id).Product_Comment__c;
            newProductComment = Trigger.new[i].Product_Comment__c;
            oldServiceComment=Trigger.oldMap.get(Trigger.new[i].Id).Services_Comment__c;
            newServiceComment = Trigger.new[i].Services_Comment__c;
            oldITsecurityComment=Trigger.oldMap.get(Trigger.new[i].Id).IT_Security_Comment__c;
            newITsecurityComment = Trigger.new[i].IT_Security_Comment__c;
            
            if(oldComment!=null){
                oldComment =  oldComment.replaceAll('\n','');
                oldComment =  oldComment .replaceAll('\r','');
            }                       
            if(newComment !=null){             
                newComment =  newComment.replaceAll('\n','');
                newComment =  newComment.replaceAll('\r','');               
            }
            else{
                newComment='';
            }
            if(oldlegalComment!=null){               
                oldlegalComment =  oldlegalComment.replaceAll('\n','');
                oldlegalComment =  oldlegalComment .replaceAll('\r','');               
            }                        
            if(newLegalComment !=null){                
                newLegalComment =  newLegalComment.replaceAll('\n','');
                newLegalComment =  newLegalComment.replaceAll('\r','');                
            }
            else{
                newLegalComment ='';
            }
            if(oldProductComment!=null){
                oldProductComment =  oldProductComment.replaceAll('\n','');
                oldProductComment =  oldProductComment .replaceAll('\r','');               
            }           
            if(newProductComment !=null){                
                newProductComment =  newProductComment.replaceAll('\n','');
                newProductComment =  newProductComment.replaceAll('\r','');                
            }
            else{
                newProductComment ='';
            }              
            if(oldServiceComment!=null){
                oldServiceComment =  oldServiceComment.replaceAll('\n','');
                oldServiceComment =  oldServiceComment .replaceAll('\r','');                
            }           
            if(newServiceComment !=null){               
                newServiceComment =  newServiceComment.replaceAll('\n','');
                newServiceComment =  newServiceComment.replaceAll('\r','');                
            }
            else{
                newServiceComment ='';
            }               
            if(oldITsecurityComment!=null){
                oldITsecurityComment =  oldITsecurityComment.replaceAll('\n','');
                oldITsecurityComment =  oldITsecurityComment .replaceAll('\r','');                
            }                        
            if(newITsecurityComment !=null){               
                newITsecurityComment =  newITsecurityComment.replaceAll('\n','');
                newITsecurityComment =  newITsecurityComment.replaceAll('\r','');                
            }
            else{
                newITsecurityComment ='';
            }              
        }       
        if(Trigger.isUpdate && !newComment.equalsIgnoreCase(oldComment) || Trigger.isUpdate &&!newLegalComment.equalsIgnoreCase(oldlegalComment) || Trigger.isUpdate && !newProductComment.equalsIgnoreCase(oldProductComment)||Trigger.isUpdate && !newServiceComment.equalsIgnoreCase(oldServiceComment)||Trigger.isUpdate && !newITsecurityComment.equalsIgnoreCase(oldITsecurityComment)){
            if(Trigger.new[i].New_Comment__c!=null && Trigger.new[i].New_Comment__c!=''){
                Trigger.new[i].Deal_Review_Comments__c = commentTag +' :- '+Trigger.new[i].New_Comment__c;
                if(Trigger.oldMap.get(Trigger.new[i].Id).Deal_Review_Comments__c!=null){
                    Trigger.new[i].Deal_Review_Comments__c = commentTag +' :- '+Trigger.new[i].New_Comment__c+'\n\n'+Trigger.oldMap.get(Trigger.new[i].Id).Deal_Review_Comments__c;
                }
                Trigger.new[i].New_Comment__c= '';
            }
        }
        if(Trigger.new[i]. Legal_Finance_Comment__c!=null && Trigger.new[i]. Legal_Finance_Comment__c!=''){
            Trigger.new[i]. Legal_Finance_Review_Comments__c = commentTag +' :- '+Trigger.new[i]. Legal_Finance_Comment__c;
            if(Trigger.oldMap.get(Trigger.new[i].Id). Legal_Finance_Review_Comments__c!=null){
                Trigger.new[i]. Legal_Finance_Review_Comments__c = commentTag +' :- '+Trigger.new[i]. Legal_Finance_Comment__c      +'\n\n'+Trigger.oldMap.get(Trigger.new[i].Id). Legal_Finance_Review_Comments__c;
            }
            Trigger.new[i]. Legal_Finance_Comment__c = '';
        }
        if(Trigger.new[i].Product_Comment__c!=null && Trigger.new[i].Product_Comment__c!=''){
            Trigger.new[i].Product_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Product_Comment__c;
            if(Trigger.oldMap.get(Trigger.new[i].Id). Product_Review_Comments__c!=null){
                Trigger.new[i].Product_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Product_Comment__c +'\n\n'+Trigger.oldMap.get(Trigger.new[i].Id).Product_Review_Comments__c;
            }
            Trigger.new[i].Product_Comment__c = '';
        }
        if(Trigger.new[i].Services_Comment__c!=null && Trigger.new[i].Services_Comment__c!=''){
            Trigger.new[i].Service_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Services_Comment__c;
            if(Trigger.oldMap.get(Trigger.new[i].Id). Service_Review_Comments__c!=null){
                Trigger.new[i].Service_Review_Comments__c = commentTag +' :- '+Trigger.new[i].Services_Comment__c +'\n\n'+Trigger.oldMap.get(Trigger.new[i].Id).Service_Review_Comments__c;
            }
            Trigger.new[i].Services_Comment__c = '';
        }
        if(Trigger.new[i].IT_Security_Comment__c!=null && Trigger.new[i].IT_Security_Comment__c!=''){
            Trigger.new[i].IT_Security_Review_Comments__c = commentTag +' :- '+Trigger.new[i].IT_Security_Comment__c;
            if(Trigger.oldMap.get(Trigger.new[i].Id). IT_Security_Review_Comments__c!=null){
                Trigger.new[i].IT_Security_Review_Comments__c = commentTag +' :- '+Trigger.new[i].IT_Security_Comment__c +'\n\n'+Trigger.oldMap.get(Trigger.new[i].Id).IT_Security_Review_Comments__c;
            }
            Trigger.new[i].IT_Security_Comment__c = '';
        }  
    }
}