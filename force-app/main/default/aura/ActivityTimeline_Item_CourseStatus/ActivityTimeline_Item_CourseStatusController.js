({
	doInit : function(cmp, event, helper) {
        console.log(cmp.get('v.itemDetail'));
        var newdate = cmp.get('v.itemDetail.ActualDate');
		cmp.set('v.displayDate', new Date(newdate));
    }
})