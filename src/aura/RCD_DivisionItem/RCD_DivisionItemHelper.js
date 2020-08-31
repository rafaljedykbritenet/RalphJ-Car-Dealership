({
    showErrorToast : function(component, theError) {
        let errorData = JSON.parse(theError.message);
        this.showToast(component, "Error", errorData.name, errorData.message);
    },
})