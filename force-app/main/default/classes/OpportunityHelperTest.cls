@isTest
private class OpportunityHelperTest {

    @TestSetup
    static void setup(){
        RecordType rt = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Contact' AND Name = 'Corretor'
        ];
        
        Account acc = TestDataFactory.gerarConta();
        insert acc;

        Contact ctt = TestDataFactory.gerarContato(acc, rt.Id);
        insert ctt;

        Empreendimento__c empreendimento = TestDataFactory.gerarEmpreendimento(acc);
        insert empreendimento;
        
        Bloco__c bloco = TestDataFactory.gerarBloco(empreendimento);
        insert bloco;

        Product2 product = TestDataFactory.gerarProduto(empreendimento, bloco);
        insert product;
        Pricebook2 pricebook = TestDataFactory.gerarPricebook();
        insert pricebook;

        
        Opportunity opp1 = TestDataFactory.gerarOportunidade(acc, ctt);
        opp1.Pricebook2Id = pricebook.Id;
        Opportunity opp2 = TestDataFactory.gerarOportunidade(acc, ctt);
        opp2.Pricebook2Id = pricebook.Id;
        opp2.StageName = 'Ficha Cadastral';
        Opportunity opp3 = TestDataFactory.gerarOportunidade(acc, ctt);
        opp3.StageName = 'Pré-análise';
        insert new List<Opportunity> { opp1, opp2, opp3 };

        AnaliseCredito__c analise = TestDataFactory.gerarAnaliseCredito(opp3);
        insert analise;

        Quote cotacao = TestDataFactory.gerarCotacao(opp1);
        insert cotacao;
        
        PricebookEntry pricebookEntry = TestDataFactory.gerarPricebookEntry(product);
        pricebookEntry.Pricebook2Id = cotacao.Pricebook2Id;
        insert pricebookEntry;
        
        QuoteLineItem quoteLI = TestDataFactory.gerarQuoteLineItem(cotacao, pricebookEntry);
        insert quoteLI;
    
