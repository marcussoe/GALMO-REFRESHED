@isTest
private class DocumentacaoServiceTest {
    @isTest
    static void makeData() {    
        Account conta = new Account(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert conta;

        Contact contato = new Contact(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert contato;

        Opportunity opp = new Opportunity (
            AccountId = conta.id,
            Name = 'Opp do John',
            StageName = 'Proposal',
            CloseDate = Date.today()
        );
        insert opp;

        OpportunityContactRole OppCttRole = new OpportunityContactRole (
            ContactId = contato.id,
            OpportunityId = opp.id,
            Role = 'Economic Buyer'
        );
        insert OppCttRole;
    }

    @isTest
    static void criarDocumentacaoPorPapeisContatoTest() {
        makeData();
        List<OpportunityContactRole> OppContactRoles = [SELECT ContactId, OpportunityId, Role FROM OpportunityContactRole];

        Test.startTest();
        DocumentacaoService.criarDocumentacaoPorPapeisContato(OppContactRoles);
        Test.stopTest();

        System.assert(!OppContactRoles[0].HasErrors());
    }

    @isTest
    static void criarDocumentacaoTest() {
        Set<OpportunityContactRole> papeisContato = new Set<OpportunityContactRole>();

        Test.startTest();
        DocumentacaoService.criarDocumentacao(papeisContato);
        Test.stopTest();

        List<Documentacao__c> documentacoesCriadas = [SELECT Id, Contato__c, Name, Obrigatorio__c FROM Documentacao__c];

        System.assertEquals(0, documentacoesCriadas.size(), 'Número incorreto de documentações criadas');
    }

    @isTest
    static void buscarDocumentacao() {
        makeData();
        List<OpportunityContactRole> OppContactRoles = [SELECT ContactId, OpportunityId, Role FROM OpportunityContactRole];

        Test.startTest();
        DocumentacaoService.buscarDocumentacao(OppContactRoles);
        Test.stopTest();

        System.assertNotEquals(0, OppContactRoles.size());
        
    }
}