@isTest
public class OpportunityContactRoleUpdaterTest {
    @isTest
    static void testUpdateContactRoles() {
        // Cria uma Person Account
        Account personAccount = new Account(LastName = 'Test Person', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id);
        insert personAccount;

        // Cria contatos
        Contact primaryBuyer = new Contact(LastName = 'Buyer', AccountId = personAccount.Id);
        insert primaryBuyer;

        Contact spouse = new Contact(LastName = 'Spouse', AccountId = personAccount.Id);
        insert spouse;

        // Cria uma oportunidade
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = System.today(), AccountId = personAccount.Id);
        insert opp;

        // Cria um Opportunity Contact Role para o comprador principal
        OpportunityContactRole ocrBuyer = new OpportunityContactRole(OpportunityId = opp.Id, ContactId = primaryBuyer.Id, Role = 'Comprador', PorcentagemParticipacao__c = 100, IsPrimary = true);
        insert ocrBuyer;

        // Cria um AccountContactRelation para o cônjuge
        AccountContactRelation relation = new AccountContactRelation(AccountId = personAccount.Id, ContactId = spouse.Id, Relacionamento__c = 'Cônjuge/Companheiro');
        insert relation;

        Test.startTest();
        // Atualiza a relação para acionar a trigger
        update relation;
        Test.stopTest();

        // Verifica se os Contact Roles foram atualizados corretamente
        OpportunityContactRole updatedOcrBuyer = [SELECT PorcentagemParticipacao__c FROM OpportunityContactRole WHERE Id = :ocrBuyer.Id];
        System.assertEquals(50, updatedOcrBuyer.PorcentagemParticipacao__c);

        OpportunityContactRole spouseRole = [SELECT PorcentagemParticipacao__c FROM OpportunityContactRole WHERE OpportunityId = :opp.Id AND Role = 'Cônjuge/Companheiro'];
        System.assertEquals(50, spouseRole.PorcentagemParticipacao__c);
    }
}