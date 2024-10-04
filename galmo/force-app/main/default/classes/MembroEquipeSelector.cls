public without sharing class MembroEquipeSelector {
    public static List<MembroEquipe__c> obterMembrosPorIds(Set<Id> idUsuario, Set<Id> idEquipe) {
        return [
            SELECT 
                id, 
                Name, 
                Equipe__c, 
                Usuario__c
            FROM MembroEquipe__c
            WHERE
                Usuario__c IN : idUsuario AND 
                Equipe__c IN : idEquipe
        ];
    }
    
    public static List<MembroEquipe__c> obterMembrosPorIdsUsuarios(Set<Id> idsUsuarios) {
        return [SELECT Usuario__r.Name, Equipe__c, Usuario__c, Usuario__r.Situacao__c FROM MembroEquipe__c WHERE Usuario__c IN :idsUsuarios];
    }
}