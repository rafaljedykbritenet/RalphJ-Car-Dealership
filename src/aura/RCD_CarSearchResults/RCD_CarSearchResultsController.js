({
    addClass : function (component, event, helper) {
        helper.addClass(component, event, helper);
    },

    handleCarsSelect : function(component, event, helper) {
         let sCars = event.getParam("foundCars");
         component.set("v.cars", sCars);
         component.set("v.carFound", sCars[0]);
        },

    handleSearchClear : function(component, event, helper) {
         component.set("v.carFound", undefined);
        },

    closeModal:function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    openmodal: function(component,event,helper) {
        let addToCartEvent =$A.get("e.c:RCD_CarAddedToCartEvent");
            addToCartEvent.fire();
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    }
})