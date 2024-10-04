public without sharing class UnidadeSelector {
    public static List<Product2> obterUnidadesPorBloco(Id idBloco) {
        return [
            SELECT
                Name,
                Status__c,
                Andar__c,
                NumeroQuartos__c,
                ValorM2__c
            FROM Product2
            WHERE Bloco__c = :idBloco
        ];
    }
    public static List<Product2> pesquisarUnidadesPorBloco(Decimal searchKey, Id idBloco) {
        return [
            SELECT
                Id
            FROM Product2
        ];
    }
    public static List<Product2> buscarUnidades(String idTorre) {
        return [
            SELECT
                Name,
                Status__c,
                ExternalId,
                NumeroQuartos__c,
                Andar__c
            FROM Product2
            WHERE Bloco__c = :idTorre
        ];
    }
    public static List<Product2> obterUnidadesPorIdsEmpreendimentos(Set<Id> idsEmpreendimentos) {
        return [SELECT ExternalId, Bloco__r.ChaveExterna__c FROM Product2 WHERE Enterprise__c IN :idsEmpreendimentos];
    }
}