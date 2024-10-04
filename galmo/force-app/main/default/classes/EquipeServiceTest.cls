@isTest
private class EquipeServiceTest {
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

        User newUser2 = new User(
            FirstName = 'Pedro',
            LastName = 'Santos',
            Username = 'pedro@test.com',
            Email = 'pedro@test.com',
            Alias = 'psant',
            CommunityNickname = 'psant',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = true
         );
         insert newUser;

        MembroEquipe__c membro = new MembroEquipe__c(
            Name = 'Doeh',
            Equipe__c = equipe.id,
            Usuario__c = newUser.id
        );
        insert membro; 
        Test.stopTest();
    }

    @isTest
    static void testValidateMembro() {
        Equipe__c equipe = [SELECT Name FROM Equipe__c LIMIT 1];
        User usuario = [SELECT id, FirstName, Email FROM User WHERE Alias = 'jdoe' LIMIT 1];
        MembroEquipe__c membro = new MembroEquipe__c(
            Name = 'John',
            Equipe__c = equipe.id,
            Usuario__c = usuario.id
        );
      
        Test.startTest();
            insert membro; 
        Test.stopTest();

        System.assert(membro.HasErrors());
    }

    @isTest
    static void testValidateMembro2() {
        Equipe__c equipe = [SELECT Name FROM Equipe__c LIMIT 1];
        User usuario = [SELECT id, FirstName, Email FROM User WHERE Alias = 'psant' LIMIT 1];


        MembroEquipe__c membro = new MembroEquipe__c(
            Name = 'Pedro',
            Equipe__c = equipe.id,
            Usuario__c = usuario.id
        );
      
        Test.startTest();
            insert membro; 
        Test.stopTest();

        System.assert(membro.HasErrors());
    }
}