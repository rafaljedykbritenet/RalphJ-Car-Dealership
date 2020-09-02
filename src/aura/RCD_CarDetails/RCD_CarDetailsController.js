({
    navigateToCar : function(component, event, helper) {
        helper.navigateToCar(component, event, helper);
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
        let carSelected = event.getParam("selectedCar");
        component.set('v.selectedCar', carSelected);
        },

     handleSearchClear : function(component, event, helper) {
         component.set("v.selectedCar", undefined);
     },
})