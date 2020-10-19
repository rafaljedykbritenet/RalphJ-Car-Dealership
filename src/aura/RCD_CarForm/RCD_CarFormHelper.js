({
    searchForCar : function(component) {
    let theSpinner = component.find("spinner");
		let clearCarSearchEvent = $A.get("e.c:RCD_ClearCarSearch");
        clearCarSearchEvent.fire();
        let searchedCar = component.get("v.searchedCar");
        let action = component.get("c.searchCars");
        action.setParams({"searchedCar" : searchedCar});
        theSpinner.showSpinner(component);
        action.setCallback(this, function(response) {
        let state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().length == 0) {
                    component.set("v.noCarsFound", false);
                        console.log('No cars found before event fire => ' + response.getReturnValue().length);
                        let searchResultsEmptyEvent =$A.get("e.c:RCD_NoCarsFound");
                            searchResultsEmptyEvent.fire();
                    theSpinner.hideSpinner();
                    return;
                } else if (response.getReturnValue().length == 1) {
                     component.set("v.noCarsFound", false);
                     let foundCar = response.getReturnValue()[0].car;
                     let searchResults =$A.get("e.c:RCD_SelectedCarUpdate");
                        searchResults.setParams({"selectedCar" : foundCar});
                        searchResults.fire();
                }
                component.set("v.noCarsFound", false);
                let foundCars = [];
                for (let i = 0; i < response.getReturnValue().length; i++) {
                    foundCars.push(response.getReturnValue()[i].car);
                }
                theSpinner.hideSpinner();
                let setCarsEvent =$A.get("e.c:RCD_SetCars");
                setCarsEvent.setParams({"foundCars" : foundCars});
        		setCarsEvent.fire();

            } else if (state === "ERROR") {
                let errors = response.getError()[0];
                helper.showErrorToast(component, errors);
                theSpinner.hideSpinner();
                }
        });
        $A.enqueueAction(action);
    }
})