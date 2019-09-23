({
    loadRecords : function(cmp, event, helper) {
        
        var member = cmp.get('v.member'); console.log(member);
        var startDate = cmp.get("v.startDate") == null ? null : new Date(cmp.get("v.startDate")).toJSON(); console.log(startDate);
        var endDate = cmp.get("v.endDate") == null ? null : new Date(cmp.get("v.endDate")).toJSON(); console.log(endDate);
        
        var objMap = {};
        objMap.transactions = cmp.get("v.transactions");
        objMap.memberlevel = cmp.get("v.memberlevel");
        objMap.moduleresponse = cmp.get("v.moduleresponse");
        objMap.coursestatus = cmp.get("v.coursestatus");
        objMap.badgemember = cmp.get("v.badgemember");
        objMap.redemption = cmp.get("v.redemption");
        objMap.invoice = cmp.get("v.invoice");
        
        console.log(objMap);
        
        var action = cmp.get("c.getActivityTimeline");
        action.setParams({
            "recordId" : member.Id,
            "startDateStr": startDate,
            "endDateStr": endDate,
            "objMap": JSON.stringify(objMap)
        })
        
        action.setCallback(this, function(a){
            cmp.set("v.allRecords", a.getReturnValue()); console.log(a.getReturnValue());
            var response = a.getReturnValue();
            var initialList = [];
            var max = cmp.get('v.quantity'); console.log('offset aqui:'+max);
            for(var i =0; i < max; i++){
                console.log(i);
                initialList.push(response[i]);
                console.log(response[i]);
            }
            cmp.set('v.timelineItems',initialList); console.log(initialList);
        });
        
        // queue action on the server
        $A.enqueueAction(action);
    }
})