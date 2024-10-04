@isTest
private class OpportunityDATest {

    @isTest static void testGetOpportunityLineItems() {
        Test.startTest();
        
        Opportunity testOpportunity = new Opportunity(
            Name='Test Opportunity',
            StageName='Negociação',
            CloseDate=System.today().addMonths(1)
        );
        insert testOpportunity;

        Product2 testProduct = new Product2(
            Name='Test Product',
            IsActive=true
        );
        insert testProduct;

        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id=Test.getStandardPricebookId(),
            Product2Id=testProduct.Id,
            UnitPrice=100,
            IsActive=true
        );
        insert testPricebookEntry;

        List<OpportunityLineItem> items = OpportunityDA.getOpportunityLineItems(testOpportunity.Id);

        Test.stopTest();
    }

    @isTest
    static void testGetOpportunitiesWithQuote() {
        Test.startTest();

      
        Opportunity oppWithPricebook = new Opportunity(
            Name='With Pricebook',
            StageName='Negociação',
            CloseDate=System.today().addMonths(1),
            Pricebook2Id=Test.getStandardPricebookId()
        );
        insert oppWithPricebook;

        Opportunity oppWithoutPricebook = new Opportunity(
            Name='Without Pricebook',
            StageName='Negociação',
            CloseDate=System.today().addMonths(1)
        );
        insert oppWithoutPricebook;

        Set<Id> oppIds = new Set<Id>{
            oppWithPricebook.Id,
            oppWithoutPricebook.Id
        };

        Map<Id,Opportunity> results = OpportunityDA.getOpportunitiesWithQuote(oppIds);

      
        

        Test.stopTest();
    }

    @isTest static void testGetOpportunityContactRoles() {
        Test.startTest();

        Account testAccount = new Account(Name='Test Account', Type = 'HouseImobiliaria');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name='Test Opportunity',
            StageName='Prospecting',
            CloseDate=System.today().addMonths(1),
            AccountId=testAccount.Id
        );
        insert testOpportunity;

        Contact testContact = new Contact(
            LastName='Test Contact',
            AccountId=testAccount.Id
        );
        insert testContact;

        OpportunityContactRole ocr = new OpportunityContactRole(
            OpportunityId=testOpportunity.Id,
            ContactId=testContact.Id,
            Role='Decision Maker'
        );
        insert ocr;

        List<OpportunityContactRole> roles = OpportunityDA.getOpportunityContactRoles(testOpportunity.Id);

        Test.stopTest();
        System.assertEquals(1, roles.size(), 'Deve retornar exatamente um OpportunityContactRole');
    }
     @isTest
    static void testHasSyncedQuote() {
        Test.startTest();
        
        
        Opportunity oppWithQuote = new Opportunity(
            Name = 'Opportunity with Quote',
            StageName = 'Negociação',
            CloseDate = System.today().addMonths(1)
        );
        insert oppWithQuote;

        Quote syncedQuote = new Quote(
            OpportunityId = oppWithQuote.Id,
            Name = 'Synced Quote',
            Status = 'Aprovada'
        );
        insert syncedQuote;

        
        oppWithQuote.SyncedQuoteId = syncedQuote.Id;
        update oppWithQuote;

     
        Boolean hasQuote = OpportunityDA.hasSyncedQuote(oppWithQuote.Id);
        System.assertEquals(true, hasQuote, 'Deveria ter uma Cotação sincronizada');

       
        Opportunity oppWithoutQuote = new Opportunity(
            Name = 'Opportunity without Quote',
            StageName = 'Negociação',
            CloseDate = System.today().addMonths(1)
        );
        insert oppWithoutQuote;

       
        Boolean hasNoQuote = OpportunityDA.hasSyncedQuote(oppWithoutQuote.Id);
        System.assertEquals(false, hasNoQuote, 'Não deveria ter uma Cotação sincronizada');

        Test.stopTest();
    }

}