({
    searchForDivision : function(component, event, helper) {
        helper.searchForDivision(component);
    },
    clear : function(component, event, helper) {
        component.set("v.searchedDivision", {'sobjectType': 'Division__c', 'Name' : '', 'Email__c' : '', 'Country__c' : '', 'City__c' : ''});
        component.set("v.noDivisionsFound", false);
        let clearDivisionSearchEvent =$A.get("e.c:RCD_ClearDivisionSearch");
        clearDivisionSearchEvent.fire();
    },
})