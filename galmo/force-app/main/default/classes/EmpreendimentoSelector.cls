public class EmpreendimentoSelector {
    public static List<Enterprise__c> getEmpreendimentoRecords() {
        return [
            SELECT 
                Name
            FROM Enterprise__c 
            ORDER BY Name
        ];
    }

    public static List<Enterprise__c> obterEmpreendimentosPorIds(Set<Id> idsEmpreendimentos) {
        return [SELECT Name, ChaveExterna__c FROM Enterprise__c WHERE Id IN :idsEmpreendimentos];
    }

    public static Enterprise__c obterNomeEmpreendimentoById(Id idEmpreendimento) {
        return [
            SELECT 
                Name
            FROM Enterprise__c 
            WHERE Id = :idEmpreendimento
        ];
    }
}