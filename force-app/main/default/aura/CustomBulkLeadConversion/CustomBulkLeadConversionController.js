({
	leadConversion : function(component, event, helper) {
        component.set("v.Spinner", true);
        var recordid = component.get("v.recordId");
		var action = component.get("c.convertLeads");
        action.setParams({
            "RecordId":recordid
        });
        action.setCallback(this,function(response){
            if(response.getState() == "SUCCESS"){
                var message = response.getReturnValue().message;
                if(message.includes("success")){
                   component.set("v.WrapperData",response.getReturnValue());
                    helper.showToast(component, event, helper, message, "Success!");
                }
                else{
                    helper.handleClick(component, event, helper);

                    helper.showToast(component, event, helper, message, "Error!");
                }
                
            }
                           });
        $A.enqueueAction(action);
     
	},
    
    handleClick: function(component, event, helper) {
       helper.handleClick(component, event, helper);

    }
        
})