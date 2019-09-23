trigger F_FeedItem on FeedItem (after insert) {
    
    //Need to Bulkify this!!
    FeedItem fi = trigger.new.get(0);
    
    FieloPLT__Member__c member = [Select id from FieloPLT__Member__c where FieloPLT__User__c = :fi.CreatedById];
    
    if(member != null){
        FieloPLT__Event__c event = new FieloPLT__Event__c(FieloPLT__Type__c = 'Question', FieloPLT__Member__c = member.id);
        insert event;
    }
}