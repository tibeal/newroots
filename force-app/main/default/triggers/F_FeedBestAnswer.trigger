trigger F_FeedBestAnswer on FeedItem (after update) {

    
    //Need to Bulkify this!!
    FeedItem newFi = trigger.new.get(0);
    FeedItem oldFi = trigger.old.get(0);
    
    
    if(newFi != null &&
       oldFI != null && 
       newFI.BestCommentId != oldFI.BestCommentId){
    	FeedItem BestAnswerFI = [Select id,CreatedById from FeedItem where id = :newFI.BestCommentId];
        FieloPLT__Member__c member = [Select id from FieloPLT__Member__c where FieloPLT__User__c = :BestAnswerFI.CreatedById];
           if(member != null){
        	FieloPLT__Event__c event = new FieloPLT__Event__c(FieloPLT__Type__c = 'Best Answer', FieloPLT__Member__c = member.id);
			insert event;       
           }
    	
    }
    
    	
}