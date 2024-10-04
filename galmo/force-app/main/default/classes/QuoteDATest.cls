@IsTest
public class QuoteDATest {

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

    }

    @IsTest
    static void testGetQuotesMapByIds() {	
        
        Product2 unidade = [SELECT Id FROM Product2];
        Opportunity opportunity = [SELECT Id FROM Opportunity];
        
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
            Pricebook2Id = standardPricebook
        );
        insert quote;

        QuoteLineItem quoteLineItem = new QuoteLineItem(
            QuoteId = quote.Id,
            Product2Id = unidade.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        insert quoteLineItem;

        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        Map<Id, Quote> quotesMap = QuoteDA.getQuotesMapByIds(new List<Id>{testQuote.Id});
        Test.stopTest();
        
        System.assertEquals(1, quotesMap.size());
        System.assertNotEquals(null, quotesMap.get(testQuote.Id));
    }
    
    @IsTest
    static void testGetProductByQuoteId() {
        
        Product2 unidade = [SELECT Id FROM Product2];
        Opportunity opportunity = [SELECT Id FROM Opportunity];
        
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
            Pricebook2Id = standardPricebook
        );
        insert quote;

        QuoteLineItem quoteLineItem = new QuoteLineItem(
            QuoteId = quote.Id,
            Product2Id = unidade.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        insert quoteLineItem;

        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
      
        Test.startTest();
        Product2 product = QuoteDA.getProductByQuoteId(testQuote.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, product);
    }
    
    @IsTest
    static void testGetQuoteLineItemsByQuoteId() {
        
        Product2 unidade = [SELECT Id FROM Product2];
        Opportunity opportunity = [SELECT Id FROM Opportunity];
        
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
            Pricebook2Id = standardPricebook
        );
        insert quote;

        QuoteLineItem quoteLineItem = new QuoteLineItem(
            QuoteId = quote.Id,
            Product2Id = unidade.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        insert quoteLineItem;


        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
    
        Test.startTest();
        List<QuoteLineItem> lineItems = QuoteDA.getQuoteLineItemsByQuoteId(testQuote.Id);
        Test.stopTest();
        
        System.assertEquals(1, lineItems.size());
        System.assertEquals(testQuote.Id, lineItems[0].QuoteId);
    }
    
    @IsTest
    static void testGetOrCreatePricebookEntryId() {
        Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
        Id standardPricebook = Test.getStandardPricebookId();

        Test.startTest();
        Id pbeId = QuoteDA.getOrCreatePricebookEntryId(testProduct.Id, standardPricebook);
        Test.stopTest();
        
        System.assertNotEquals(null, pbeId);
        PricebookEntry createdPBE = [SELECT Id FROM PricebookEntry WHERE Id = :pbeId];
        System.assertNotEquals(null, createdPBE);
    }
}