@isTest
public class EmpreendimentoTriggerHandlerTest {
    @isTest
    static void testBeforeInsertValidCNPJ() {
        Enterprise__c emp = new Enterprise__c();
        emp.Name = 'Meu Empreendimento';
        emp.CNPJ__c= '69444109000114';
        Test.startTest();
        insert emp;
        Test.stopTest();
        Enterprise__c insertedEmp = [SELECT Id FROM Enterprise__c WHERE Id = :emp.Id];
        System.assertNotEquals(null, insertedEmp);
    }

    @isTest
    static void testBeforeInsertInvalidCNPJ() {
        Enterprise__c emp = new Enterprise__c();
        emp.Name = 'Meu Empreendimento';
        emp.CNPJ__c= '12345678901234'; 
        Test.startTest();
        try {
            insert emp;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CNPJ inválido'));
        }
        Test.stopTest();
        List<Enterprise__c> insertedEmps = [SELECT Id FROM Enterprise__c WHERE Id = :emp.Id];
        System.assertEquals(0, insertedEmps.size());
    }

    @isTest
    static void testBeforeUpdateValidCNPJ() {
        Enterprise__c emp = new Enterprise__c();
        emp.Name = 'Meu Empreendimento';
        emp.CNPJ__c= '69444109000114';
        insert emp;

        emp.CNPJ__c= '98765432000101'; // CNPJ válido
        Test.startTest();
        update emp;
        Test.stopTest();
        Enterprise__c updatedEmp = [SELECT Id FROM Enterprise__c WHERE Id = :emp.Id];
        System.assertNotEquals(null, updatedEmp);
    }

    @isTest
    static void testBeforeUpdateInvalidCNPJ() {
        Enterprise__c emp = new Enterprise__c();
        emp.Name = 'Meu Empreendimento';
        emp.CNPJ__c= '69444109000114';
        insert emp;

        emp.CNPJ__c= '12345678901234';
        Test.startTest();
        try {
            update emp;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CNPJ inválido'));
        }
        Test.stopTest();
        Enterprise__c updatedEmp = [SELECT Id FROM Enterprise__c WHERE Id = :emp.Id];
        System.assertEquals(null, updatedEmp);
    }
}