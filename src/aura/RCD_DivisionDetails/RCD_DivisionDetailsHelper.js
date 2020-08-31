({
	navigateToDivision : function(component, event, helper) {
            let navigateToSObjectEvent = $A.get('e.force:navigateToSObject');
            navigateToSObjectEvent.setParams({"recordId" : component.get("v.selectedDivision.Id")});
            navigateToSObjectEvent.fire(); 
        },
})