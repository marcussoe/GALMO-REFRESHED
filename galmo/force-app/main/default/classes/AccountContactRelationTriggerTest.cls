@isTest
public class AccountContactRelationTriggerTest {
    @isTest
    static void testSingleSpouseValidation() {
        // Cria uma Person Account
        Account personAccount = new Account(LastName = 'Test Person', EstadoCivil__pc = 'Solteiro(a)', PersonMobilePhone = '11998972612', PersonEmail = 'testeste@gmail.com', CPF__pc = '51503480070');
        insert personAccount;
        
        Account acc = new Account();
        acc.Name = 'teste';
        insert acc;

        // Cria um contato e um Related Contact do tipo "Cônjuge/Companheiro"
		Contact spouse1 = new Contact();
        spouse1.FirstName = 'Test';
        spouse1.LastName = 'Contato';
        spouse1.CPF__c = '12345678909';
        insert spouse1;
        
        Id cFisica = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();
        
        Contact ct = new Contact();
        ct.FirstName = 'teste';
        ct.CPF__c = '12345678909';
        ct.Email = 'teste@gmailc.com';
        ct.LastName = 'Contato';
        ct.RecordTypeId = cFisica;
        insert ct;
        
        AccountContactRelation relation1 = new AccountContactRelation(AccountId = acc.Id, ContactId = ct.Id, Relacionamento__c = 'Cônjuge/Companheiro');
        insert relation1;

        // Tenta criar outro contato relacionado do tipo "Cônjuge/Companheiro"
        Contact spouse2 = new Contact(LastName = 'Spouse2', AccountId = personAccount.Id);
        insert spouse2;

        AccountContactRelation relation2 = new AccountContactRelation(AccountId = personAccount.Id, ContactId = spouse2.Id, Relacionamento__c = 'Cônjuge/Companheiro');
        
        Test.startTest();
        try {
            insert relation2;
            System.assert(false, 'A inserção deve falhar pois já existe um Related Contact com o campo Relacionamento__c marcado como "Cônjuge/Companheiro".');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Apenas um contato relacionado pode ter o relacionamento marcado como "Cônjuge/Companheiro" por conta.'), e.getMessage());
        }
        Test.stopTest();
    }
}