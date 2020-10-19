({
    doInit : function(component, event, helper) {
        let carId = component.get("v.car.PricebookEntry.Product2.Picture__c");
        component.set("v.carURL", carId);
        let amount = component.get("v.car.Quantity");
        component.set("v.amountForOneType", amount);
        let carAmountAvailable = component.get("v.car.PricebookEntry.Product2.Amount__c");
        let carAmountList = component.get("v.carAmount");
        for(let i=0; i <= carAmountAvailable; i++){

            carAmountList.push(i);

        }
        component.set("v.carAmount", carAmountList.sort());

        var formatter = new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: 'EUR',
        });

        let unitPrice = component.get("v.car.UnitPrice");
        let totalPrice = unitPrice * amount;
            component.set("v.unitPriceForOneType",  formatter.format(unitPrice));
            component.set("v.totalPriceForOneType",  formatter.format(totalPrice));
            component.set("v.totalUnformatedPriceForOneType",  totalPrice);

    },

    updateAmount : function(component, event, helper) {
        let amount = component.get("v.amountForOneType");
        let carAmountAvailable = component.get("v.car.PricebookEntry.Product2.Amount__c");
        if (amount <= carAmountAvailable && amount >= 0) {
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let contactId = component.get("v.contactId");
        let totalForOne = component.get("v.totalUnformatedPriceForOneType");
        let totalOrderPrice = component.get("v.totalOrderPrice");
            totalOrderPrice = totalOrderPrice - totalForOne;
        let carId = component.get("v.car.PricebookEntry.Product2.Id");
//        let amount = component.get("v.amountForOneType");
//        let carAmountAvailable = component.get("v.car.PricebookEntry.Product2.Amount__c");
//        if (amount <= carAmountAvailable)
        let totalPrice = component.get("v.car.UnitPrice");
            totalPrice = totalPrice * amount;
            totalOrderPrice = totalOrderPrice + totalPrice;
        component.set("v.totalPriceForOneType", formatter.format(totalPrice));

        let action = component.get("c.addToBasket");
            action.setParams({"siteUserId" : contactId, "carId" : carId, "amount" : amount, "fromCart" : true});
            action.setCallback(this, function(response) {
            let state = response.getState();
            });
        $A.enqueueAction(action);

        component.set("v.amountChange", false);
        let updateTotalBasketPriceEvent = component.getEvent("RCD_UpdateBasketTotalPriceEvent");
            updateTotalBasketPriceEvent.fire();
            if (amount == 0) {
            component.set("v.carInBasket", false);
        }
        }
        },

    carSelected : function(component, event, helper) {
        let selectedCar = component.get("v.car");
        let SelectedCarUpdateEvent =$A.get("e.c:RCD_SelectedCarUpdate");
            SelectedCarUpdateEvent.setParams({"selectedCar" : selectedCar});
            SelectedCarUpdateEvent.fire();
    },

    deleteCarFromCart : function(component, event, helper) {
        component.set("v.amountForOneType", 0);
        let deleteAction = component.get("c.updateAmount");
        $A.enqueueAction(deleteAction);
    }

})