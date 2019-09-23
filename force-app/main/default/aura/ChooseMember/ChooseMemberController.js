({
    updateMember : function(cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.member', selectedRows[0]);
        console.log(cmp.get('v.member'));
    },
    
    clickButton : function(cmp, event, helper) {
        var memberEvent = cmp.getEvent("choosemember");
        memberEvent.setParams({
            'member': cmp.get('v.member')
        });
        memberEvent.fire();
    },
})