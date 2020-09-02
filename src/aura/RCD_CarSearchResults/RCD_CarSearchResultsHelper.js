({
    addClass : function (component, event, helper) {
        console.log("Add class method in helper");
            let selectedItem = event.currentTarget;
            let carId = selectedItem.dataset.id;
            console.log("Current car Id => " + carId);
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