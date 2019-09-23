public class AutoRedeemController {
    
    @AuraEnabled
    public static void createRedemption(Datetime startDateStr, Datetime endDateStr){
        System.debug(startDateStr);
        System.debug(endDateStr);
        
        Date startDate,endDate;
        startDate = Date.valueOf(startDateStr); System.debug(startDate);
        endDate = Date.valueOf(endDateStr); System.debug(endDate);
        
        List<FieloPLT__Member__c> members = [SELECT Id, (SELECT Id, CreatedDate, FieloPLT__TotalPoints__c
                                                         FROM FieloPLT__Points__r WHERE FieloPLT__PointType__c = 'a0R1H00000V2yfoUAB' AND FieloPLT__Status__c = 'Approved' AND DAY_ONLY(CreatedDate) >=: startDate AND DAY_ONLY(CreatedDate) <=: endDate) 
                                             FROM FieloPLT__Member__c WHERE Id IN (SELECT FieloPLT__Member__c FROM FieloPLT__Point__c WHERE FieloPLT__PointType__c = 'a0R1H00000V2yfoUAB')];
        System.debug(members);
        
        List<FieloPLT__Redemption__c> redemptions = new List<FieloPLT__Redemption__c>();
        
        for(FieloPLT__Member__c m : members){
            System.debug(m);
            Integer totalpoints = 0;
            for(FieloPLT__Point__c p: m.FieloPLT__Points__r){
                System.debug(p);
                totalpoints += Integer.valueOf(p.FieloPLT__TotalPoints__c); System.debug(totalpoints);
            }
            System.debug('totalpoints: '+ totalpoints);
            Map<Id, Integer> quantityPerReward = new Map<Id, Integer>();
            quantityPerReward.put('a0e1H00000ARl4vQAD', totalpoints);
            if(totalpoints != 0){
                redemptions = FieloPLT.RedemptionService.createRedemptions(quantityPerReward, m.Id);
            }
        }
        System.debug(redemptions);
        
    }
    
    @AuraEnabled
    public static void createRedemption2(Datetime startDateStr, Datetime endDateStr){
        System.debug(startDateStr);     System.debug(endDateStr);
        
        Date startDate,endDate;
        startDate = Date.valueOf(startDateStr); System.debug(startDate);
        
        endDate = Date.valueOf(endDateStr); System.debug(endDate);
        
        AggregateResult[] points = [SELECT FieloPLT__Member__c, SUM(FieloPLT__TotalPoints__c)total FROM FieloPLT__Point__c
                                           WHERE FieloPLT__PointType__c = 'a0R1H00000V2yfoUAB' AND FieloPLT__Status__c = 'Approved' 
                                           AND DAY_ONLY(CreatedDate) >=: startDate AND DAY_ONLY(CreatedDate) <=: endDate
                                          GROUP BY FieloPLT__Member__c ];
        
        Map<Id,Integer> membersMap = new Map<Id,Integer>();
        List<FieloPLT__Redemption__c> redemptions = new List<FieloPLT__Redemption__c>();
        
        for(AggregateResult p : points){
            redemptions.add(new FieloPLT__Redemption__c(FieloPLT__Member__c = (Id)p.get('FieloPLT__Member__c'),
                                                        FieloPLT__Origin__c = 'BackEnd',
                                                        FieloPLT__Status__c = 'Open'));
            membersMap.put((Id)p.get('FieloPLT__Member__c'),Integer.valueOf(p.get('total')));
        }
        
        try{
            insert redemptions;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        
        List<FieloPLT__RedemptionItem__c> redemptionItems = new List<FieloPLT__RedemptionItem__c>();
        for(FieloPLT__Redemption__c r : redemptions){
            redemptionItems.add(new FieloPLT__RedemptionItem__c(FieloPLT__Redemption__c = r.Id,
                                                                FieloPLT__Quantity__c = membersMap.get(r.FieloPLT__Member__c),
                                                                Cash_Points__c	 = membersMap.get(r.FieloPLT__Member__c), 
                                                                FieloPLT__Reward__c = 'a0e1H00000ARl4vQAD',
                                                                FieloPLT__Status__c = 'Ready'));
            r.FieloPLT__Status__c =  'Closed';
        }
        
        
        
        FieloPLT.SObjectService.enableAdminPermission(true);
        try{
            insert redemptionItems;
            update redemptions;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        FieloPLT.SObjectService.enableAdminPermission(false);
    }
}