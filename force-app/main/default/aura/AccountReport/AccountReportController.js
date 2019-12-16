({
	doInit: function(component, event, helper) {
		helper.retrieveCountryCodes(component);
	},
	
	filterAccounts : function(component, event, helper){
		window.setTimeout($A.getCallback(function() {
			//alert('TEST');
			var searchText = component.get("v.searchText");
			var searchText_Country =  component.find("countrysearchText").get("v.value");
			var filteredList = []; 
			var accountList = component.get("v.accounts");
			if(typeof(searchText)==undefined || (typeof(searchText)!=undefined && searchText.length==0)){
				
				var filteredListCountry = component.get("v.filteredCountries");
				//alert(typeof(searchText_Country)+'------------'+searchText_Country.length);
				if((typeof(searchText_Country)!=undefined)){
					for(var i=0; i<accountList.length; i++){
						for(var j=0; j<accountList[i].countryStatusList.length; j++){
							accountList[i].countryStatusList[j].display = true;
							if(filteredListCountry.indexOf(accountList[i].countryStatusList[j].country)==-1){
								accountList[i].countryStatusList[j].display = false;
							}		
						}
					}
				}
				component.set("v.filteredAccounts",accountList);
				return;
			}
			
			
			
			
			if(typeof(searchText)!=undefined){
				searchText = searchText.toLowerCase();
			}
			
			for(var i=0; i<accountList.length; i++){
				//console.log('----searchText='+searchText+'-------accountList[i].accountObj.Name='+accountList[i].accountObj.Name+'---'+accountList[i].accountObj.Name.toLowerCase().startsWith(searchText));
				if(accountList[i].accountObj.Name.toLowerCase().startsWith(searchText)){	
					console.log('---MATCH FOUND---');
					filteredList.push(accountList[i]);
				}
			}
			//console.log('---searchText---='+searchText);
			//console.log('-------filteredList='+filteredList);
			//console.log('---------searchText.length='+searchText.length);
			component.set("v.filteredAccounts",filteredList);
		}), 800);
		/*window.setTimeout(
		$A.getCallback(function() {
		//console.log('---In SEARCH---');
		var searchText = component.get("v.searchText");
		if(typeof(searchText)==undefined || (typeof(searchText)!=undefined && searchText.length==0)){
			component.set("v.filteredAccounts",component.get("v.accounts"));
			return;
		}
		
		var accountList = component.get("v.accounts");
		var filteredList = []; 
		
		if(typeof(searchText)!=undefined){
			searchText = searchText.toLowerCase();
		}
		
		for(var i=0; i<accountList.length; i++){
			//console.log('----searchText='+searchText+'-------accountList[i].accountObj.Name='+accountList[i].accountObj.Name+'---'+accountList[i].accountObj.Name.toLowerCase().startsWith(searchText));
			if(accountList[i].accountObj.Name.toLowerCase().startsWith(searchText)){	
				console.log('---MATCH FOUND---');
				filteredList.push(accountList[i]);
			}
		}
		//console.log('---searchText---='+searchText);
		//console.log('-------filteredList='+filteredList);
		//console.log('---------searchText.length='+searchText.length);
		component.set("v.filteredAccounts",filteredList);
		}),2000);*/
	},
	
	filterCountries : function(component, event, helper){
		window.setTimeout($A.getCallback(function() {
			var searchText =  component.find("countrysearchText").get("v.value");
			var searchText_Account = component.get("v.searchText");
			var accountList = component.get("v.accounts");
			
			if(typeof(searchText_Account)!=undefined){
				accountList = component.get("v.filteredAccounts");
			}
			
			for(var i=0; i<accountList.length; i++){
				for(var j=0; j<accountList[i].countryStatusList.length; j++){
					accountList[i].countryStatusList[j].display = true;
				}
			}
			
	
			if((typeof(searchText)==undefined || (typeof(searchText)!=undefined && searchText.length==0))){
				component.set("v.filteredCountries",component.get("v.countries"));
				component.set("v.filteredAccounts",accountList);			
				return;
			}
			
			
			var filteredListAccount = []; 
			
			var countryList = component.get("v.countries");
			var countryISOMap =  component.get("v.countryMap");
			var filteredListCountry = []; 
			
			if(typeof(searchText)!=undefined){
				searchText = searchText.toLowerCase();
			}
			
			var tempISOCode;
			
			for(var i=0; i<countryList.length; i++){
				tempISOCode = countryISOMap[countryList[i]];
				if(countryList[i].toLowerCase().startsWith(searchText) || (typeof(tempISOCode)!=undefined && tempISOCode.ISO_3_Char_Code__c.toLowerCase().startsWith(searchText))){
					filteredListCountry.push(countryList[i]);
				}
			}
			
			for(var i=0; i<accountList.length; i++){
				for(var j=0; j<accountList[i].countryStatusList.length; j++){
					if(filteredListCountry.indexOf(accountList[i].countryStatusList[j].country)==-1){
						accountList[i].countryStatusList[j].display = false;
					}
				}
				filteredListAccount.push(accountList[i]);
			}
			
			component.set("v.filteredCountries",filteredListCountry);
			component.set("v.filteredAccounts",filteredListAccount);
		}),500);
	}
	
})