global class ActivityTimelineModel implements Comparable{
    //All Records
    @AuraEnabled  public Id RecordId {get;set;}    
    @AuraEnabled  public String ActivityTimelineType {get;set;} 
    @AuraEnabled  public String Member {get;set;}  
    @AuraEnabled  public DateTime ActualDate {get;set;}
    @AuraEnabled  public Integer aInt {get;set;} 
    
    //Transactions
    @AuraEnabled  public Decimal Points {get;set;}  
    @AuraEnabled  public String PointType {get;set;}
    //Member Level
    @AuraEnabled  public String Level {get;set;} 
    
    //Course Status
    @AuraEnabled  public String CourseName {get;set;}  
    
    //Module Response
    @AuraEnabled  public String ModuleName {get;set;}    
    @AuraEnabled  public Decimal GradePercent {get;set;} 
    //@AuraEnabled  public String ShortDate {get;set;}    
    //@AuraEnabled  public String EventTime {get;set;}	
    
    //Badge Member
    @AuraEnabled  public String BadgeName {get;set;} 
    
    //Redemption
    @AuraEnabled  public String InvoiceNumber {get;set;} 
    @AuraEnabled  public Integer Items {get;set;}    
    @AuraEnabled  public String Status {get;set;}
    
    global Integer compareTo(Object objToCompare){
        
        DateTime otherActualDate = ((ActivityTimelineModel)objToCompare).ActualDate;
        Long l1 = otherActualDate.getTime(); 
        Long l2 = this.ActualDate.getTime();
        
        Integer result = 0;
        if(l1 > l2){ result = 1;
                   }else if(l1 < l2){
                       result = -1;
                   }
        
        return result;
    }
    
    
}