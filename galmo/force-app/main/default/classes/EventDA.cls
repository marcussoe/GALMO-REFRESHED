public with sharing class EventDA {
    public static List<Event> getAllEventByLead(Set<Id> leadIds) {
        return [SELECT Id, Subject, WhoId, StatusCompromisso__c FROM Event WHERE WhoId IN :leadIds AND Subject = 'Visita' AND StatusCompromisso__c = 'Realizada com Sucesso'];
    }  
}