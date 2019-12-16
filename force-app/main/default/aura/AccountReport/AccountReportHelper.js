({
	retrieveCountryCodes: function(component){
		var action = component.get("c.retrieveCountriesCodes");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
            	console.log('RETRIEVED CODES');
            	console.log('----'+response.getReturnValue());
                component.set("v.countryMap",response.getReturnValue());
                var mapCo = response.getReturnValue();
                var temp = mapCo["AFGHANISTAN"];
                //alert('CODE-'+temp.ISO_3_Char_Code__c);
                this.retrieveCountries(component);
            }
            else {
            	console.log("Failed with state: " + state);
            }
        });    
        // Send action off to be executed
        $A.enqueueAction(action);
	},
	
	retrieveCountries : function(component) {

		var action = component.get("c.retrieveCountries");
		
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var countries = response.getReturnValue();
                if(countries.length>0){
                	component.set("v.countries",countries);
                	component.set("v.filteredCountries",countries);
                }
                this.retrieveAccounts(component,countries);
                console.log('RETRIEVED COUNTRIES');
            }
            else {
                console.log("Failed with state: " + state);
            }
        });    
        // Send action off to be executed
        $A.enqueueAction(action);
	},
	
	retrieveAccounts: function(component,countries){
		var action = component.get("c.retrieveAccounts");
		action.setParams({"countries": countries});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var accounts = response.getReturnValue();
                if(accounts.length>0){
                	component.set("v.accounts",accounts);
                	component.set("v.filteredAccounts",accounts);
                }
                console.log('RETRIEVED ACCOUNTS');
            }
            else {
                console.log("Failed with state: " + state);
            }
        });    
        // Send action off to be executed
        $A.enqueueAction(action);
	}
	
	
})