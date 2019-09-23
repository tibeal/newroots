trigger F_FeedComment on FeedComment (after insert) {
    
    //Need to Bulkify this!!
    FeedComment fi = trigger.new.get(0);
    
    FieloPLT__Member__c member = [Select id from FieloPLT__Member__c where FieloPLT__User__c = :fi.CreatedById];
    
    if(member != null){
    	FieloPLT__Event__c event = new FieloPLT__Event__c(FieloPLT__Type__c = 'Answer', FieloPLT__Member__c = member.id);
    
	    insert event;
    
    }
    
}