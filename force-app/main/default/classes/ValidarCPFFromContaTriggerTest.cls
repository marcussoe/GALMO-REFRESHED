@isTest
public class ValidarCPFFromContaTriggerTest {

    @isTest
    static void testTriggerCPFValido() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Conta';
        acc.CPF__pc = '12345678909'; // CPF válido
        insert acc;
        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testTriggerCPFInvalido() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Conta';
        acc.CPF__pc = '12345678901'; // CPF inválido
        Test.startTest();
        try {
            insert acc;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CPF inválido'));
        }
        Test.stopTest();
        System.assertEquals(null, acc.Id);
    }

}