({
    navigateToDivision : function(component, event, helper) {
        helper.navigateToDivision(component, event, helper);
    },

    openEditDialog: function(component, event, helper){
        component.set("v.editActive", true);
    },

    cancel: function(component, event, helper) {
        component.set("v.editActive", false);
    },

    save : function(component, event, helper){
        component.find("edit").get("e.recordSave").fire();
        component.set("v.editActive", false);
    },

     handleRowSelection: function (component, event, helper) {
        let divisionSelected = event.getParam("selectedDivision");
        component.set('v.selectedDivision', divisionSelected);
        },

     handleSearchClear : function(component, event, helper) {
         component.set("v.selectedDivision", undefined);
     },
})