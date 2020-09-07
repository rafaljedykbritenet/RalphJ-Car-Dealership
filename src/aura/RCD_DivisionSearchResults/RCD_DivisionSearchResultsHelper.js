({
    addClass : function (component, event, helper) {
        let selectedItem = event.currentTarget;
        let divisionId = selectedItem.dataset.id;
        let divisions = component.find('listItem');
        for(let i = 0; i< divisions.length; i++) {
            let tempId = divisions[i].getElement().getAttribute('data-id');
            if (tempId != divisionId) {
               $A.util.removeClass(divisions[i], 'itemSelected');
            } else {
                $A.util.addClass(divisions[i], 'itemSelected');
            }
        }
        },
})