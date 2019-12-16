({
	handleClick: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
        
    },
    
    showToast : function(component, event, helper, message, title) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": title,
        "message": message
    });
    toastEvent.fire();
}
})