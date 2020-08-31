({
    handleDivisionsSelect : function(component, event, helper) {
        let foundDivisions = event.getParam("foundDivisions");
        component.set("v.foundDivisions", foundDivisions);
        component.set("v.divisionFound", foundDivisions[0]);
    },
 
    showMarkers: function (component, event, helper) {
        helper.showMarkers(component, event, helper);
    },

    handleRowSelection: function (component, event, helper) {
        helper.handleRowSelection(component, event, helper);
    },

    handleSearchClear : function(component, event, helper) {
        component.set("v.divisionFound", undefined);
       },
})