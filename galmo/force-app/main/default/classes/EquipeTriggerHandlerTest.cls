@isTest
private class EquipeTriggerHandlerTest {

    @isTest 
    static void makeData() {
        Test.startTest();
        Equipe__c equipe = new Equipe__c(
            Name = 'Equipe de Teste'
        );
        insert equipe;

        User newUser = new User(
           FirstName = 'John',
           LastName = 'Doe',
           Username = 'johndoe@test.com',
           Email = 'johndoe@test.com',
           Alias = 'jdoe',
           CommunityNickname = 'johndoe',
           TimeZoneSidKey = 'America/Los_Angeles',
           LocaleSidKey = 'en_US',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           IsActive = true
        );
        insert newUser;

        Test.stopTest();
    }

    @isTest
    static void testValidateMembroInsert() {
        Equipe__c equipe = [SELECT Name FROM Equipe__c LIMIT 1];
        User usuario = [SELECT id, FirstName, Email FROM User LIMIT 1];
        MembroEquipe__c membro = new MembroEquipe__c(
            Name = 'John',
            Equipe__c = equipe.id,
            Usuario__c = usuario.id
        );
        insert membro; 

        System.assert(membro.HasErrors());
    }

    @isTest
    static void testValidateMembroUpdate() {
        Equipe__c equipe = [SELECT Name FROM Equipe__c LIMIT 1];
        User usuario = [SELECT id, FirstName, Email FROM User LIMIT 1];
        MembroEquipe__c membro = new MembroEquipe__c(
            Name = 'John',
            Equipe__c = equipe.id,
            Usuario__c = usuario.id
        );
        insert membro; 

        MembroEquipe__c membroTeste = [SELECT id, Name FROM MembroEquipe__c LIMIT 1];

        membroTeste.Name = 'John Teste';
        update membroTeste;

        System.assert(membro.HasErrors());
    }
    
}