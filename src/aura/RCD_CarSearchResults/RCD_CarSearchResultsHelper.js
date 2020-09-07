({
    addClass : function (component, event, helper) {
        let selectedItem = event.currentTarget;
        let carId = selectedItem.dataset.id;
        let cars = component.find('listItem');
        for(let i = 0; i< cars.length; i++) {
            let tempId = cars[i].getElement().getAttribute('data-id');
            if (tempId != carId) {
            $A.util.removeClass(cars[i], 'itemSelected');
        } else {
        $A.util.addClass(cars[i], 'itemSelected');
        }
        }
    },
})