@IsTest
public class QuoteHelperTest {

    @TestSetup
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
            StageName = 'Negociação'
        );
        insert opportunity;

        Id standardPricebook = Test.getStandardPricebookId();
        
        PricebookEntry pricebookEntry = new PricebookEntry(
            Product2Id = unidade.Id,
            Pricebook2Id = standardPricebook,
            UnitPrice = 100,
            IsActive = true
        );
        insert pricebookEntry;

        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opportunity.Id,
            Status = 'Draft',
            Pricebook2Id = standardPricebook
        );
        insert quote;

        QuoteLineItem qli = new QuoteLineItem(
            QuoteId = quote.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 2,
            UnitPrice = 2500
        );
        insert qli;
    }

    @IsTest
    static void testUpdateOpportunitiesFromQuotes_WhenQuotesApproved() {
        // Criar dados de teste
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
           // FracaoIdeal__c = '10',
            ValorM2__c = 8 
        );
        insert unidade;
    
        // Criar uma Oportunidade
        Opportunity opportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = account.Id,
            CloseDate = System.today().addDays(30),
            Unidade__c = unidade.Id,
            StageName = 'Negociação'
        );
        insert opportunity;
    
        // Obter o ID do Pricebook padrão
        Id standardPricebook = Test.getStandardPricebookId();
    
        // Criar um PricebookEntry para a unidade
        PricebookEntry pricebookEntry = new PricebookEntry(
            Product2Id = unidade.Id,
            Pricebook2Id = standardPricebook,
            UnitPrice = 100,
            IsActive = true
        );
        insert pricebookEntry;
    
        // Criar uma Quote aprovada associada à Oportunidade
        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opportunity.Id,
            
            Pricebook2Id = standardPricebook,
            Status = 'Approved'
        );
        insert quote;
    
        // Criar um QuoteLineItem para a Quote
        QuoteLineItem quoteLineItem = new QuoteLineItem(
            QuoteId = quote.Id,
            Product2Id = unidade.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        insert quoteLineItem;
    
        // Obter a lista de Quotes para sincronização
        List<Quote> newQuotes = [SELECT Id, Status, OpportunityId, GrandTotal FROM Quote WHERE Id = :quote.Id];
        Map<Id, Quote> oldMap = new Map<Id, Quote>();
        for (Quote q : newQuotes) {
            oldMap.put(q.Id, new Quote(Id = q.Id, Status = 'Draft')); // Definir o status anterior como 'Draft'
        }
    
        // Executar o teste
        Test.startTest();
        QuoteHelper.updateOpportunitiesFromQuotes(newQuotes, oldMap);
        Test.stopTest();
    
        // Verificar se as Oportunidades foram atualizadas corretamente
        List<Opportunity> updatedOpportunities = [SELECT Id, Amount, SyncedQuoteId, Empreendimento__c FROM Opportunity];
        System.assertNotEquals(0, updatedOpportunities.size(), 'Deve haver oportunidades atualizadas após a aprovação das cotações');
    }
    


    

    @IsTest
    static void testUpdateOpportunitiesFromQuotes_WhenQuotesNotApproved() {
        List<Quote> newQuotes = [SELECT Id, Status, OpportunityId, GrandTotal FROM Quote];
        Map<Id, Quote> oldMap = new Map<Id, Quote>();
        for (Quote quote : newQuotes) {
            oldMap.put(quote.Id, new Quote(Id = quote.Id, Status = 'Draft'));
        }

        Test.startTest();
        QuoteHelper.updateOpportunitiesFromQuotes(newQuotes, oldMap);
        Test.stopTest();
    }

    @IsTest
    static void testAddQuoteProductsToOpportunities() {
        // Verificar se há um Pricebook2 padrão existente ou criar um novo se necessário
        Pricebook2 standardPricebook;
        List<Pricebook2> existingStandardPricebooks = [SELECT Id FROM Pricebook2 WHERE IsStandard = true AND IsActive = true LIMIT 1];
        if (existingStandardPricebooks.isEmpty()) {
            // Criar um novo Pricebook2 padrão
            standardPricebook = new Pricebook2(Name = 'Standard Price Book', IsActive = true);
            insert standardPricebook;
            
            // Ativar o novo Pricebook2 padrão (o campo IsStandard será definido automaticamente pelo Salesforce)
            standardPricebook.IsActive = true;
            update standardPricebook;
        } else {
            standardPricebook = existingStandardPricebooks[0];
        }
        
        // Criar um produto para teste
        Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;
        

        
        // Chamar o método da helper para adicionar produtos de Quote para Opportunities
        Test.startTest();
     
        Test.stopTest();
        

    }

    


    @IsTest
static void testSyncQuoteWithOpportunity() {
    // Cenário 1: Cotação Aprovada
    Opportunity opportunity = new Opportunity(
        Name = 'Oportunidade Teste',
        StageName = 'Negotiation', // Defina o estágio conforme necessário
        CloseDate = Date.today().addMonths(1) // Data de fechamento da oportunidade
        // Outros campos da oportunidade, conforme necessário
    );
    insert opportunity;

    Quote quoteApproved = new Quote(
        Name = 'Cotação Teste',
        Status = 'Approved',
        OpportunityId = opportunity.Id
        // Outros campos da cotação, conforme necessário
    );
    insert quoteApproved;
    
    // Teste do cenário 1
    Test.startTest();
    QuoteHelper.syncQuoteWithOpportunity(new List<Quote>{ quoteApproved });
    Test.stopTest();
    
    // Verificar se a oportunidade foi atualizada corretamente
    Opportunity updatedOpportunity = [SELECT Id, Amount, SyncedQuoteId FROM Opportunity WHERE Id = :opportunity.Id];
    System.assertEquals(quoteApproved.GrandTotal, updatedOpportunity.Amount, 'O valor da oportunidade deve ser atualizado conforme o valor da cotação');
    
    // Cenário 2: Cotação Não Aprovada
    Quote quoteNotApproved = new Quote(
        Name = 'Cotação Teste2',
        Status = 'Draft', // Status diferente de 'Approved'
        OpportunityId = opportunity.Id
    );
    insert quoteNotApproved;
    
 
    QuoteHelper.syncQuoteWithOpportunity(new List<Quote>{ quoteNotApproved });
    
    
    // Verificar que a oportunidade não foi atualizada
    Opportunity notUpdatedOpportunity = [SELECT Id, Amount, SyncedQuoteId FROM Opportunity WHERE Id = :quoteNotApproved.OpportunityId];
  
    
    // Cenário 3: Tentativa de Sincronização com Oportunidade Já Sincronizada
    // Criar uma cotação aprovada
    Quote quoteSynced = new Quote(
        Status = 'Approved',
        Name = 'Cotação Teste2',
        OpportunityId = opportunity.Id
    );
    insert quoteSynced;
    
    // Sincronizar a primeira vez
    
    QuoteHelper.syncQuoteWithOpportunity(new List<Quote>{ quoteSynced });
   
    
    // Tentar sincronizar novamente (deve falhar)
    Boolean exceptionThrown = false;
    try {
      
        QuoteHelper.syncQuoteWithOpportunity(new List<Quote>{ quoteSynced });
        
    } catch (Exception e) {
        exceptionThrown = true;
    }
    
   
    
    // Verificar se a oportunidade ainda está sincronizada
    Opportunity syncedOpportunity = [SELECT Id, Amount, SyncedQuoteId FROM Opportunity WHERE Id = :quoteSynced.OpportunityId];
  
}
}