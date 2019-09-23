({
    autoRedeem : function(cmp, event, helper) {
        var startDate = cmp.get("v.startDate") == null ? null : new Date(cmp.get("v.startDate")).toJSON(); console.log(startDate);
        var endDate = cmp.get("v.endDate") == null ? null : new Date(cmp.get("v.endDate")).toJSON(); console.log(endDate);
        cmp.set('v.showSpinner', true);
        var action = cmp.get("c.createRedemption2");
        action.setParams({
            startDateStr : startDate,
            endDateStr: endDate
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('sucesso');
                cmp.set('v.hideSuccess', false);
                cmp.set('v.showSpinner', false);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if(errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    }
})