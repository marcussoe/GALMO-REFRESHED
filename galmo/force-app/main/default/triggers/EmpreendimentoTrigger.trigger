trigger EmpreendimentoTrigger on Enterprise__c (before insert, after insert, before update, after update) {
    EmpreendimentoTriggerHandler handler = new EmpreendimentoTriggerHandler();
    handler.run();
}