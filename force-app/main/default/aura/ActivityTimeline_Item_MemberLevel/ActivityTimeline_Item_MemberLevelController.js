({
	doInit : function(cmp, event, helper) {
		var newdate = cmp.get('v.itemDetail.ActualDate');
		cmp.set('v.displayDate', new Date(newdate));
	}
})