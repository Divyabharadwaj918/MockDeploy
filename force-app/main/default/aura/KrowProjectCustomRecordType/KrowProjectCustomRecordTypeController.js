({
    createRecordFun : function (component, event, helper) {
        var rtDet = document.querySelector('input[name="recordTypeRadio"]:checked');
        if(rtDet != null) {
            document.getElementById("newClientSectionId").style.display = "none" ;
             if(rtDet.value  != 'PS Project'){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Krow__Project__c",
                "recordTypeId" : rtDet.id
            });
            createRecordEvent.fire();
             }
            else{
                var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                     "url":'/apex/Krow__ViewProjectFwd',
                     "isredirect": true
                    
                 });
                 urlEvent.fire();
            }
        } 
    },
    closeModal: function(component, event, helper) { 
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" :'/lightning/o/Krow__Project__c/home',
            "isredirect": true
        });
        urlEvent.fire();

    },
    doInit : function(component, event, helper) { 
        helper.KrowProjectRecordTypeSelectorController(component); 
    }
})