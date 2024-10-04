@isTest
private class OpportunityContactRoleTriggerHandlerTest {
    @isTest
    static void testCriacaoOpportunityContactRole() {
        Test.startTest();
        
        Account conta = new Account(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert conta;

        Contact contato = new Contact(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert contato;

        Opportunity opp = new Opportunity (
            AccountId = conta.id,
            Name = 'Opp do John',
            StageName = 'Proposal',
            CloseDate = Date.today()
        );
        insert opp;

        OpportunityContactRole OppCttRole = new OpportunityContactRole (
            ContactId = contato.id,
            OpportunityId = opp.id,
            Role = 'Economic Buyer'
        );
        insert OppCttRole;

        Test.stopTest();
    }
}