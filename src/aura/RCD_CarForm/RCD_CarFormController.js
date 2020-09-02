({
        searchForCar : function(component, event, helper) {
            helper.searchForCar(component);
            },
        clear : function(component, event, helper) {
            component.set("v.searchedCar", {'sobjectType': 'Product2', 'Brand__c' : '', 'Model__c' : '', 'Power__c' : ''});
            component.set("v.noCarsFound", false);
            let clearCarSearchEvent =$A.get("e.c:RCD_ClearCarSearch");
            clearCarSearchEvent.fire();
        },
})