trigger ParticipanteRoletaTrigger on ParticipanteRoleta__c (after insert, after update) {
    (new ParticipanteRoletaTriggerHandler()).run();
}