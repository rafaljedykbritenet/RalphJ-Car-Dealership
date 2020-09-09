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

     setAddedToCart: function (component, event, helper) {
        component.set('v.addedToCart', false);
     },

     handleRowSelection: function (component, event, helper) {
        let carSelected = event.getParam("selectedCar");
        component.set('v.selectedCar', carSelected);
     },

     handleSearchClear : function(component, event, helper) {
         component.set("v.selectedCar", undefined);
     },

     addToCart : function(component, event, helper) {
        let contactId = component.get("v.contactId");
        let carId = component.get("v.selectedCar.Id");
        let action = component.get("c.addToBasket");
        let amount = 1;
            action.setParams({"siteUserId" : contactId, "carId" : carId, "amount" : amount, "fromCart" : false});
            action.setCallback(this, function(response) {
            let state = response.getState();
            if (state == "SUCCESS"){
                let toastEvent =$A.get("e.c:RCD_ToastEvent");
                    toastEvent.setParams({"titleParam" : "Great choice!"});
                    toastEvent.setParams({"messageParam" : "This car is in your Cart"});
                    toastEvent.setParams({"typeParam" : "success"});
                    toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        component.set("v.addedToCart", true);
     }
})