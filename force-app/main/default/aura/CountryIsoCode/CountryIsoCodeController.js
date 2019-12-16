({
	doInit: function(component, event, helper) {
		var countryMap = component.get("v.countryMap");
		var country = component.get("v.country");
		var noOfChars = component.get("v.noOfChars");
		console.log(country+'--------'+countryMap);
		var so_IsoCountry =  countryMap[country];
		console.log(so_IsoCountry);
		var countryCode = country;
		if(typeof(so_IsoCountry)=="undefined"){
			console.log(" COUNTRY Not FOUND");			
		}
		else{
			countryCode = countryMap[country].ISO_3_Char_Code__c;
			if(noOfChars==2){
				countryCode = countryMap[country].ISO_2_Char_Code__c;
			}
		}		
		if(countryCode=='' || countryCode==null){
			countryCode = country;
		}		
		component.set("v.countryCode",countryCode);
	}
})