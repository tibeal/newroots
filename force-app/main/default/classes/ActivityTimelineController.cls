public class ActivityTimelineController {
    
    @AuraEnabled
    public static List<ActivityTimelineModel> getActivityTimeline(Id recordId, String startDateStr, String endDateStr, String objMap){
        Map<String, Boolean> enableObjects = (Map<String, Boolean>)Json.deserialize(objMap, Map<String,Boolean>.class); System.debug(enableObjects);
        
        Date startDate,endDate;
        if(!String.isBlank(startDateStr)){
            startDate = Date.valueOf(startDateStr);
        }
        if(!String.isBlank(endDateStr)){
            endDate = Date.valueOf(endDateStr);
        }
        List<ActivityTimelineModel> returnList = new List<ActivityTimelineModel>();
        
        if(enableObjects.get('transactions')){ addTransactions(returnList, recordId, startDate, endDate);  }
        if(enableObjects.get('memberlevel')){ addMemberLevels(returnList, recordId, startDate, endDate); }
        if(enableObjects.get('moduleresponse')){ addModuleResponses(returnList, recordId, startDate, endDate); }
        if(enableObjects.get('coursestatus')){ addCourseStatus(returnList, recordId, startDate, endDate); }
        if(enableObjects.get('badgemember')){ addBadgeMember(returnList, recordId, startDate, endDate); }
        if(enableObjects.get('redemption')){ addRedemption(returnList, recordId, startDate, endDate); }
        if(enableObjects.get('invoice')){ addInvoice(returnList, recordId, startDate, endDate); }
        
        returnList.sort();
        System.Debug(returnList);       
        return returnList; 
        
    }
    
    @AuraEnabled
    public static void addMemberLevels(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        
        String query = 'SELECT Id, Name, FieloPLT__Level__r.Name, FieloPLT__Member__c, CreatedDate FROM FieloPLT__LevelMember__c ';
        String whereClause = 'WHERE FieloPLT__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND CreatedDate >=: startDate ';
        }else{
            whereClause += ' AND CreatedDate = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND CreatedDate <=: endDate';
        }       
        
        List<FieloPLT__LevelMember__c> memberLevelList = Database.query(query+whereClause);
        
        System.Debug('Member Level = '+memberLevelList.size());
        System.Debug(memberLevelList);
        if(memberLevelList.size() > 0){
            for(FieloPLT__LevelMember__c ml: memberLevelList){
                System.debug('entering first task');
                
                ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                
                timelineItem.RecordId = ml.Id;
                timelineItem.ActivityTimelineType = 'MemberLevel';
                timelineItem.ActualDate = ml.CreatedDate;
                timelineItem.Level = ml.FieloPLT__Level__r.Name;
                timelineItem.Member = ml.FieloPLT__Member__c;
                timelineItem.aInt = ml.CreatedDate.getTime().intValue();
                
                returnList.add(timelineItem);
                
            }
        }
    }
    
    @AuraEnabled
    public static void addTransactions(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        System.debug(startDate);
        System.debug(endDate);
        
        String query = 'SELECT Id, FieloPLT__Transaction__c, FieloPLT__Member__c, FieloPLT__PointType__r.Name,  FieloPLT__TotalPoints__c, CreatedDate FROM FieloPLT__Point__c ';
        String whereClause = 'WHERE FieloPLT__Transaction__c != NULL AND FieloPLT__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND CreatedDate >=: startDate ';
        }else{
            whereClause += ' AND CreatedDate = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND CreatedDate <=: endDate';
        }       
        
        List<FieloPLT__Point__c> pointsList = Database.query(query+whereClause);
        
        System.Debug('Transactions = '+pointsList.size());
        
        if(pointsList.size() > 0){
            for(FieloPLT__Point__c t: pointsList){
                
                ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                
                timelineItem.RecordId = t.Id;
                timelineItem.ActivityTimelineType = 'Transaction';
                timelineItem.ActualDate = t.CreatedDate;
                timelineItem.PointType = t.FieloPLT__PointType__r.Name.toLowerCase()+'s';
                timelineItem.Points = t.FieloPLT__TotalPoints__c;
                timelineItem.Member = t.FieloPLT__Member__c;
                timelineItem.aInt = t.CreatedDate.getTime().intValue();
                
                returnList.add(timelineItem);
                
            }
        }
    }
    
    @AuraEnabled
    public static void addModuleResponses(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        String query = 'SELECT Id, FieloELR__IsApproved__c, FieloELR__Module__r.Name, FieloELR__GradePercent__c, FieloELR__Member__c, CreatedDate FROM FieloELR__ModuleResponse__c ';
        String whereClause = 'WHERE FieloELR__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND CreatedDate >=: startDate ';
        }else{
            whereClause += ' AND CreatedDate = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND CreatedDate <=: endDate';
        }       
        
        List<FieloELR__ModuleResponse__c> moduleList = Database.query(query+whereClause);
        
        System.Debug('Member Level = '+moduleList.size());
        
        if(moduleList.size() > 0){
            for(FieloELR__ModuleResponse__c t: moduleList){
                System.debug('entering second task');
                if(t.FieloELR__IsApproved__c == true){
                    ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                    
                    timelineItem.RecordId = t.Id;
                    timelineItem.ActivityTimelineType = 'ModuleResponse';
                    timelineItem.ActualDate = t.CreatedDate;
                    timelineItem.ModuleName = t.FieloELR__Module__r.Name;
                    timelineItem.Member = t.FieloELR__Member__c;
                    timelineItem.GradePercent = t.FieloELR__GradePercent__c;
                    timelineItem.aInt = t.CreatedDate.getTime().intValue();
                    
                    returnList.add(timelineItem);
                }
            }
        }
    }
    
    @AuraEnabled
    public static void addCourseStatus(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        String query = 'SELECT Id, FieloELR__Course_Accomplished__c, FieloELR__Course__r.Name,FieloELR__Member__c, FieloELR__CompletedDate__c FROM FieloELR__CourseStatus__c ';
        String whereClause = 'WHERE FieloELR__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND FieloELR__CompletedDate__c >=: startDate ';
        }else{
            whereClause += ' AND FieloELR__CompletedDate__c = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND FieloELR__CompletedDate__c <=: endDate';
        }       
        
        List<FieloELR__CourseStatus__c> courseList = Database.query(query+whereClause);
        
        System.Debug('Member Level = '+courseList.size());
        
        if(courseList.size() > 0){
            for(FieloELR__CourseStatus__c t: courseList){
                System.debug('entering second task');
                if(t.FieloELR__Course_Accomplished__c == true){
                    ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                    
                    timelineItem.RecordId = t.Id;
                    timelineItem.ActivityTimelineType = 'CourseStatus';
                    timelineItem.ActualDate = t.FieloELR__CompletedDate__c;
                    timelineItem.CourseName = t.FieloELR__Course__r.Name;
                    timelineItem.Member = t.FieloELR__Member__c;
                    timelineItem.aInt = t.FieloELR__CompletedDate__c.getTime().intValue();
                    returnList.add(timelineItem);
                }
            }
        }
    }
    
    @AuraEnabled
    public static void addBadgeMember(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        String query = 'SELECT Id, FieloPLT__Member__c, FieloPLT__Badge__r.Name, CreatedDate FROM FieloPLT__BadgeMember__c ';
        String whereClause = 'WHERE FieloPLT__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND CreatedDate >=: startDate ';
        }else{
            whereClause += ' AND CreatedDate = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND CreatedDate <=: endDate';
        }       
        
        List<FieloPLT__BadgeMember__c> badgeList = Database.query(query+whereClause);
        
        System.Debug('Badge Member = '+badgeList.size());
        
        if(badgeList.size() > 0){
            for(FieloPLT__BadgeMember__c t: badgeList){
                ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                
                timelineItem.RecordId = t.Id;
                timelineItem.ActivityTimelineType = 'BadgeMember';
                timelineItem.ActualDate = t.CreatedDate;
                timelineItem.BadgeName = t.FieloPLT__Badge__r.Name;
                timelineItem.Member = t.FieloPLT__Member__c;
                timelineItem.aInt = t.CreatedDate.getTime().intValue();
                
                returnList.add(timelineItem);
            }
        }
        
    }
    
    @AuraEnabled
    public static void addRedemption(List<ActivityTimelineModel> returnList, Id recordId, Date startDate, Date endDate){
        String query = 'SELECT Id, FieloPLT__Member__c, FieloPLT__Points__c, (SELECT Id FROM FieloPLT__RedemptionItems__r), Cash_Points__c, Growth_Point__c, CreatedDate FROM FieloPLT__Redemption__c ';
        String whereClause = 'WHERE FieloPLT__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDate))){
            whereClause += ' AND CreatedDate >=: startDate ';
        }else{
            whereClause += ' AND CreatedDate = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDate))){
            whereClause += ' AND CreatedDate <=: endDate';
        }       
        
        List<FieloPLT__Redemption__c> redemptionList = Database.query(query+whereClause);
        
        System.Debug('Redemption = '+redemptionList.size());
        
        if(redemptionList.size() > 0){
            for(FieloPLT__Redemption__c t: redemptionList){
                ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                
                Integer items = t.FieloPLT__RedemptionItems__r.size();
                
                timelineItem.RecordId = t.Id;
                timelineItem.ActivityTimelineType = 'Redemption';
                timelineItem.ActualDate = t.CreatedDate;
                timelineItem.Items = items;
                timelineItem.Member = t.FieloPLT__Member__c;
                timelineItem.aInt = t.CreatedDate.getTime().intValue();
                if(t.FieloPLT__Points__c != 0){
                    timelineItem.Points = t.FieloPLT__Points__c;
                    timelineItem.PointType = 'points';
                }else if(t.Cash_Points__c != 0){
                    timelineItem.Points = t.Cash_Points__c;
                    timelineItem.PointType = 'cash points';
                }else if(t.Growth_Point__c != 0){
                    timelineItem.Points = t.Growth_Point__c;
                    timelineItem.PointType = 'growth points';
                }
                returnList.add(timelineItem);
            }
        }
    }
    
    @AuraEnabled
    public static void addInvoice(List<ActivityTimelineModel> returnList, Id recordId, Date startDateStr, Date endDateStr){
        
        String query = 'SELECT Id, Name, FieloPRP__Member__c, FieloPRP__InvoiceNumber__c,FieloPRP__Status__c,FieloPRP__ApprovedDate__c, SystemModstamp, CreatedDate FROM FieloPRP__Invoice__c ';
        String whereClause = 'WHERE FieloPRP__Member__c =: recordId ';
        
        if(!String.isBlank(String.valueOf(startDateStr))){
            whereClause += ' AND SystemModstamp >=: startDateStr ';
        }else{
            whereClause += ' AND SystemModstamp = LAST_N_DAYS:30 ';
        }
        if(!String.isBlank(String.valueOf(endDateStr))){
            whereClause += ' AND SystemModstamp <=: endDateStr';
        }       
        List<FieloPRP__Invoice__c> invoiceList;
        System.Debug(query+whereClause);
        try{
            invoiceList = Database.query(query+whereClause); System.debug(invoiceList);
        }catch(QueryException qe){
            System.debug(qe.getMessage());
        }
        
        
        System.Debug(invoiceList.size());
        System.Debug('Invoices = '+invoiceList.size());
        
        if(invoiceList.size() > 0){
            for(FieloPRP__Invoice__c t: invoiceList){
                if(t.FieloPRP__Status__c == 'Open'){
                    ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                    
                    timelineItem.RecordId = t.Id;
                    timelineItem.ActivityTimelineType = 'Invoice';
                    timelineItem.ActualDate = t.CreatedDate;
                    timelineItem.Member = t.FieloPRP__Member__c;
                    timelineItem.Status = t.FieloPRP__Status__c;
                    if(String.isNotBlank(t.FieloPRP__InvoiceNumber__c)){
                        timelineItem.InvoiceNumber = t.FieloPRP__InvoiceNumber__c;
                    }else{
                        timelineItem.InvoiceNumber = t.Name;
                    }
                    returnList.add(timelineItem);
                }else{
                    ActivityTimelineModel timelineItem = new ActivityTimelineModel();
                    
                    timelineItem.RecordId = t.Id;
                    timelineItem.ActivityTimelineType = 'Invoice';
                    timelineItem.ActualDate = t.CreatedDate;
                    timelineItem.Member = t.FieloPRP__Member__c;
                    timelineItem.Status = 'Open';
                    if(String.isNotBlank(t.FieloPRP__InvoiceNumber__c)){
                        timelineItem.InvoiceNumber = t.FieloPRP__InvoiceNumber__c;
                    }else{
                        timelineItem.InvoiceNumber = t.Name;
                    }
                    returnList.add(timelineItem);
                    
                    ActivityTimelineModel timelineItem2 = new ActivityTimelineModel();
                    
                    timelineItem2.RecordId = t.Id;
                    timelineItem2.ActivityTimelineType = 'Invoice';
                    timelineItem2.ActualDate = t.CreatedDate;
                    timelineItem2.Member = t.FieloPRP__Member__c;
                    timelineItem2.Status = t.FieloPRP__Status__c;
                    if(String.isNotBlank(t.FieloPRP__InvoiceNumber__c)){
                        timelineItem2.InvoiceNumber = t.FieloPRP__InvoiceNumber__c;
                    }else{
                        timelineItem2.InvoiceNumber = t.Name;
                    }
                    returnList.add(timelineItem2);
                }
            }
        }
        
    }
    
    @AuraEnabled
    public static FieloPLT__Member__c[] getMember(Id userId){
        if(String.isBlank(userId)){
            userId = UserInfo.getUserId();
        }
        List<FieloPLT__Member__c> members = [SELECT Id, Name, FieloPLT__Program__r.Name FROM FieloPLT__Member__c WHERE FieloPLT__User__c =: userId];
        return members;
    }
    
}