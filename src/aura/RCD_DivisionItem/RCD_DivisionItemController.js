({
    divisionSelected : function(component, event, helper) {
        let selectedDivision = component.get("v.division");
        let SelectedDivisionUpdateEvent =$A.get("e.c:RCD_SelectedDivisionUpdate");
            SelectedDivisionUpdateEvent.setParams({"selectedDivision" : selectedDivision});
            SelectedDivisionUpdateEvent.fire();
    }
})