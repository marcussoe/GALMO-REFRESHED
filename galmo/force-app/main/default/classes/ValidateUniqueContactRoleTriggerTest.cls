@isTest
public class ValidateUniqueContactRoleTriggerTest {
    @isTest
    static void testDuplicateContactRole() {
        // Setup
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact1 = new Contact(LastName = 'Contact1', AccountId = account.Id);
        insert contact1;

        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today().addDays(30), StageName = 'Prospecting', AccountId = account.Id);
        insert opportunity;

        OpportunityContactRole ocr1 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact1.Id, Role = 'Comprador');
        insert ocr1;

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            OpportunityContactRole ocr2 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact1.Id, Role = 'Cônjuge/Companheiro');
            insert ocr2;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Não é permitido adicionar o mesmo contato com papéis diferentes na mesma oportunidade.'), 'Esperava que uma exceção fosse lançada.');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Esperava que uma exceção fosse lançada.');
    }

    @isTest
    static void testAllowDifferentContactRoles() {
        // Setup
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact1 = new Contact(LastName = 'Contact1', AccountId = account.Id);
        Contact contact2 = new Contact(LastName = 'Contact2', AccountId = account.Id);
        insert new List<Contact>{contact1, contact2};

        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today().addDays(30), StageName = 'Prospecting', AccountId = account.Id);
        insert opportunity;

        OpportunityContactRole ocr1 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact1.Id, Role = 'Comprador');
        insert ocr1;

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            OpportunityContactRole ocr2 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact2.Id, Role = 'Cônjuge/Companheiro');
            insert ocr2;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(!exceptionThrown, 'Esperava que nenhuma exceção fosse lançada.');
    }
}