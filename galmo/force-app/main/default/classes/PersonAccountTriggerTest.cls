@isTest
public class PersonAccountTriggerTest {
    @isTest
    static void testTriggerOnInsert() {
        Account personAccount = new Account(LastName = 'Test Person', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id, EstadoCivil__pc = 'Casado(a) (Comunhão total)');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            insert personAccount;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Para definir o Estado Civil como "Casado"'), 'Esperava que uma exceção fosse lançada.');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Esperava que uma exceção fosse lançada.');
    }

    @isTest
    static void testTriggerOnUpdate() {
        Account personAccount = new Account(LastName = 'Test Person', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id);
        insert personAccount;

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            personAccount.EstadoCivil__pc = 'Casado(a) (Comunhão total)';
            update personAccount;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Para definir o Estado Civil como "Casado"'), 'Esperava que uma exceção fosse lançada.');
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'Esperava que uma exceção fosse lançada.');
    }
}