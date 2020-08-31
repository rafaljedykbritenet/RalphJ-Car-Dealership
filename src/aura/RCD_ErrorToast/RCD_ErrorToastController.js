({
    showNoDivisionsFoundToast: function(component,event,helper) {
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: "No divisions found for such criteria.",
                type: "warning"
            });
        toastEvent.fire();
    }
})