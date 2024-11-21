@IsTest
public with sharing class AnaliseCreditoDATest {
    
    @TestSetup
    static void setup() {
        RecordType rt = [
            SELECT Id 
            FROM RecordType 
            WHERE SobjectType = 'Contact' AND Name = 'Corretor'
        ];

        RecordType rtAcc = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' AND Name = 'Conta pessoal'
        ];
        
        Account accTest = TestDataFactory.gerarConta('HouseImobiliaria');
        Account acc = new Account();
        acc.Type = 'Cliente';
        acc.RecordTypeId = rtAcc.Id;
        acc.FirstName = 'teste';
        acc.LastName = 'teste';
        acc.PersonEmail = 'test.dev@elera.io';
        insert new List<Account> { accTest, acc };
        
        Contact cttTest = TestDataFactory.gerarContato(accTest, rt.Id);
        insert cttTest;
        
        Opportunity opp1 = TestDataFactory.gerarOportunidade(acc, cttTest);
        opp1.StageName = 'Pré-análise';
        insert opp1;

        AnaliseCredito__c analise1 = TestDataFactory.gerarAnaliseCredito(opp1);
        AnaliseCredito__c analise2 = TestDataFactory.gerarAnaliseCredito(opp1);
        analise2.Status__c = 'Aprovada';
        insert new List<AnaliseCredito__c> { analise1, analise2 };
    }

    @IsTest
    static void testGetById_Valid() {
        AnaliseCredito__c analise = [
            SELECT Id
            FROM AnaliseCredito__c
            LIMIT 1
        ];

        Test.startTest();
        List<AnaliseCredito__c> analiseRes = AnaliseCreditoDA.getById(new Set<Id> { analise.Id });
        Test.stopTest();

        System.assert(!analiseRes.isEmpty(), 'Deveria ao menos retornar uma análise.');
    }

    
    @IsTest
    static void testGetById_Invalid() {
        Test.startTest();
        List<AnaliseCredito__c> analiseRes = AnaliseCreditoDA.getById(new Set<Id>());
        Test.stopTest();

        System.assert(analiseRes.isEmpty(), 'Deveria retorar uma lista vazia.');
    }
}