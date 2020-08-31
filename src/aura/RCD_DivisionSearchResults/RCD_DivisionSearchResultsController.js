({
    addClass : function (component, event, helper) {
        helper.addClass(component, event, helper);
    },

    handleDivisionsSelect : function(component, event, helper) {
         let sDivisions = event.getParam("foundDivisions");
         component.set("v.divisions", sDivisions);
         component.set("v.divisionFound", sDivisions[0]);
        },

    handleSearchClear : function(component, event, helper) {
         component.set("v.divisionFound", undefined);
        },
})