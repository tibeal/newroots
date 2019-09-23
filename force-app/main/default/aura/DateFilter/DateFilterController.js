({
    
    checkEndDate: function(cmp, event, helper) {
        console.log('chamou js');
        var startDate = cmp.get('v.startDate'); console.log(startDate);
        var endDate = cmp.get('v.endDate'); console.log(endDate); 
        if(endDate < startDate){
            console.log('data errada');
            cmp.set('v.dateValidationError',true);
            cmp.set('v.enableButton',true);
        }else{
            console.log('data certa');
            cmp.set('v.enableButton',false);
            cmp.set('v.dateValidationError',false);
        }
    },
    
    updateDates : function(cmp, event, helper) {
        console.log('pegou clique');
        var cmpEvent = cmp.getEvent("datefilter");
        cmpEvent.setParams({
            "startDate" : cmp.get("v.startDate"),
            "endDate" : cmp.get("v.endDate")
        });
        cmpEvent.fire();
    },
    
    logDates: function(cmp, event, helper) {
        console.log('logou evento');
        
        console.log(cmp.get("v.startDate"));
        console.log(cmp.get("v.endDate"));
        
    }
})