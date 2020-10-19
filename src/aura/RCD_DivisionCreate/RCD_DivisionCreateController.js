({
	closeModal : function(component, event, helper) {
		let closeModalEvent = component.getEvent("closeModal");
        closeModalEvent.fire();
	}
})