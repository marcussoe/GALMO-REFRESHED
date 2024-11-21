@isTest
public with sharing class ParametrizarCriteriosServiceTest {
    
    @isTest
    public static void testGetVariacoesLimite(){

        Test.startTest();
        List<String> retorno = ParametrizarCriteriosService.getVariacoesLimite();
        Test.stopTest();

        Assert.areEqual(true, retorno.size() > 0, 'O retorno da consulta deve ter 1 ou mais registros.');
    }

    @isTest
    public static void testCriarConjuntoCriterios(){
        String objectJson = '{"nominal":10, "nominalVariacao":"Abaixo do limite"}';

        Object obj = JSON.deserializeUntyped(objectJson);

        test.startTest();
        ParametrizarCriteriosService.criarConjuntoCriterios(obj);
        test.stopTest();

        ConjuntoCriteriosAnalise__c criterio = [SELECT Id, valorNominal__c FROM ConjuntoCriteriosAnalise__c LIMIT 1];

        Assert.areEqual(10, criterio.valorNominal__c, 'O valores nominais devem ser iguais.');
    }

    @isTest
    public static void testTestarConjuntoCriterios(){
        Decimal valorTabela = 100;
        Decimal valorProposta = 80;

        Test.startTest();
        List<Double> retorno = ParametrizarCriteriosService.testarConjuntoCriterios(valorTabela, valorProposta);
        Test.stopTest();

        Assert.areEqual(20, retorno[0], 'A diferença entre os valores deve ser 20.');
    }
}