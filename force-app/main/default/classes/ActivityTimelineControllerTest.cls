@isTest(SeeAllData=true)
public class ActivityTimelineControllerTest {
    /*@testSetup
static void setup(){
FieloPLT__Program__c[] programs = MockupFactory.createPrograms('Loyalty Program', 1);
insert programs;
FieloPLT__Member__c[] members = MockUpFactory.createMembers('Member', 1, programs[0].Id);
insert members;
FieloPLT__Level__c[] levels = MockUpFactory.createLevels('Level', 3,programs[0].Id);
insert levels;
FieloPLT__Transaction__c[] transactions = MockUpFactory.createTransactions(3, members[0].Id, 50);
insert transactions;
List<FieloPLT__LevelMember__c> memberLevels = MockUpFactory.createLevelMembers(levels, members[0].Id);
insert memberLevels;

Test.startTest();
MockUpFactory.createCourses(programs[0].Id,0,members[0].Id);
FieloELR__Course__c[] courses = [SELECT Id, FieloELR__Program__c FROM FieloELR__Course__c];
MockUpFactory.answerModules(courses[0].Id,members[0].Id);
Test.stopTest();

}*/
    
    @isTest
    static void getActivityTimelineTest(){
        Map<String,Boolean> objMap = new Map<String,Boolean>();
        objMap.put('transactions', true);
        objMap.put('memberlevel', true);
        objMap.put('moduleresponse', true); 
        objMap.put('coursestatus', true); 
        objMap.put('badgemember', true);
        objMap.put('redemption', true);
        objMap.put('invoice', true);
        String enableObj = JSON.serialize(objMap);
            
        List<ActivityTimelineModel> lista = ActivityTimelineController.getActivityTimeline('a0M0b00000VJqAWEA1', null, null, enableObj);    
        System.assertNotEquals(null, lista);
        
    }
    
    @isTest
    static void getMemberTest(){
        FieloPLT__Member__c[] lista = ActivityTimelineController.getMember('0050b0000035omO');
        System.assertNotEquals(null, lista);
    }
}