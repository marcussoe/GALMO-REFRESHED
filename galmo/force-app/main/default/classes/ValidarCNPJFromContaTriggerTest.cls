@isTest
public class ValidarCNPJFromContaTriggerTest {

    @isTest
    static void testTriggerCNPJValido() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Conta';
        acc.CNPJ__c = '11084433000199';
        acc.PersonMobilePhone = '1234567890';
        acc.PersonEmail = 'marcussopedro@example.com';
        insert acc;
        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testTriggerCNPJInvalido() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Conta';
        acc.CNPJ__c = '12345678901234'; // CPF inválido
        Test.startTest();
        try {
            insert acc;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CNPJ inválido'));
        }
        Test.stopTest();
        System.assertEquals(null, acc.Id);
    }

}