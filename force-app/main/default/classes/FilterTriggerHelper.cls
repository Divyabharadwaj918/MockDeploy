/**
* Description     -   This class is used to update filter Object.
* 
* Created by      -   
* 
* Created Date    -   09/20/2019
*
* Revision log    -   V_1.0
*                   
*/
public class FilterTriggerHelper {
    public static Boolean isTrigger = false;
	
        /**
*  @description    :   This method is update default filter. 
*
*  @args           :   List<Filter__c> ,Map<Id,Filter__c>
*
*  @return         :   void
* 
**/
    public static void updateDefaultFilter(List<Filter__c> newFilterList , List<Filter__c> oldList){
        try{
            //Set to hold UserId
            Set<Id> userId = new Set<Id>();
            Set<Id> filterId = new Set<Id>();
            Boolean defaultvalue = false;
            //Map to hold Sibling Filter records
            Map<String, List<Filter__c>> mapFilterData = new  Map<String, List<Filter__c>>();
            
            //List to update the filters
            List<Filter__c> updatedtobeFilters = new  List<Filter__c>();
            
            //Loop over new List
            for(Filter__c filter :newFilterList != null ? newFilterList:oldList){
                userId.add(filter.User__c);
                filterId.add(filter.Id);
            }
            
            for(Filter__c filt : [Select Id,Name ,Default__c, Type_of_Filter__c, User__c from Filter__c Where User__c IN : userId and Id Not In: filterId]){
                //Check on Map key
                if(!mapFilterData.containsKey(filt.User__c+'-'+filt.Type_of_Filter__c))
                    mapFilterData.put(filt.User__c+'-'+filt.Type_of_Filter__c , new List<Filter__c>());
                mapFilterData.get(filt.User__c+'-'+filt.Type_of_Filter__c).add(filt);
            }
            
            system.debug('mapFilterData'+mapFilterData);
            for(Filter__c filter :newFilterList != null ? newFilterList: oldList){
                system.debug(mapFilterData.containsKey(filter.User__c+'-'+filter.Type_of_Filter__c)+'oldList--'+oldList );
                if(mapFilterData != null && mapFilterData.containsKey(filter.User__c+'-'+filter.Type_of_Filter__c)){
                    if(newFilterList != null){
                        if( filter.Default__c == true){
                            for(Filter__c filt :mapFilterData.get(filter.User__c+'-'+filter.Type_of_Filter__c)){
                                //filters to be update
                                updatedtobeFilters.add(new Filter__c(Id= filt.Id ,Default__c = false ));
                            }
                        }
                        else{ 
                            for(Filter__c filt :mapFilterData.get(filter.User__c+'-'+filter.Type_of_Filter__c)){
                                if(filt.Default__c == true)
                                    defaultvalue = true;
                            } 
                        }
                        if(defaultvalue == false)    
                       	 filter.Default__c = true;
                    }
                    else if(filter.default__c == true){
                        system.debug('filter'+filter);
                        updatedtobeFilters.add(new Filter__c(Id = mapFilterData.get(filter.User__c+'-'+filter.Type_of_Filter__c)[0].Id ,Default__c = true));  
                    }
                    
                    
                }
                
            }
            isTrigger = true;
            //Check on size
            if(updatedtobeFilters.size()>0){
                update updatedtobeFilters;
                system.debug('updatedtobeFilters--'+updatedtobeFilters);
                
            }     
        }
        catch(exception ex){
            system.assert(false,ex.getMessage() +'--'+ex.getLineNumber());
        }
    } 
}