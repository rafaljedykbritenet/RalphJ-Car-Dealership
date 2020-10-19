({
     getOrders : function(component, event, helper) {
         let totalPrice = 5;
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let contactId = component.get("v.contactId");
        let action = component.get("c.searchOrders");
            action.setCallback(this, function(response) {
            let state = response.getState();
            let foundOrders = [];
            for (let i = 0; i < response.getReturnValue().length; i++) {
                foundOrders.push(response.getReturnValue()[i]);
            }
            component.set('v.orders', foundOrders);
            component.set('v.totalOrderPrice', totalPrice);
            component.set('v.totalPrice', formatter.format(totalPrice));
        });
        $A.enqueueAction(action);
     },

     changeTotalPrice : function(component, event, helper) {
         let totalPrice = 5;
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let contactId = component.get("v.contactId");
        let action = component.get("c.searchBasket");
            action.setCallback(this, function(response) {
            if (response.getReturnValue().length != 0){
                totalPrice = response.getReturnValue()[0].orderPrice;
            } else {
                totalPrice = 0;
            }
            if (response.getReturnValue().length == 0){
                let foundCars = undefined;
                component.set('v.cars', foundCars);
            }
            component.set('v.totalOrderPrice', totalPrice);
            component.set('v.totalPrice', formatter.format(totalPrice));
        });
        $A.enqueueAction(action);
        },

     submitOrders : function(component, event, helper) {
        let contactId = component.get("v.contactId");
        let action1 = component.get("c.submitOrder");
            action1.setParams({"siteUserId" : contactId});
            action1.setCallback(this, function(response) {
                 let state = response.getState();
                 console.log("Order Submitted => " + state);
             });
        $A.enqueueAction(action1);
     },

    closeModal:function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    }
})