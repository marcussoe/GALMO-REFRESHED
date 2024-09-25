@isTest
public class ValidarCNPJFromContaTriggerTest {

    @isTest
    static void testTriggerCNPJValido() {
   
        // Criar uma conta com CNPJ válido
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CNPJ__c = '11084433000199';
      
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Verificar se a conta foi inserida com sucesso
        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testTriggerCNPJInvalido() {
   

        // Criar uma conta com CNPJ inválido
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CNPJ__c = '12345678901234'; // CNPJ inválido
       

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Expected DmlException was not thrown.');
        } catch (DmlException e) {
            // Verificar se a exceção contém a mensagem correta
            System.assert(e.getMessage().contains('CNPJ inválido'));
        }
        Test.stopTest();
    }
}