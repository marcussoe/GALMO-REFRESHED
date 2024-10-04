public without sharing class UserSelector {
    public static List<User> obterUsuariosPorIds(Set<Id> idsUsuarios) {
        return [SELECT Situacao__c, CanaisAtendimento__c FROM User WHERE Id IN :idsUsuarios];
    }
}