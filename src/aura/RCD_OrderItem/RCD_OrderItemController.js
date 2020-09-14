({
    doInit : function(component, event, helper) {
        var formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'EUR',
        });
        let unitPrice = component.get("v.order.OrderItems[0].UnitPrice");
        let totalPrice = component.get("v.order.TotalAmount");
            component.set("v.unitPrice",  formatter.format(unitPrice));
            component.set("v.totalOrderPrice",  formatter.format(totalPrice));
        },

    openOrder : function(component, event, helper) {
        let openOrderState = component.get("v.orderInformationOpened");
        openOrderState = !openOrderState;
        component.set("v.orderInformationOpened", openOrderState);
        }
})