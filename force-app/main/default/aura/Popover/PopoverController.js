({
	handleMouseEnter : function(component, event, helper) {
		alert('---DISPLAYING----');
        var popover = component.find("popover");
        $A.util.removeClass(popover,'slds-hide');
        var infoIcon = component.find("infoIcon");
        $A.util.addClass(infoIcon,'slds-hide');
    },
    handleMouseLeave : function(component, event, helper) {
    	alert('---HIDING----');
    	var popover = component.find("popover");
    	alert('----'+popover);
        $A.util.addClass(popover,'slds-hide');
        var infoIcon = component.find("infoIcon");
        $A.util.removeClass(infoIcon,'slds-hide');
    }
})