        OpportunityContactRole ocr = TestDataFactory.gerarOpportunityContactRole(opp1, ctt);
        insert ocr;
    }

    @isTest
    static void testSetDefaultCloseDate() {
        Opportunity opp = [
            SELECT Id, Name, StageName, CloseDate
            FROM Opportunity        
            WHERE StageName = 'Negociação'
        ];
        opp.CloseDate = null;

        List<Opportunity> opps = new List<Opportunity>{ opp };
        OpportunityHelper.addDaysToCloseDateOnCreation(opps);

        for (Opportunity o : opps) {
            System.assertEquals(Date.today().addDays(5), o.CloseDate, 'CloseDate should be set to today + 5 days');
        }
    }

    @isTest
    static void testValidateTransitionToFichaCadastral_AllFieldsFilled() {        
        List<Opportunity> opps = [
            SELECT Id, Name, StageName, FarolChecklistDocumento__c, CanalAtendimento__c, TipoVenda__c, Probability, AccountId, Amount, SyncedQuoteId, Corretor__c
            FROM Opportunity
        ];
        Quote cotacao = [
            SELECT Id
            FROM Quote
            WHERE OpportunityId = :opps.get(0).Id
        ];
        opps.get(0).SyncedQuoteId = cotacao.Id;
        update opps;
        
        Opportunity firstOpp = opps.get(0).clone(true, true, false, false);
        firstOpp.StageName = 'Ficha Cadastral';
        
        Opportunity secondOpp = opps.get(1).clone(true, true, false, false);
        secondOpp.StageName = 'Pré-análise';
        secondOpp.FarolChecklistDocumento__c = 'Verde';

        List<Opportunity> newOpps = new List<Opportunity> { firstOpp, secondOpp };

        Test.startTest();
        OpportunityHelper.validateTransitionToFichaCadastral(newOpps, new Map<Id, Opportunity>{ opps.get(0).Id => opps.get(0), opps.get(1).Id => opps.get(1) });
        Test.stopTest();

        for (Opportunity o : newOpps) {
            System.assert(o.getErrors().isEmpty(), 'Não deveria ter erros');
        }
    }

    @isTest
    static void testValidateTransitionToFichaCadastral_MissingRequiredFields() {
        Opportunity opp = [
            SELECT Id, Name, AccountId, Corretor__c, StageName, CloseDate
            FROM Opportunity
            WHERE StageName = 'Negociação'
        ];

        List<Opportunity> opps = new List<Opportunity>{ opp };
        
        Test.startTest();
        OpportunityHelper.validateTransitionToFichaCadastral(opps, new Map<Id, Opportunity>{ opp.Id => opp });
        Test.stopTest();
    }

    @IsTest
    static void testHandlePreAnaliseForAnaliseCreditoValid() {
        Opportunity opp = TestDataFactory.gerarOportunidade();
        opp.StageName = 'Pré-análise';
        insert opp;

        AnaliseCredito__c analise = TestDataFactory.gerarAnaliseCredito(opp);
        insert analise;

        opp.StageName = 'Geração de Contrato';
        Test.startTest();
        update opp;
        Test.stopTest();

        System.assertEquals('Geração de Contrato', opp.StageName, 'StageName da Oportunidade deveria ser "Geração de Contrato"');
    }
    
    @isTest
    static void testHasProducts_WithProducts() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = 'Negociação' LIMIT 1];
        
        
        Boolean hasProducts = OpportunityHelper.hasProducts(opp.Id);
    }

    @isTest
    static void testHasProducts_WithoutProducts() {
    
        Account acc = TestDataFactory.gerarConta();
        insert acc;
        
    
        Opportunity opp = TestDataFactory.gerarOportunidade();
        opp.AccountId = acc.Id;
        insert opp;
        
        
        Boolean hasProducts = OpportunityHelper.hasProducts(opp.Id);
        
        System.assertEquals(false, hasProducts, 'A oportunidade não deve ter produtos');
    } 
        
        
    @isTest
    static void testHasBuyersWithBuyers() {

        Account conta = TestDataFactory.gerarConta();
        insert conta;

        
        Id corretorRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Corretor' LIMIT 1].Id;

        Account Conta2 = new Account(
            Name = 'Conta Teste',
            CNPJ__c = '32378226000117'  
        );
        insert Conta2;

    
    
        Contact contato = new Contact(
            LastName = 'Silva',
            FirstName = 'João',
            Email = 'joao.silva@test.com',
            Phone = '1125548705',
            AccountId = conta.Id,
            RecordTypeId = corretorRecordTypeId 
        );
        insert contato;

        Opportunity oportunidade = TestDataFactory.gerarOportunidade(conta, contato);
        insert oportunidade;

        
        OpportunityContactRole oppContactRole = new OpportunityContactRole(
            OpportunityId = oportunidade.Id,
            ContactId = contato.Id,
            Role = 'Comprador'
        );
        insert oppContactRole;

    
        Test.startTest();
        Boolean result = OpportunityHelper.hasBuyers(oportunidade.Id);
        Test.stopTest();

        
        System.assertEquals(true, result, 'há compradores associadoss.');
    }

    @isTest
    static void testHasBuyersWithoutBuyers() {

        Account conta = TestDataFactory.gerarConta();
        insert conta;

        Opportunity oportunidade = TestDataFactory.gerarOportunidade();
        oportunidade.AccountId = conta.Id;
        insert oportunidade;


        Test.startTest();
        Boolean result = OpportunityHelper.hasBuyers(oportunidade.Id);
        Test.stopTest();


        System.assertEquals(false, result, 'não há compradores associados');
    }

    @isTest
    static void testHasBuyersWithException() {
        Test.startTest();
        Boolean result = OpportunityHelper.hasBuyers(null); 
        Test.stopTest();

        
        System.assertEquals(false, result, 'Exceção.');
    }



    @IsTest
    static void testHandlePreAnaliseForAnaliseCreditoInvalid() {
        Opportunity opp = TestDataFactory.gerarOportunidade();
        opp.StageName = 'Pré-análise';
        insert opp;
        
        opp.StageName = 'Geração de Contrato';
        Test.startTest();
        try {
            update opp;
            System.assert(false, 'Deveria lançar um erro devido que a oportunidade não tem Análise de Crédito associado.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Por favor, associe uma Análise de Crédito para avançar de fase.'));
        }
        Test.stopTest();

        Opportunity oppTestada = [
            SELECT Id, StageName 
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals('Pré-análise', oppTestada.StageName, 'StageName da Oportunidade deveria ser "Pré-análise"');
    }


    @IsTest
    static void testHandleBeforeUpdate() {
        Opportunity opp = [
            SELECT Id, Name, StageName, FarolChecklistDocumento__c, CanalAtendimento__c, TipoVenda__c, Probability, AccountId, Amount, SyncedQuoteId, Corretor__c
            FROM Opportunity
            LIMIT 1
        ];
        Quote cotacao = [
            SELECT Id
            FROM Quote
            WHERE OpportunityId = :opp.Id
        ];
        opp.SyncedQuoteId = cotacao.Id;
        
        Opportunity firstOpp = opp.clone(true, true, false, false);

        List<Opportunity> newOpps = new List<Opportunity> { firstOpp };

        Test.startTest();
        OpportunityHelper.validateTransitionToFichaCadastral(newOpps, new Map<Id, Opportunity>{ opp.Id => opp });
        Test.stopTest();

        for (Opportunity o : newOpps) {
            System.assert(o.getErrors().isEmpty(), 'Não deveria ter erros');
        }       
    }

    @IsTest
    static void testVerificarProibirConferencia() {
        List<Opportunity> opps = [
            SELECT Id, StageName
            FROM Opportunity
        ];

        Test.startTest();
        OpportunityHelper.verificarProibirConferencia(opps);
        Test.stopTest();

        for (Opportunity o : opps) {
            System.assert(o.getErrors().isEmpty(), 'Não deveria ter erros');
        }  
    }

    @IsTest
    static void testImpedirAlteracaoProbability() {
        Opportunity opp = [
            SELECT Id, Name, StageName, FarolChecklistDocumento__c, CanalAtendimento__c, TipoVenda__c, Probability, AccountId, Amount, SyncedQuoteId, Corretor__c
            FROM Opportunity
            LIMIT 1
        ];

        Opportunity firstOpp = opp.clone(true, true, false, false);

        List<Opportunity> newOpps = new List<Opportunity> { firstOpp };

        Test.startTest();
        OpportunityHelper.validateTransitionToFichaCadastral(newOpps, new Map<Id, Opportunity>{ opp.Id => opp });
        Test.stopTest();

        for (Opportunity o : newOpps) {
            System.assert(o.getErrors().isEmpty(), 'Não deveria ter erros');
        }  
    }

    @IsTest
    static void testGetByAnaliseCredito() {
        AnaliseCredito__c analise = [
            SELECT Id
            FROM AnaliseCredito__c
        ];
 
        Test.startTest();
        Opportunity result = OpportunityHelper.getByAnaliseCredito(analise.Id);
        Test.stopTest();

        Opportunity expected = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE StageName = 'Pré-análise'
        ];

        System.assertEquals(expected.Id, result.Id, 'Ids incorreto');
    }

    @IsTest
    static void testGetByAnalisesCredito() {
        AnaliseCredito__c analise = [
            SELECT Id
            FROM AnaliseCredito__c
        ];
 
        Test.startTest();
        List<Opportunity> result = OpportunityHelper.getByAnalisesCredito(new Set<Id>{ analise.Id });
        Test.stopTest();

        Opportunity expected = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE StageName = 'Pré-análise'
        ];

        System.assertEquals(expected.Id, result[0].Id, 'Ids incorreto');
    }

    @IsTest
    static void testGetByIds() {
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            WHERE StageName = 'Negociação'
        ];
 
        Test.startTest();
        List<Opportunity> result = OpportunityHelper.getByIds(new Set<Id>{ opp.Id });
        Test.stopTest();

        Opportunity expected = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE StageName = 'Negociação'
        ];

        System.assertEquals(expected.Id, result[0].Id, 'Ids incorreto');
    }


    
}