@isTest
public class ValidateDifferentUsersTest {
    
    @isTest
    static void testDifferentUsers() {
        // Create test users
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        User user1 = new User(
            Username = 'testuser1@example.com',
            Alias = 'test1',
            Email = 'testuser1@example.com',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            LastName = 'TestUser1'
        );
        
        User user2 = new User(
            Username = 'testuser2@example.com',
            Alias = 'test2',
            Email = 'testuser2@example.com',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            LastName = 'TestUser2'
        );
        
        insert user1;
        insert user2;
        
        // Create an Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert opp;
        
        // Test case where User and Reporta-se are different
        OpportunityTeamMember otm1 = new OpportunityTeamMember(
            OpportunityId = opp.Id,
            UserId = user1.Id,
            TeamMemberRole = 'Sales Rep',
            Reportase__c = user2.Id
        );
        
        Test.startTest();
        insert otm1;
        Test.stopTest();
        
        // Verify no errors occurred
        System.assertEquals(1, [SELECT COUNT() FROM OpportunityTeamMember WHERE Id = :otm1.Id]);
        
        // Test case where User and Reporta-se are the same
        OpportunityTeamMember otm2 = new OpportunityTeamMember(
            OpportunityId = opp.Id,
            UserId = user1.Id,
            TeamMemberRole = 'Sales Rep',
            Reportase__c = user1.Id
        );
        
        Test.startTest();
        try {
            insert otm2;
            System.assert(false, 'Expected an exception to be thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('O campo Usuário e o campo Reporta-se não podem ter o mesmo valor'));
        }
        Test.stopTest();
    }
}