public with sharing class DistribuicaoComissaoSelector {


    public static List<DistribuicaoComissao__c> obterDistribuicoes(Set<Id> comissaoIds) {
        if (comissaoIds.isEmpty()) {
            return new List<DistribuicaoComissao__c>();
        }

        return [
            SELECT Id, Comissao__c, ValorComissaoPorcentagem__c
            FROM DistribuicaoComissao__c
            WHERE Comissao__c IN :comissaoIds
        ];
    }


    public static Map<Id, Comissao__c> obterComissoes(Set<Id> comissaoIds) {
        if (comissaoIds.isEmpty()) {
            return new Map<Id, Comissao__c>();
        }

        return new Map<Id, Comissao__c>([
            SELECT Id, ValorTotalComissaoPorcentagem__c
            FROM Comissao__c
            WHERE Id IN :comissaoIds
        ]);
    }
}