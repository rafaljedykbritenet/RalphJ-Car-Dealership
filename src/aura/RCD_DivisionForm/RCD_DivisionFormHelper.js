({
    searchForDivision : function(component) {
    let theSpinner = component.find("spinner");
		let clearDivisionSearchEvent = $A.get("e.c:RCD_ClearDivisionSearch");
        clearDivisionSearchEvent.fire();

        let searchedDivision = component.get("v.searchedDivision");
        let action = component.get("c.searchDivisions");
        action.setParams({"searchedDivision" : searchedDivision});
        theSpinner.showSpinner(component);

        action.setCallback(this, function(response) {
        let state = response.getState();

            if (state === "SUCCESS") {
                if (response.getReturnValue().length == 0) {
                    component.set("v.noDivisionsFound", false);
                    if (searchedDivision.Country__c != "") {
                        let searchResultsEmptyEvent =$A.get("e.c:RCD_NoDivisionsFound");
                            searchResultsEmptyEvent.fire();
                    }
                    theSpinner.hideSpinner();
                    return;
                } else if (response.getReturnValue().length == 1) {
                     component.set("v.noDivisionsFound", false);
                     let foundDivision = response.getReturnValue()[0].division;
                     let searchResults =$A.get("e.c:RCD_SelectedDivisionUpdate");
                        searchResults.setParams({"selectedDivision" : foundDivision});
                        searchResults.fire();
                }
                component.set("v.noDivisionsFound", false);
                let foundDivisions = [];
                for (let i = 0; i < response.getReturnValue().length; i++) {
                    foundDivisions.push(response.getReturnValue()[i].division);
                }
                theSpinner.hideSpinner();
                let setDivisionsMarkersEvent =$A.get("e.c:RCD_SetDivisionsMarkers");
                setDivisionsMarkersEvent.setParams({"foundDivisions" : foundDivisions});
        		setDivisionsMarkersEvent.fire();

            } else if (state === "ERROR") {
                let errors = response.getError()[0];
//                helper.showErrorToast(component, errors);
//                theSpinner.hideSpinner();
                }
        });
        $A.enqueueAction(action);
    }
})