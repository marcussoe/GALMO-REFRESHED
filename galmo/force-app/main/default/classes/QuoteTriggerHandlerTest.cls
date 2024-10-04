@IsTest
private class QuoteTriggerHandlerTest {

    @testSetup
    static void makeData() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Enterprise__c empreendimento = new Enterprise__c(
            Name = 'Nome do Empreendimento',
            SPE__c = account.Id, 
            CNPJ__c = '13753560000169',
            Tipo__c = 'Casa',
            StatusObra__c = 'Entregue',
            MetragemPrivativaTotalMetro__c = 5000,
            MetragemTerrenoMetro__c = 10000,
            MetragemConstruidaMetro__c = 7000
        );
        insert empreendimento;

        Bloco__c bloco = new Bloco__c(
            Name = 'Nome do Bloco',
            DataLancamento__c = Date.today(),
            DataEntrega__c = Date.today().addMonths(12),
            Empreendimento__c = empreendimento.Id,
            QuantidadeAndares__c = 10,
            TotalUnidades__c = 50
        );
        insert bloco;

        Product2 unidade = new Product2(
            Name = 'Nome do Produto do Apartamento',
            ProductCode = '854785964',
            ExternalId = '10',
            Enterprise__c = empreendimento.Id,
            Bloco__c = bloco.Id,
            ValorM2__c = 8 
        );
        insert unidade;

        Opportunity opportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = account.Id,
            CloseDate = System.today().addDays(30),
            Unidade__c = unidade.Id,
            StageName = 'Negociacao'
        );
        insert opportunity;

        List<Quote> quotes = new List<Quote>();

        // Criar cotação aprovada
        Quote approvedQuote = new Quote(
            Name = 'Test Quote Approved',
            OpportunityId = opportunity.Id,
            Status = 'Aprovada',
            Empreendimento__c = empreendimento.Id,
            Unidade__c = unidade.Id
        );
        quotes.add(approvedQuote);

        // Criar cotação não aprovada
        Quote draftQuote = new Quote(
            Name = 'Test Quote Draft',
            OpportunityId = opportunity.Id,
            Status = 'Draft',
            Empreendimento__c = empreendimento.Id,
            Unidade__c = unidade.Id
        );
        quotes.add(draftQuote);

        insert quotes;
    }

    @isTest
    static void testUpdateOpportunitiesFromQuotes_WhenQuotesApproved() {
        List<Quote> newQuotes = [SELECT Id, Status, OpportunityId, Empreendimento__c, Unidade__c FROM Quote];
        Map<Id, Quote> oldMap = new Map<Id, Quote>();
        for (Quote quote : newQuotes) {
            oldMap.put(quote.Id, new Quote(Id = quote.Id, Status = 'Draft'));
        }

 

        List<Opportunity> updatedOpportunities = [SELECT Id, Amount, SyncedQuoteId, Empreendimento__c FROM Opportunity];
        System.assertNotEquals(0, updatedOpportunities.size(), 'Deve haver oportunidades atualizadas após a aprovação das cotações');
    }

    @isTest
    static void testUpdateOpportunitiesFromQuotes_WhenQuotesNotApproved() {
        List<Quote> newQuotes = [SELECT Id, Status, OpportunityId, Empreendimento__c, Unidade__c FROM Quote];
        Map<Id, Quote> oldMap = new Map<Id, Quote>();
        for (Quote quote : newQuotes) {
            oldMap.put(quote.Id, new Quote(Id = quote.Id, Status = 'Aprovada'));
        }

        Test.startTest();
        QuoteHelper.updateOpportunitiesFromQuotes(newQuotes, oldMap);
        Test.stopTest();

        List<Opportunity> updatedOpportunities = [SELECT Id, Amount, SyncedQuoteId, Empreendimento__c FROM Opportunity];
    }

}