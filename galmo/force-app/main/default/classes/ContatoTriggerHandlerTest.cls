@isTest
public class ContatoTriggerHandlerTest {
    @isTest
    static void testBeforeInsertValidCPF() {
        Contact ctt = new Contact();
        ctt.FirstName = 'Test';
        ctt.LastName = 'Contato';
        ctt.CPF__c = '12345678909';
        Test.startTest();
        insert ctt;
        Test.stopTest();
        Contact insertedCtt = [SELECT Id FROM Contact WHERE Id = :ctt.Id];
        System.assertNotEquals(null, insertedCtt);
    }

    @isTest
    static void testBeforeInsertInvalidCPF() {
        Contact ctt = new Contact();
        ctt.FirstName = 'Test';
        ctt.LastName = 'Contato';
        ctt.CPF__c = '12345678901';
        Test.startTest();
        try {
            insert ctt;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CPF inválido'));
        }
        Test.stopTest();
        List<Contact> insertedCtts = [SELECT Id FROM Contact WHERE Id = :ctt.Id];
        System.assertEquals(0, insertedCtts.size());
    }

    @isTest
    static void testBeforeUpdateValidCPF() {
        Contact ctt = new Contact();
        ctt.FirstName = 'Test';
        ctt.LastName = 'Contato';
        ctt.CPF__c = '12345678909';
        insert ctt;

        ctt.CPF__c = '40064837084';
        Test.startTest();
        update ctt;
        Test.stopTest();
        Contact updatedCtt = [SELECT Id FROM Contact WHERE Id = :ctt.Id];
        System.assertNotEquals(null, updatedCtt);
    }

    @isTest
    static void testBeforeUpdateInvalidCPF() {
        Contact ctt = new Contact();
        ctt.FirstName = 'Test';
        ctt.LastName = 'Contato';
        ctt.CPF__c = '12345678909';
        insert ctt;

        ctt.CPF__c = '12345678901';
        Test.startTest();
        try {
            update ctt;
        } catch (DmlException e) {
        }
        Test.stopTest();
        Contact updatedCtt = [SELECT Id FROM Contact WHERE Id = :ctt.Id];
    }
}