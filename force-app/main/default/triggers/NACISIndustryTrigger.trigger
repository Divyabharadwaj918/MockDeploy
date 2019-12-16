trigger NACISIndustryTrigger on Lead (before insert, before update) {
    List<Double> naicsCodes = new List<Double>();
    List<Lead> leadsForProcess = new List<Lead>();   
    for(Integer i=0; i<Trigger.new.size(); i++){      
        if(Trigger.isUpdate && (Trigger.new[i].NAICS_Code__c!=null)){
            naicsCodes.add(Double.valueOf(Trigger.new[i].NAICS_Code__c));    
            leadsForProcess.add(Trigger.new[i]);
        }
        if(Trigger.isInsert && (Trigger.new[i].NAICS_Code__c!=null)){
            naicsCodes.add(Double.valueOf(Trigger.new[i].NAICS_Code__c));    
            leadsForProcess.add(Trigger.new[i]);
        }
    }
    
    if(naicsCodes.size()>0){
        naicsCodes.sort();      
        NAICS_Range__c[] naicsRanges = [Select Id, NAICS_Code_Lower__c, NAICS_Code_Upper__c, Industry_Mapping__r.Industry__c 
                                        from NAICS_Range__c 
                                        where NAICS_Code_Lower__c<=:naicsCodes[0] or NAICS_Code_Upper__c>=:naicsCodes[naicsCodes.size()-1]];
        System.debug('--------------naicsRanges='+naicsRanges);        
        for(Integer i=0; i<leadsForProcess.size(); i++){   
             
            Trigger.new[i].Industry = 'Other';
           if(Trigger.new[i].NAICS_Code__c!=null){
                for(Integer j=0; j<naicsRanges.size(); j++){
                    if(naicsRanges[j].NAICS_Code_Lower__c<=Double.valueOf(Trigger.new[i].NAICS_Code__c) &&
                       Double.valueOf(Trigger.new[i].NAICS_Code__c)<=naicsRanges[j].NAICS_Code_Upper__c){                   
                           Trigger.new[i].Industry = naicsRanges[j].Industry_Mapping__r.Industry__c;
                       }
                }
            }
        }        
    }    
}