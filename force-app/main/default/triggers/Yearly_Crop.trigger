trigger Yearly_Crop on Fielo_Yearly_Crop__c (after delete, after insert, after update, before delete, before insert, before update){
  
  if(Trigger.isAfter){
    if(Trigger.isInsert){
        FieloPLT.SObjectService.processRecords(Trigger.new, null);  
    }else if(Trigger.isUpdate){
        FieloPLT.SObjectService.processRecords(Trigger.new, Trigger.oldMap);
    }
  }
  
}