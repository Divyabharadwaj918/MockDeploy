public class KrowProjectRecordTypeSelectorController {

	@AuraEnabled
    public static List<RecordType> getListOfRecordType(){

        String query = 'SELECT Id,Name FROM RecordType WHERE SobjectType =\''+'Krow__Project__c'+'\' ';

        List<RecordType> rtNames = new List<RecordType>();
        Schema.SObjectType  objType = Krow__Project__c.SObjectType;     

        for(RecordTypeInfo rt : objType.getDescribe().getRecordTypeInfos()){
            System.debug('rt.getName()'+rt.getName());
            
            if (rt.getName() != 'Master' && rt.isActive() && rt.isAvailable())
            	rtNames.add(new RecordType(Id = rt.getRecordTypeId(),Name = rt.getName()));
            System.debug('rtNames'+rtNames);
        } 
        return rtNames; 
    }
}