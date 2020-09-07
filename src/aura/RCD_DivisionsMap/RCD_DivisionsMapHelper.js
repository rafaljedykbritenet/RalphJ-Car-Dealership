({
    showMarkers: function (component, event, helper) {
        var mapMarkers = [];
        var foundDivisions = component.get("v.foundDivisions");
        if(foundDivisions.length > 0) {
            for(var i = 0; i < foundDivisions.length ; i++) {
                var division = foundDivisions[i];
                var marker = {
                    'location' : {
                        'Street' : division.Street__c,
                        'City' : division.City__c,
                        'Country' : division.Country__c
                    },
                    'title' : division.Name,
                    'icon' : 'standard:location'
                };
                mapMarkers.push(marker);
            }
            component.set('v.mapMarkers', mapMarkers);
            component.set('v.zoomLevel', 4);
        } else {
            component.set('v.mapMarkers', mapMarkers);
            component.set('v.zoomLevel', 1);
        }
        if (foundDivisions.length == 1){
            component.set('v.zoomLevel', 16);
        }
        let mapBorder = component.find('mapBorder');
        $A.util.removeClass(mapBorder, 'itemSelected');
    },

    handleRowSelection: function (component, event, helper) {

        let selectedDivision = event.getParam("selectedDivision");
        var marker = {
            'location' : {
                'Street' : selectedDivision.Street__c,
                'City' : selectedDivision.City__c,
                'Country' : selectedDivision.Country__c
            },
            'title' : selectedDivision.Name,
            'icon' : 'standard:location'
        };
        component.set('v.mapMarkers', marker);
        component.set('v.zoomLevel', 16);
        let mapBorder = component.find('mapBorder');
        $A.util.addClass(mapBorder, 'itemSelected');
    },
})