({
    submitComplainOne : function(component, event, helper) {
        let contactId = component.get("v.contactId");
        let subject = component.get("v.complainForm.Subject");
        let description = component.get("v.complainForm.Description");
        let model = component.get("v.complainForm.ComplainCarModel__c");
        let order = component.get("v.complainForm.Order__c");
        let brand = component.get("v.complainForm.ComplainCarBrand__c");
        let action1 = component.get("c.submitComplain");
            action1.setParams({"siteUserId" : contactId, "complainSubject" : subject, "complainDescription" : description, "complainBrand" : brand, "complainModel" : model, "order" : order });
            action1.setCallback(this, function(response) {
                let state = response.getState();
                let toastEvent =$A.get("e.c:RCD_ToastEvent");
                toastEvent.setParams({"titleParam" : "Thank you."});
                toastEvent.setParams({"messageParam" : "Your question will be answered shortly."});
                toastEvent.setParams({"typeParam" : "success"});
                toastEvent.fire();
                });
        $A.enqueueAction(action1);
        component.set("v.complainForm.Subject", '');
        component.set("v.complainForm.Description", '');
        component.set("v.complainForm.ComplainCarModel__c", '');
        component.set("v.complainForm.Order__c", '');
        component.set("v.complainForm.ComplainCarBrand__c", undefined);
        component.set("v.complainComplete", false);
    },

    verifyComplainState : function(component, event, helper) {
        let subjectState = component.get("v.complainForm.Subject");
        let descriptionState = component.get("v.complainForm.Description");
        if (subjectState.length > 0 && descriptionState.length >5){
            component.set("v.complainComplete", true);
        } else {
            component.set("v.complainComplete", false);
        }
    }
})