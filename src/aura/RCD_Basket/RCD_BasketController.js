({
     getBasket : function(component, event, helper) {
        let theSpinner = component.find("spinner");
        let totalPrice = 5;
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let action = component.get("c.searchBasket");
            theSpinner.showSpinner(component);
            action.setCallback(this, function(response) {
            let state = response.getState();
            let foundCars = [];
            if (response.getReturnValue().length != 0){
                totalPrice = response.getReturnValue()[0].orderPrice;
            } else {
                totalPrice = 0;

            }
            for (let i = 0; i < response.getReturnValue().length; i++) {
                foundCars.push(response.getReturnValue()[i].carItem);
            }
            theSpinner.hideSpinner();
            component.set('v.cars', foundCars);
            component.set('v.totalOrderPrice', totalPrice);
            component.set('v.totalPrice', formatter.format(totalPrice));
        });
        $A.enqueueAction(action);
     },

     changeTotalPrice : function(component, event, helper) {
         let theSpinner = component.find("spinner");
         let totalPrice = 5;
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let action = component.get("c.searchBasket");
            theSpinner.showSpinner(component);
            action.setCallback(this, function(response) {
            if (response.getReturnValue().length != 0){
                totalPrice = response.getReturnValue()[0].orderPrice;
            } else {
                totalPrice = 0;
                let foundCars = undefined;
                component.set('v.cars', foundCars);
            }
            component.set('v.totalOrderPrice', totalPrice);
            component.set('v.totalPrice', formatter.format(totalPrice));
            theSpinner.hideSpinner();
        });
        $A.enqueueAction(action);
        },

        submitOrders : function(component, event, helper) {
                let theSpinner = component.find("spinner");
                let action1 = component.get("c.submitOrder");
                    action1.setParams({"siteUserId" : ''});
                    theSpinner.showSpinner(component);
                    action1.setCallback(this, function(response) {
                            let state = response.getState();
                            let toastEvent =$A.get("e.c:RCD_ToastEvent");
                                                    toastEvent.setParams({"titleParam" : "Thank you!"});
                                                    toastEvent.setParams({"messageParam" : "Your order has been submitted"});
                                                    toastEvent.setParams({"typeParam" : "success"});
                                                    toastEvent.fire();
                        });
                theSpinner.hideSpinner();

                $A.enqueueAction(action1);
                let action2 = component.get("c.closeModal");
                $A.enqueueAction(action2);
                let action3 = component.get("c.getBasket");
                                $A.enqueueAction(action3);
                },

     closeModal : function(component,event,helper){
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