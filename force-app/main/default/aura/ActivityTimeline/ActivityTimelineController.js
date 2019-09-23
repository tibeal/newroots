({
    doInit : function(cmp, event, helper) {
        var member = cmp.get('v.member');
        var userId;
        if($A.get("$SObjectType.CurrentUser")){
        	userId = $A.get("$SObjectType.CurrentUser.Id"); console.log(userId);
        }
        if(member){
            helper.loadRecords(cmp, event, helper);
        }else{
            window.setTimeout(
                $A.getCallback(function() {
                    var memberId;
                    if(localStorage.getItem('member') != null){
                        console.log('pegou local storage');
                        var member = JSON.parse(localStorage.getItem('member'));
                        memberId = member.Id; console.log(memberId);
                        cmp.set('v.member',memberId);
                        helper.loadRecords(cmp, event, helper);
                    }else if(cmp.get('v.member') == null){
                        var action = cmp.get("c.getMember");
                        action.setParams({
                            "userId" : userId
                        })
                        action.setCallback(this, function(a){
                            console.log('fez query');
                            var members = a.getReturnValue();
                            if(members.length>1){
                                for (var i = 0; i < members.length; i++) {
                                    var row = members[i];
                                    if (row.FieloPLT__Program__r){ 
                                        row.programName = row.FieloPLT__Program__r.Name;
                                    }
                                }
                                cmp.set("v.members", members); console.log(a.getReturnValue());
                            }else{
                                //cmp.set("v.member", members[0]);
                                helper.loadRecords(cmp, event, helper);
                            }
                        });
                        $A.enqueueAction(action);
                    }
                }), 1500
            );                                                              
            
        }
        
    },
    
    paginator : function(cmp, event, helper) {
        var quantity = event.getParam("quantity"); console.log(quantity);
        var i = event.getParam("offset"); console.log(i);
        var max = i + cmp.get('v.quantity'); console.log(max);
        var allRecords = cmp.get('v.allRecords'); console.log('all records:' + allRecords.length);
        var newList = [];
        if(max >= allRecords.length){
            cmp.set('v.lastPage',true);
        }else{
            cmp.set('v.lastPage',false);
        }
        
        for(i; i < max ; i++){
            newList.push(allRecords[i]);
        }
        cmp.set('v.timelineItems',newList);
    },
    
    updateMember : function(cmp, event, helper){
        console.log('pegou evento');
        var member = event.getParam('member');
        cmp.set('v.member', member);
        helper.loadRecords(cmp, event, helper); 
        
    },
    
    updateDates : function(cmp, event, helper){
        var startDate = event.getParam('startDate'); console.log(startDate);
        cmp.set('v.startDate',startDate);       
        var endDate = event.getParam('endDate');  console.log(endDate);
        cmp.set('v.endDate',endDate);       
        
        helper.loadRecords(cmp, event, helper); 
    },
    
    handleChooseMember : function(cmp, event, helper){
        console.log('chegou aqui');
        var member = event.getParam('member'); console.log(member);
        cmp.set('v.member',member);
        console.log(cmp.get('v.member'));
        helper.loadRecords(cmp, event, helper); 
    }
    
    
})