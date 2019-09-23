({    
	previous: function(component, event, helper){        
		var page = component.get('v.page'); console.log("page antes:"+page);
        var quantity = component.get('v.quantity');
        page --;
        component.set('v.page', page); console.log("page depois:"+component.get('v.page'));
        var offset = page * quantity; console.log("offset:"+offset);     
        var paging = component.getEvent("paging");
        paging.setParams({"offset": offset, "quantity": quantity});
        paging.fire();
    },
    next: function(component, event, helper){        
        var page = component.get('v.page'); console.log("page antes:"+page);
        var quantity = component.get('v.quantity');
        page ++;
        component.set('v.page', page); console.log("page depois:"+component.get('v.page'));
        var offset = page * quantity; console.log("offset:"+offset);                
        var paging = component.getEvent("paging");
        paging.setParams({"offset": offset, "quantity": quantity});
        paging.fire();
    }
})