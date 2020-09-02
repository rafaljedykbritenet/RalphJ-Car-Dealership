({
    handleDivisionSelect : function(component, event, helper) {
        let sDivision = event.getParam("chosenDivision");
        component.set("v.selectedDivision", sDivision);
    },
    
    handleDivisionsSelect : function(component, event, helper) {
        let sDivisions = event.getParam("chosenDivisions");
        component.set("v.selectedDivisions", sDivisions);
    },

    handleSearchClear : function(component, event, helper) {
        component.set("v.divisions", '[]');
    },
})