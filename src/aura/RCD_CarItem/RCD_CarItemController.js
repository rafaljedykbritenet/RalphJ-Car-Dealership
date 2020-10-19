({
    doInit : function(component, event, helper) {
        let carId = component.get("v.car.Picture__c");
        component.set("v.carURL", carId);
        var formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'EUR',
        });
        let unitPrice = component.get("v.car.Price__c");
        component.set("v.unitPriceForOneType",  formatter.format(unitPrice));
        },

    carSelected : function(component, event, helper) {
        let selectedCar = component.get("v.car");
        let SelectedCarUpdateEvent =$A.get("e.c:RCD_SelectedCarUpdate");
        SelectedCarUpdateEvent.setParams({"selectedCar" : selectedCar});
        SelectedCarUpdateEvent.fire();
   }
})