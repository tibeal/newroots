trigger F_SurveyTrg0 on SurveyResponse (after update) {

    if(trigger.new.get(0) != null){
        
        FieloPLT__Event__c event = new FieloPLT__Event__c();
        SurveyResponse sr = new SurveyResponse();
        
    	id userid = UserInfo.getUserId();
        
        List <FieloPLT__Member__c> members = [Select id from FieloPLT__Member__c where FieloPLT__User__c = :userid];
        
        if(members != null){
            for(FieloPLT__Member__c m : members){
            	event.FieloPLT__Type__c = 'Survey';
            	event.FieloPLT__Member__c = m.id;    
            }
        }
        insert event;
        }
}